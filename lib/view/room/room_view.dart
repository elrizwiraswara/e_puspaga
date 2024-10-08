import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';

import '../../app/const/app_const.dart';
import '../../app/services/firebase/firestore/firestore_service.dart';
import '../../app/services/locator/locator.dart';
import '../../app/themes/app_colors.dart';
import '../../app/themes/app_text_style.dart';
import '../../app/utilities/console_log.dart';
import '../../app/widgets/app_dialog.dart';
import '../../app/widgets/app_logo.dart';
import '../../app/widgets/app_text_field.dart';
import '../../model/chat/chat_model.dart';
import '../../model/user/user_model.dart';
import '../home/widgets/profile_photo.dart';

class RoomView extends StatefulWidget {
  // {"schedule_id": scheduleId, "room_id": roomId, 'user': user, 'opponent_user': opponentUser}
  final Map arguments;

  const RoomView({super.key, required this.arguments});

  static const String routeName = '/room';

  @override
  RoomViewState createState() => RoomViewState();
}

class RoomViewState extends State<RoomView> {
  final config = <String, dynamic>{
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {'url': 'stun:stun1.l.google.com:19302'},
      {'url': 'stun:stun2.l.google.com:19302'},
      {'url': 'stun:stun3.l.google.com:19302'},
      {'url': 'stun:stun4.l.google.com:19302'},
    ],
  };

  final offerSdpConstraints = <String, dynamic>{
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  RTCPeerConnection? peerConnections;

  RTCVideoRenderer localStream = RTCVideoRenderer();
  RTCVideoRenderer remoteStreams = RTCVideoRenderer();

  final _firestoreService = locator<FirestoreService>();

  CollectionReference callCollection =
      FirebaseFirestore.instance.collection('rooms');

  DocumentReference<Object?>? room;

  String? roomId;
  UserModel? user;
  UserModel? opponentUser;

  final chatController = TextEditingController();

  List<ChatModel> chats = [];

  bool localVideoEnabled = true;
  bool localAudioEnabled = true;

  bool remoteVideoEnabled = true;
  bool remoteAudioEnabled = true;

  var localObjectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;
  var remoteObjectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
    super.initState();
  }

  @override
  void dispose() {
    peerConnections?.close();
    peerConnections?.dispose();
    super.dispose();
  }

  Future<void> init() async {
    roomId = widget.arguments['room_id'];
    user = widget.arguments['user'];
    opponentUser = widget.arguments['opponent_user'];

    await localStream.initialize();
    await getUserMedia().then((stream) {
      localStream.srcObject = stream;
    });

    await startCall();
  }

  Future<void> initConnection() async {
    remoteStreams = RTCVideoRenderer();
    await remoteStreams.initialize();

    await createRTCPeerConnection().then((pc) {
      peerConnections = pc;
    });

    await getUserMedia().then((stream) async {
      await peerConnections?.addStream(stream);
    });
  }

  Future<RTCPeerConnection> createRTCPeerConnection() async {
    final pc = await createPeerConnection(config, offerSdpConstraints);

    pc.onIceCandidate = (candidate) async {
      await _sendIceCandidate(candidate);
      consoleLog('[onIceCandidate].candidate $candidate ');
    };

    pc.onAddStream = (stream) {
      consoleLog('owner tag = ${stream.ownerTag}');
      consoleLog('stream.id = ${stream.id}');

      if (stream.ownerTag != 'local') {
        remoteStreams.srcObject = stream;
      } else {
        localStream.srcObject = stream;
      }

      consoleLog('[onAddStream].stream $stream ');
      setState(() {});
    };

    pc.onIceConnectionState = (state) async {
      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateClosed) {
        consoleLog('[pc.onIceConnectionState] removing...');

        if (remoteStreams.srcObject != null) {
          peerConnections?.removeStream(remoteStreams.srcObject!);
          remoteStreams.srcObject = null;
          setState(() {});
        }

        // Reset room
        startCall();

        consoleLog('[pc.onIceConnectionState] removed');
      }
    };

    return pc;
  }

  Future<MediaStream> getUserMedia() async {
    final constraints = <String, dynamic>{
      'audio': true,
      'video': true,
    };

    final stream = await navigator.mediaDevices.getUserMedia(constraints);

    consoleLog('user owner tag id = ${stream.ownerTag}');

    return stream;
  }

  Future<void> startCall() async {
    consoleLog('[startCall].start');

    await initSignaling();
    await initConnection();
    await createOffer();
    await listenSignaling();
    await listenIncomingCandidate();
    await listenIncomingChats();
  }

  Future<void> createOffer() async {
    final sessionDesc = await peerConnections?.createOffer();

    if (sessionDesc == null) {
      consoleLog('[startCall].sessionDesc $sessionDesc');
      return;
    }

    await peerConnections?.setLocalDescription(sessionDesc);

    await room!.set(
      {
        'offer': {
          'sdp': json.encode(parse(sessionDesc.sdp.toString())),
          'type': sessionDesc.type,
          'user_id': user?.id,
          'user_name': user?.name,
          'user_image_url': user?.imageUrl,
          'camera': localVideoEnabled,
          'audio': localAudioEnabled,
          'date_created': DateTime.now().toIso8601String(),
        }
      },
      SetOptions(merge: true),
    );
  }

  Future<void> initSignaling() async {
    opponentUser = null;
    setState(() {});

    await room?.snapshots().drain();

    room = callCollection.doc(roomId!);

    var schecule = await _firestoreService
        .getUserScheduleById(widget.arguments['schedule_id']);

    if ((schecule?.status ?? 0) > 1) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      AppDialog.showDialog(
        title: 'Sesi Telah Ditutup',
        text: 'Terima kasih telah menggunakan layanan kami',
      );
      return;
    }

    final doc = (await room!.get()).data() as Map<String, dynamic>?;

    if (doc != null) {
      await room!.collection('candidates').get().then((value) {
        for (var e in value.docs) {
          e.reference.delete();
        }
      });
      await room!.delete();
    }
  }

  Future<void> listenSignaling() async {
    room!.snapshots().listen((event) async {
      final data = event.data() as Map<String, dynamic>?;

      if (data == null) {
        return;
      }

      opponentUserDataListener(data);

      if (data.containsKey('offer') && data['offer']['user_id'] != user?.id) {
        if (!data.containsKey('answer')) {
          consoleLog('[listenSignaling].answerCall offer');
          answerCall(data['offer']);
          return;
        }
      }

      if (data.containsKey('answer') && data['answer']['user_id'] != user?.id) {
        consoleLog('[listenSignaling].answerCall answer');
        receiveCallAnswer(data['answer']);
        return;
      }
    });
  }

  Future<void> answerCall(Map<String, dynamic>? data) async {
    consoleLog('[answerCall].start');

    if (data == null) {
      consoleLog('[answerCall].data $data');
      return;
    }

    final sdp = write(json.decode(data['sdp']), null);
    final type = data['type'];

    await peerConnections?.setRemoteDescription(
      RTCSessionDescription(sdp, type),
    );

    final sessionDesc = await peerConnections?.createAnswer();

    if (sessionDesc == null) {
      consoleLog('[answerCall].sessionDesc $sessionDesc');
      return;
    }

    await peerConnections?.setLocalDescription(sessionDesc);

    if (data['type'] == 'offer') {
      await room!.set(
        {
          'answer': {
            'sdp': json.encode(parse(sessionDesc.sdp.toString())),
            'type': sessionDesc.type,
            'user_id': user?.id,
            'user_name': user?.name,
            'user_image_url': user?.imageUrl,
            'camera': localVideoEnabled,
            'audio': localAudioEnabled,
            'date_created': DateTime.now().toIso8601String(),
          }
        },
        SetOptions(merge: true),
      );
    }
  }

  Future<void> receiveCallAnswer(Map<String, dynamic>? data) async {
    consoleLog('[receiveCallAnswer].start');

    if (data == null) {
      consoleLog('[receiveCallAnswer].data $data');
      return;
    }

    final sdp = write(json.decode(data['sdp']), null);
    final type = data['type'];

    if (peerConnections?.signalingState ==
        RTCSignalingState.RTCSignalingStateHaveRemotePrAnswer) {
      await peerConnections?.close();
      await init();
      return;
    }

    await peerConnections?.setRemoteDescription(
      RTCSessionDescription(sdp, type),
    );
  }

  Future<void> listenIncomingCandidate() async {
    callCollection
        .doc(roomId!)
        .collection('candidates')
        .snapshots()
        .listen((event) async {
      for (var e in event.docChanges) {
        if (e.type == DocumentChangeType.added) {
          final data = e.doc.data();

          if (data != null) {
            await addCandidate(data);
          }
        }
      }
    });
  }

  Future<void> listenIncomingChats() async {
    callCollection
        .doc(roomId!)
        .collection('chats')
        .snapshots()
        .listen((event) async {
      for (var e in event.docChanges) {
        if (e.type == DocumentChangeType.added) {
          final data = e.doc.data();

          if (data != null) {
            var chat = ChatModel.fromJson(data);

            chats.add(chat);
            setState(() {});
          }
        }
      }
    });
  }

  Future<void> addCandidate(Map<String, dynamic>? data) async {
    if (data == null || peerConnections == null) {
      consoleLog(
          '[addCandidate].data: $data; peerConnections: $peerConnections');
      return;
    }

    final candidate = RTCIceCandidate(
      data['candidate'],
      data['sdpMid'],
      data['sdpMLineIndex'],
    );

    if ((await peerConnections!.getRemoteDescription()) != null) {
      consoleLog('[addCandidate].candidate added');
      await peerConnections!.addCandidate(candidate);
    }
  }

  Future<void> _sendIceCandidate(RTCIceCandidate candidate) async {
    final cdt = callCollection.doc(roomId!).collection('candidates');

    await cdt.doc().set({
      'candidate': candidate.candidate,
      'sdpMid': candidate.sdpMid,
      'sdpMLineIndex': candidate.sdpMLineIndex,
      'user_id': user?.id,
      'date_created': DateTime.now().toIso8601String(),
    });
  }

  void localAudioVideoController(String kind) async {
    peerConnections?.getLocalStreams().forEach((e) {
      e?.getTracks().forEach((f) {
        if (f.kind == kind) {
          if (f.enabled == true) {
            f.enabled = false;

            if (kind == 'video') {
              localVideoEnabled = false;
            } else {
              localAudioEnabled = false;
            }
          } else {
            f.enabled = true;

            if (kind == 'video') {
              localVideoEnabled = true;
            } else {
              localAudioEnabled = true;
            }
          }
        }
      });
    });

    localStream.srcObject?.getTracks().forEach((e) {
      if (e.kind == kind) {
        if (e.enabled == true) {
          e.enabled = false;
        } else {
          e.enabled = true;
        }
      }
    });

    var data = (await room!.get()).data() as Map<String, dynamic>?;

    if (data != null) {
      if (data.containsKey('offer') && data['offer']['user_id'] == user?.id) {
        await room!.set(
          {
            'offer': {
              'camera': localVideoEnabled,
              'audio': localAudioEnabled,
            }
          },
          SetOptions(merge: true),
        );
      }

      if (data.containsKey('answer') && data['answer']['user_id'] == user?.id) {
        await room!.set(
          {
            'answer': {
              'camera': localVideoEnabled,
              'audio': localAudioEnabled,
            }
          },
          SetOptions(merge: true),
        );
      }
    }

    setState(() {});
  }

  void opponentUserDataListener(Map<String, dynamic> data) {
    if (data.containsKey('offer') && data['offer']['user_id'] != user?.id) {
      opponentUserSetter(data['offer']);
      remoteAudioVideoEnabledListener(data['offer']);
    }

    if (data.containsKey('answer') && data['answer']['user_id'] != user?.id) {
      opponentUserSetter(data['answer']);
      remoteAudioVideoEnabledListener(data['answer']);
    }

    setState(() {});
  }

  void opponentUserSetter(Map<String, dynamic> data) {
    opponentUser = widget.arguments['opponent_user'];
    opponentUser?.id = data['user_id'];
    opponentUser?.name = data['user_name'];
    opponentUser?.imageUrl = data['user_image_url'];
    setState(() {});
  }

  void remoteAudioVideoEnabledListener(Map<String, dynamic> data) {
    if (data['camera'] != null) {
      remoteVideoEnabled = data['camera'];
    }
    if (data['audio'] != null) {
      remoteAudioEnabled = data['audio'];
    }
    setState(() {});
  }

  void onSubmitChat() async {
    final chatsCollection = callCollection.doc(roomId!).collection('chats');

    await chatsCollection.doc().set({
      'id': user?.id,
      'message': chatController.text,
      'date_created': DateTime.now().toIso8601String(),
    });

    chatController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenSize.width > 678 ? 32 : 24),
        child: Column(
          children: [
            const AppLogo(),
            const SizedBox(height: 32),
            screenSize.width > 678
                ? SizedBox(
                    height: screenSize.height - 150,
                    child: Row(
                      children: [
                        localVideoWidget(),
                        const SizedBox(width: 18),
                        remoteVideoWidget(),
                        const SizedBox(width: 18),
                        chatWidget(),
                      ],
                    ),
                  )
                : SizedBox(
                    width: screenSize.width,
                    height: 1200,
                    child: Column(
                      children: [
                        localVideoWidget(),
                        const SizedBox(height: 18),
                        remoteVideoWidget(),
                        const SizedBox(height: 18),
                        chatWidget(),
                      ],
                    ),
                  ),
            // SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget localVideoWidget() {
    return Expanded(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.blackLv3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: AppColors.blackLv4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ProfilePhoto(size: 36, imgUrl: user?.imageUrl),
                        const SizedBox(width: 12),
                        Text(
                          '${user?.name ?? '(Tanpa nama)'} (Anda)',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bold(size: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            localAudioVideoController('video');
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              localVideoEnabled
                                  ? Icons.videocam
                                  : Icons.videocam_off_rounded,
                              color: localVideoEnabled
                                  ? AppColors.blackLv1
                                  : AppColors.redLv1,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        GestureDetector(
                          onTap: () {
                            localAudioVideoController('audio');
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              localAudioEnabled
                                  ? Icons.mic
                                  : Icons.mic_off_rounded,
                              color: localAudioEnabled
                                  ? AppColors.blackLv1
                                  : AppColors.redLv1,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        GestureDetector(
                          onTap: () {
                            if (localObjectFit ==
                                RTCVideoViewObjectFit
                                    .RTCVideoViewObjectFitContain) {
                              localObjectFit = RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitCover;
                            } else {
                              localObjectFit = RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitContain;
                            }
                            setState(() {});
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              localObjectFit ==
                                      RTCVideoViewObjectFit
                                          .RTCVideoViewObjectFitContain
                                  ? Icons.fit_screen_outlined
                                  : Icons.fit_screen_rounded,
                              color: AppColors.blackLv1,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: RTCVideoView(
                    localStream,
                    mirror: true,
                    objectFit: localObjectFit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget remoteVideoWidget() {
    if (opponentUser == null) {
      return const SizedBox.shrink();
    }

    return Expanded(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.blackLv3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: AppColors.blackLv4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ProfilePhoto(
                          size: 36,
                          imgUrl: opponentUser?.imageUrl,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          opponentUser?.name ?? '(Tanpa nama)',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bold(size: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          color: Colors.transparent,
                          child: Icon(
                            remoteVideoEnabled
                                ? Icons.videocam
                                : Icons.videocam_off_rounded,
                            color: remoteVideoEnabled
                                ? AppColors.blackLv2
                                : AppColors.redLv2,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Container(
                          color: Colors.transparent,
                          child: Icon(
                            remoteAudioEnabled
                                ? Icons.mic
                                : Icons.mic_off_rounded,
                            color: remoteAudioEnabled
                                ? AppColors.blackLv2
                                : AppColors.redLv2,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 18),
                        GestureDetector(
                          onTap: () {
                            if (remoteObjectFit ==
                                RTCVideoViewObjectFit
                                    .RTCVideoViewObjectFitContain) {
                              remoteObjectFit = RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitCover;
                            } else {
                              remoteObjectFit = RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitContain;
                            }
                            setState(() {});
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              remoteObjectFit ==
                                      RTCVideoViewObjectFit
                                          .RTCVideoViewObjectFitContain
                                  ? Icons.fit_screen_outlined
                                  : Icons.fit_screen_rounded,
                              color: AppColors.blackLv1,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: RTCVideoView(
                    remoteStreams,
                    // mirror: true,
                    objectFit: remoteObjectFit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatWidget() {
    return Expanded(
      flex: screenSize.width > 678 ? 2 : 4,
      child: SizedBox(
        // width:  screenSize.width / 5,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: AppColors.blackLv3,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.blackLv4,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chat,
                        color: AppColors.blackLv1,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Chat',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.bold(
                          size: 16,
                          color: AppColors.blackLv1,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: Scrollbar(
                              thumbVisibility: true,
                              trackVisibility: true,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    ...List.generate(
                                      chats.length,
                                      (i) => chatBubble(
                                        chats[i].id == user?.id,
                                        chats[i].message ?? '',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.blackLv5,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  controller: chatController,
                                  hintText: 'Ketik pesan...',
                                  showBorder: false,
                                  minLines: 1,
                                  maxLines: 3,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (val) {
                                    onSubmitChat();
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  onSubmitChat();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: const Icon(
                                    Icons.send,
                                    color: AppColors.tangerineLv1,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chatBubble(bool isMe, String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: isMe
              ? const EdgeInsets.only(left: 40)
              : const EdgeInsets.only(right: 40),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 14,
          ),
          decoration: BoxDecoration(
            color: isMe ? AppColors.tangerineLv5 : AppColors.blackLv5,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: AppTextStyle.semibold(
              size: 14,
            ),
          ),
        ),
      ),
    );
  }
}

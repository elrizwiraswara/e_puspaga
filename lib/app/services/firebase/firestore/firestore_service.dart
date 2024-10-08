import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../model/schedule/schedule_model.dart';
import '../../../../model/user/gender_model.dart';
import '../../../../model/user/user_model.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // USER
  Future<UserModel?> getUser(String phone) async {
    return await firestore.collection('users').doc(phone).get().then((value) =>
        value.data() != null ? UserModel.fromJson(value.data()!) : null);
  }

  Future<List<UserModel>?> getAllConselor() async {
    return await firestore
        .collection('users')
        .where('role', isEqualTo: 1)
        .get()
        .then((value) {
      return value.docs.map((item) => UserModel.fromJson(item.data())).toList();
    });
  }

  Future<void> createOrUpdateUser(UserModel user) async {
    await firestore.collection('users').doc(user.phone).set(
          user.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> deleteUser(UserModel user) async {
    await firestore.collection('users').doc(user.id).delete();
  }

  // SERVICE TYPE
  Future<List<MenuItemModel>> getAllServiceType() async {
    return (await firestore.collection('service_types').get())
        .docs
        .map((item) => MenuItemModel.fromJson(item.data()))
        .toList();
  }

  Future<void> createOrUpdateServiceType(MenuItemModel service) async {
    await firestore.collection('service_types').doc(service.id).set(
          service.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> deleteServiceType(MenuItemModel service) async {
    await firestore.collection('service_types').doc(service.id).delete();
  }

  // SCHEDULE
  Future<void> createOrUpdateSchedule(ScheduleModel schedule) async {
    await firestore.collection('schedules').doc(schedule.id).set(
          schedule.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<List<ScheduleModel>?> getAllSchedule() async {
    return await firestore.collection('schedules').get().then((value) {
      return value.docs
          .map((item) => ScheduleModel.fromJson(item.data()))
          .toList();
    });
  }

  // SCHEDULE - CLIENT
  Future<ScheduleModel?> getUserScheduleById(String userId) async {
    return await firestore
        .collection('schedules')
        .where('client.id', isEqualTo: userId)
        .where('status', isLessThan: 3)
        .get()
        .then(
          (value) => value.docs.isNotEmpty
              ? ScheduleModel.fromJson(value.docs.first.data())
              : null,
        );
  }

  Future<List<ScheduleModel>?> getClientScheduleHistory(String userId) async {
    return await firestore
        .collection('schedules')
        .where('client.id', isEqualTo: userId)
        .where('status', isGreaterThan: 1)
        .get()
        .then((value) {
      return value.docs
          .map((item) => ScheduleModel.fromJson(item.data()))
          .toList();
    });
  }

  // SCHEDULE - CONSELOR
  Future<List<ScheduleModel>?> getIncomingSchedules(String userId) async {
    return await firestore
        .collection('schedules')
        .where('conselor.id', isEqualTo: userId)
        .where('status', isEqualTo: 1)
        .get()
        .then((value) {
      return value.docs
          .map((item) => ScheduleModel.fromJson(item.data()))
          .toList();
    });
  }

  Future<List<ScheduleModel>?> getConselorScheduleHistory(String userId) async {
    return await firestore
        .collection('schedules')
        .where('conselor.id', isEqualTo: userId)
        .where('status', isGreaterThan: 1)
        .get()
        .then((value) {
      return value.docs
          .map((item) => ScheduleModel.fromJson(item.data()))
          .toList();
    });
  }

  void scheduleListener(Function(QuerySnapshot<Map<String, dynamic>>)? onData) {
    firestore.collection('schedules').snapshots().listen(onData);
  }
}

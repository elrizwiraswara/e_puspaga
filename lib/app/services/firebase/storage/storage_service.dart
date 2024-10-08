import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/foundation.dart';

class StorageService {
  Future<dynamic> uploadUserPhoto(String phone, Uint8List data) async {
    storage.TaskSnapshot taskSnapshot;

    storage.Reference ref = storage.FirebaseStorage.instance
        .ref()
        .child('user_photos')
        .child('$phone.jpg');

    final metadata = storage.SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': phone},
    );

    taskSnapshot = await ref.putData(data, metadata);

    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<String> uploadProductImage(
    String productId,
    int i,
    String userId,
    String imgPath,
  ) async {
    storage.TaskSnapshot taskSnapshot;

    storage.Reference ref = storage.FirebaseStorage.instance
        .ref()
        .child('products')
        .child(productId)
        .child('ProductImage_$i.jpg');

    final metadata = storage.SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': imgPath, 'user-id': userId},
    );

    taskSnapshot = await ref.putFile(File(imgPath), metadata);

    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<String> uploadTransferProofImage(
    String transactionId,
    String userId,
    String imgPath,
  ) async {
    storage.TaskSnapshot taskSnapshot;

    storage.Reference ref = storage.FirebaseStorage.instance
        .ref()
        .child('transactions')
        .child(transactionId)
        .child('TransferProofImage_${DateTime.now()}.jpg');

    final metadata = storage.SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': imgPath, 'user-id': userId},
    );

    taskSnapshot = await ref.putFile(File(imgPath), metadata);

    return await taskSnapshot.ref.getDownloadURL();
  }
}

import 'package:get_it/get_it.dart';

import '../dialog/dialog_service.dart';
import '../firebase/auth/auth_service.dart';
import '../firebase/firestore/firestore_service.dart';
import '../firebase/storage/storage_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => StorageService());
}

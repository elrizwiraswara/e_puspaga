import 'package:get_it/get_it.dart';

import '../../../view_model/auth_view_model.dart';
import '../../../view_model/home_admin_view_model.dart';
import '../../../view_model/home_client_view_model.dart';
import '../../../view_model/home_conselor_view_model.dart';
import '../../../view_model/main_view_model.dart';
import '../../../view_model/profile_view_model.dart';
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
  locator.registerLazySingleton(() => MainViewModel());
  locator.registerLazySingleton(() => AuthViewModel());
  locator.registerLazySingleton(() => ProfileViewModel());
  locator.registerLazySingleton(() => HomeClientViewModel());
  locator.registerLazySingleton(() => HomeConselorViewModel());
  locator.registerLazySingleton(() => HomeAdminViewModel());
}

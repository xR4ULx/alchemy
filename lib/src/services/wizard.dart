import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:alchemy/src/models/user_model.dart';
import 'package:alchemy/src/util/notifications.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:alchemy/src/repository/user_repository.dart';

class Wizard {
  GetIt _getIt = GetIt.instance;
  User user;
  Signaling signaling;
  Notifications notifications;
  UserRepository userRepository;
  //MessagesProvider messagesProvider;

  Wizard() {
    setupSingletons();
    getInstances();
  }

  void setupSingletons() async {
    _getIt.registerLazySingleton<User>(() => User());
    _getIt.registerLazySingleton<Signaling>(() => Signaling());
    _getIt.registerLazySingleton<UserRepository>(() => UserRepository(
        user: GetIt.I.get<User>(), signaling: GetIt.I.get<Signaling>()));
    _getIt.registerLazySingleton<Notifications>(() => Notifications());
  }

  void getInstances() {
    user = GetIt.I.get<User>();
    signaling = GetIt.I.get<Signaling>();
    notifications = GetIt.I.get<Notifications>();
    userRepository = GetIt.I.get<UserRepository>();
  }

  Future uploadFile(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return await storageTaskSnapshot.ref.getDownloadURL();
  }
}

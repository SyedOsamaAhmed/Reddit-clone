import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auth/repositories/auth_repository.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthCController, bool>((ref) => AuthCController(
          authrepo: ref.watch(authRepositoryProvider),
          ref: ref,
        ));

final authStateChangeProvider = StreamProvider.autoDispose((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUsersData(uid);
});
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthCController extends StateNotifier<bool> {
  final AuthRepository _authrepo;
  final Ref _ref;

  AuthCController({required AuthRepository authrepo, required Ref ref})
      : _authrepo = authrepo,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authrepo.authStateChange;

  Stream<UserModel> getUsersData(String uid) {
    return _authrepo.getUsersData(uid);
  }

  void signInWithGoogle(BuildContext context, bool isFromLogin) async {
    state =
        true; //loading handling using statenotifier thats  why statenotifier provider
    final user = await _authrepo.signInWithGoogle(isFromLogin);
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.errorMessage),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void signInAsGuest(BuildContext context) async {
    state =
        true; //loading handling using statenotifier thats  why statenotifier provider
    final user = await _authrepo.signInGuest();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.errorMessage),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void logOut() async {
    _authrepo.logOut();
  }
}

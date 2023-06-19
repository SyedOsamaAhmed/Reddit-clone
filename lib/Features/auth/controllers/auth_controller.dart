import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auth/repositories/auth_repository.dart';

import '../../../core/utils.dart';

final authControllerProvider = Provider((ref) => AuthCController(
      authrepo: ref.read(authRepositoryProvider),
    ));

class AuthCController {
  final AuthRepository _authrepo;

  AuthCController({required AuthRepository authrepo}) : _authrepo = authrepo;

  void signInWithGoogle(BuildContext context) async {
    final user = await _authrepo.signInWithGoogle();
    user.fold(
      (l) => showSnackBar(context, l.errorMessage),
      (r) => null,
    );
  }
}

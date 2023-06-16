import 'package:reddit_clone/Features/auth/repositories/auth_repository.dart';

class AuthCController {
  final AuthRepository _authrepo;

  AuthCController({required AuthRepository authrepo}) : _authrepo = authrepo;

  void signInWithGoogle() {
    _authrepo.signInWithGoogle();
  }
}

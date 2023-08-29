import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:reddit_clone/core/constants.dart';

class SignInButton extends ConsumerWidget {
  final bool isLoginFromGoogle;
  const SignInButton({super.key, this.isLoginFromGoogle = true});

  void signInWithGoogle(WidgetRef ref, BuildContext context) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(context, isLoginFromGoogle);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(ref, context),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Text(
          "Continue with Google",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Pallete.greyColor,
            minimumSize: Size(MediaQuery.of(context).size.width, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
      ),
    );
  }
}

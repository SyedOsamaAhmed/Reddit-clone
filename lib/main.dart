import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/Features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/router.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getUserData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUsersData(data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ref.watch(themeNotifierProvider),
            routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
              if (data != null) {
                getUserData(ref, data);
                if (userModel != null) {
                  return loggedIn;
                }
              }
              return loggedOut;
            }),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}

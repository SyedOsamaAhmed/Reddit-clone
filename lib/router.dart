import 'package:flutter/material.dart';
import 'package:reddit_clone/Features/auth/UI/login.dart';
import 'package:routemaster/routemaster.dart';

final loggedOut = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: LoginScreen(),
      ),
});

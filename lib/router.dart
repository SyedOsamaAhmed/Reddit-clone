import 'package:flutter/material.dart';
import 'package:reddit_clone/Features/auth/UI/login.dart';
import 'package:reddit_clone/home/home.dart';
import 'package:routemaster/routemaster.dart';

final loggedOut = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: LoginScreen(),
      ),
});
final loggedIn = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: Home(),
      ),
});

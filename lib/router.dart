import 'package:flutter/material.dart';
import 'package:reddit_clone/Features/auth/UI/login.dart';
import 'package:reddit_clone/Features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/home/home.dart';
import 'package:routemaster/routemaster.dart';

import 'Features/community/screens/community_screen.dart';

final loggedOut = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: LoginScreen(),
      ),
});
final loggedIn = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: Home(),
      ),
  '/create-community': (_) => const MaterialPage(
        child: CreateCommunityScreen(),
      ),
  '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters['name']!,
        ),
      ),
});

import 'package:flutter/material.dart';
import 'package:reddit_clone/Features/auth/UI/login.dart';
import 'package:reddit_clone/Features/community/screens/add_mod_screen.dart';
import 'package:reddit_clone/Features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/Features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone/Features/community/screens/mod_tools_screen.dart';

import 'package:reddit_clone/Features/posts/screens/add_post_type.dart';
import 'package:reddit_clone/Features/posts/screens/comments_screen.dart';
import 'package:reddit_clone/Features/user_profiles/screens/edit_profile_screen.dart';
import 'package:reddit_clone/Features/user_profiles/screens/user_profile_screen.dart';
import 'package:reddit_clone/home/screens/home.dart';
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
  '/mod-tools/:name': (routeData) => MaterialPage(
        child: ModTools(name: routeData.pathParameters['name']!),
      ),
  '/edit-community/:name': (routeData) => MaterialPage(
        child: EditCommunity(name: routeData.pathParameters['name']!),
      ),
  '/add-mods/:name': (routeData) => MaterialPage(
        child: AddMod(name: routeData.pathParameters['name']!),
      ),
  '/u/:uid': (routeData) => MaterialPage(
        child: UserProfileScreen(uid: routeData.pathParameters['uid']!),
      ),
  '/edit-profile/:uid': (routeData) => MaterialPage(
        child: EditProfileScreen(uid: routeData.pathParameters['uid']!),
      ),
  '/add-post/:type': (routeData) => MaterialPage(
        child: AddPostTypeScreen(type: routeData.pathParameters['type']!),
      ),
  '/post/:postId/comments': (routeData) => MaterialPage(
        child: CommentsScreen(postId: routeData.pathParameters['postId']!),
      ),
});

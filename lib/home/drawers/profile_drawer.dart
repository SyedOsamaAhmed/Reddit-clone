import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 65,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'r/${user.name}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            ListTile(
              onTap: () => navigateToUserProfile(context, user.uid),
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
            ),
            ListTile(
              onTap: () => logOut(ref),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              title: const Text('LogOut'),
            ),
            Switch.adaptive(
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}

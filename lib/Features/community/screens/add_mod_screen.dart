import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/Features/community/controller/community_controller.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';

class AddMod extends ConsumerStatefulWidget {
  final String name;
  const AddMod({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModState();
}

class _AddModState extends ConsumerState<AddMod> {
  Set<String> uids = {};
  int counter = 0;

  void addUID(String uid) {
    uids.add(uid);
  }

  void removeUID(String uid) {
    uids.remove(uid);
  }

  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addMods(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityNameProvider(widget.name)).when(
            data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, index) {
                final member = community.members[index];

                return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.mods.contains(member) && counter == 0) {
                          uids.add(member);
                        }
                        counter++;
                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (value) {
                            if (value!) {
                              addUID(user.uid);
                            } else {
                              removeUID(user.uid);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () => const Loader(),
                    );
              },
            ),
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}

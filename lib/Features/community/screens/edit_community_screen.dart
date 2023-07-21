import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/community/controller/community_controller.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/core/constants.dart';
import 'package:reddit_clone/theme/pallete.dart';

class EditCommunity extends ConsumerStatefulWidget {
  final String name;
  const EditCommunity({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityState();
}

class _EditCommunityState extends ConsumerState<EditCommunity> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityNameProvider(widget.name)).when(
          data: (community) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Community'),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Save'),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            strokeCap: StrokeCap.round,
                            dashPattern: const [10, 4],
                            color: Pallete
                                .darkModeAppTheme.textTheme.bodyLarge!.color!,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: community.banner.isEmpty ||
                                      community.banner ==
                                          Constants.bannerDefault
                                  ? const Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 40,
                                      ),
                                    )
                                  : Image.network(community.banner),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                              radius: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}

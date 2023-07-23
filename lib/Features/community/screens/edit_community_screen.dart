import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/community/controller/community_controller.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/core/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/theme/pallete.dart';

import '../../../models/community.dart';

class EditCommunity extends ConsumerStatefulWidget {
  final String name;
  const EditCommunity({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityState();
}

class _EditCommunityState extends ConsumerState<EditCommunity> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          community: community,
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityNameProvider(widget.name)).when(
          data: (community) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Community'),
                actions: [
                  TextButton(
                    onPressed: () => save(community),
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
                          GestureDetector(
                            onTap: selectBannerImage,
                            child: DottedBorder(
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
                                child: bannerFile != null
                                    ? Image.file(bannerFile!)
                                    : community.banner.isEmpty ||
                                            community.banner ==
                                                Constants.bannerDefault
                                        ? const Center(
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 40,
                                            ),
                                          )
                                        : Image.network(
                                            community.banner,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: selectProfileImage,
                              child: profileFile != null
                                  ? CircleAvatar(
                                      backgroundImage: FileImage(profileFile!),
                                      radius: 26,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(community.avatar),
                                      radius: 26,
                                    ),
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

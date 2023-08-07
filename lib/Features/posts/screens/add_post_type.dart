import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/community/controller/community_controller.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';

import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final typeController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  Community? selectedCommunity;
  File? bannerFile;
  @override
  void dispose() {
    typeController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';

    final currentTheme = ref.watch(themeNotifierProvider);

    void selectBannerImage() async {
      final res = await pickImage();
      if (res != null) {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Share'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              maxLength: 30,
              controller: typeController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Enter title here',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (isTypeImage)
              GestureDetector(
                onTap: selectBannerImage,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  strokeCap: StrokeCap.round,
                  dashPattern: const [10, 4],
                  color: currentTheme.textTheme.bodyLarge!.color!,
                  child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: bannerFile != null
                          ? Image.file(
                              bannerFile!,
                            )
                          : const Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                              ),
                            )),
                ),
              ),
            if (isTypeText)
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter description here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLines: 5,
              ),
            const SizedBox(
              height: 10,
            ),
            if (isTypeLink)
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter url here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
            const SizedBox(
              height: 25,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text('Select Community'),
            ),
            ref.watch(userCommunityProvider).when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const SizedBox(
                        height: 10,
                      );
                    }

                    return DropdownButton(
                      value: selectedCommunity ?? data[0],
                      items: data
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCommunity = value;
                        });
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                )
          ],
        ),
      ),
    );
  }
}

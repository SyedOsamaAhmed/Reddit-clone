import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/posts/controller/post_controller.dart';
import 'package:reddit_clone/Features/posts/widgets/comment_card.dart';
import 'package:reddit_clone/common/error_text.dart';
import 'package:reddit_clone/common/loader.dart';
import 'package:reddit_clone/common/post_add_card.dart';
import 'package:reddit_clone/models/post.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;

  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComments(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );

    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostsbyIdProvider(widget.postId)).when(
            data: (data) {
              return Column(children: [
                PostCard(post: data),
                TextField(
                  onSubmitted: (value) => addComment(data),
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'Comment',
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
                ref.watch(getPostCommentsProvider(widget.postId)).when(
                      data: (data) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final comment = data[index];
                              return CommentCard(comment: comment);
                            },
                          ),
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () => const Loader(),
                    )
              ]);
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}

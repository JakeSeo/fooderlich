import 'package:flutter/material.dart';

import '../components/components.dart';
import '../models/models.dart';

class FriendPostTile extends StatelessWidget {
  final Post post;

  const FriendPostTile({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1 Create a "Row" to arrange the widgets horizontally.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 2 The first element is a circular avatar, which displays the image
        // asset associated with the "post".
        CircleImage(
          imageProvider: AssetImage(post.profileImageUrl),
          imageRadius: 20,
        ),
        // 3 Apply a 16-point padding.
        const SizedBox(width: 16),
        // 4 Create "Expanded", which makes the children fill the rest of the
        // container.
        Expanded(
          // 5 Establish a "Column" to arrange the widgets vertically.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 6 Create a "Text" to display your friend's comments.
              Text(post.comment),
              // 7 Create another "Text" to display the timestamp of a post.
              Text(
                '${post.timestamp} mins ago',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

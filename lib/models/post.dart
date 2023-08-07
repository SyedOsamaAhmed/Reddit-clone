// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String communityName;
  final String communityProfilePic;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentcount;
  final String username;
  final String uid;
  final String type;
  final DateTime createdAt;
  final List<String> award;
  Post({
    required this.id,
    required this.title,
    this.link,
    this.description,
    required this.communityName,
    required this.communityProfilePic,
    required this.upvotes,
    required this.downvotes,
    required this.commentcount,
    required this.username,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.award,
  });

  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? communityName,
    String? communityProfilePic,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commentcount,
    String? username,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? award,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentcount: commentcount ?? this.commentcount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      award: award ?? this.award,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'communityName': communityName,
      'communityProfilePic': communityProfilePic,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentcount': commentcount,
      'username': username,
      'uid': uid,
      'type': type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'award': award,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
        id: map['id'] as String,
        title: map['title'] as String,
        link: map['link'] != null ? map['link'] as String : null,
        description:
            map['description'] != null ? map['description'] as String : null,
        communityName: map['communityName'] as String,
        communityProfilePic: map['communityProfilePic'] as String,
        upvotes: List<String>.from((map['upvotes'] as List<String>)),
        downvotes: List<String>.from((map['downvotes'] as List<String>)),
        commentcount: map['commentcount'] as int,
        username: map['username'] as String,
        uid: map['uid'] as String,
        type: map['type'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        award: List<String>.from((map['award'] as List<String>)));
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, link: $link, description: $description, communityName: $communityName, communityProfilePic: $communityProfilePic, upvotes: $upvotes, downvotes: $downvotes, commentcount: $commentcount, username: $username, uid: $uid, type: $type, createdAt: $createdAt, award: $award)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.link == link &&
        other.description == description &&
        other.communityName == communityName &&
        other.communityProfilePic == communityProfilePic &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.downvotes, downvotes) &&
        other.commentcount == commentcount &&
        other.username == username &&
        other.uid == uid &&
        other.type == type &&
        other.createdAt == createdAt &&
        listEquals(other.award, award);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        link.hashCode ^
        description.hashCode ^
        communityName.hashCode ^
        communityProfilePic.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode ^
        commentcount.hashCode ^
        username.hashCode ^
        uid.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        award.hashCode;
  }
}

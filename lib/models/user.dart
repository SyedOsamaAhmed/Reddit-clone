import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String banner;
  final String profilePic;
  final String uid;
  final bool isGuest;
  final int karma;
  final List<String> awards;

  UserModel(
    this.name,
    this.banner,
    this.profilePic,
    this.uid,
    this.isGuest,
    this.karma,
    this.awards,
  );

  UserModel copyWith({
    String? name,
    String? banner,
    String? profilePic,
    String? uid,
    bool? isGuest,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      name ?? this.name,
      banner ?? this.banner,
      profilePic ?? this.profilePic,
      uid ?? this.uid,
      isGuest ?? this.isGuest,
      karma ?? this.karma,
      awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'banner': banner,
      'profilePic': profilePic,
      'uid': uid,
      'isGuest': isGuest,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        map['name'] as String,
        map['banner'] as String,
        map['profilePic'] as String,
        map['uid'] as String,
        map['isGuest'] as bool,
        map['karma'] as int,
        List<String>.from(
          (map['awards'] as List<String>),
        ));
  }

  @override
  String toString() {
    return 'UserModel(name: $name, banner: $banner, profilePic: $profilePic, uid: $uid, isGuest: $isGuest, karma: $karma, awards: $awards)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.banner == banner &&
        other.profilePic == profilePic &&
        other.uid == uid &&
        other.isGuest == isGuest &&
        other.karma == karma &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        banner.hashCode ^
        profilePic.hashCode ^
        uid.hashCode ^
        isGuest.hashCode ^
        karma.hashCode ^
        awards.hashCode;
  }
}

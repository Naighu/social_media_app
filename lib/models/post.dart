import 'package:social_media/constants/string.dart';

class Post {
  final String id;
  final String? description;
  final DateTime? created;
  final String? image;
  final PostUser user;
  Post(
      {required this.id,
      required this.description,
      required this.created,
      required this.user,
      required this.image});
  factory Post.fromJson(Map json) => Post(
      id: json['_id'],
      description: json['description'],
      user: PostUser.fromJson(json['user']),
      created: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at']),
      image: json['image'] == null ? null : kBaseUrl + '/' + json['image']);
}

class PostUser {
  final String id;
  final String name;
  final String username;

  PostUser({required this.id, required this.name, required this.username});
  factory PostUser.fromJson(Map json) =>
      PostUser(id: json['_id'], name: json['name'], username: json['username']);
}

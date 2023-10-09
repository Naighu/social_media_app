class User {
  final String id;
  final String? name;
  final String? username;
  final String mob;
  final List<String> following;
  final List<String> followers;

  User(
      {required this.id,
      this.name,
      required this.followers,
      required this.following,
      this.username,
      required this.mob});

  factory User.fromJson(Map json) => User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      followers: json['followers'] == null ? [] : List.from(json['followers']),
      following: json['following'] == null ? [] : List.from(json['following']),
      username: json['username'],
      mob: json['phone'] ?? '');

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'followers': followers,
        'following': following,
        'username': username,
        'phone': mob
      };
}

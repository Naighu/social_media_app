import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/domain/post/i_post_repo.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/screens/profile/profile_page.dart';
import 'package:social_media/utils/app_utils.dart';

class ListUsers extends StatelessWidget {
  final List<User> users;
  const ListUsers({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => UserCard(
              user: users[index],
              admin: getIt<User>(),
            ));
  }
}

class UserCard extends StatefulWidget {
  final User user;
  final User admin;
  const UserCard({super.key, required this.user, required this.admin});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late ValueNotifier followingNotifier;
  @override
  void initState() {
    followingNotifier =
        ValueNotifier(widget.admin.following.contains(widget.user.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      user: widget.user,
                      showLogout: false,
                    )));
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(kBorderRadius),
        ),
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.green,
            child: Text(
              widget.user.name!.characters.first,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            widget.user.username.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(widget.user.name.toString()),
          trailing: widget.admin.id == widget.user.id
              ? null
              : TextButton(
                  onPressed: () {
                    if (followingNotifier.value) {
                      _unfollow();
                    } else {
                      _follow();
                    }
                    followingNotifier.value = !followingNotifier.value;
                  },
                  child: ValueListenableBuilder(
                      valueListenable: followingNotifier,
                      builder: (context, _, __) {
                        return Text(
                            followingNotifier.value ? 'Unfollow' : 'Follow');
                      })),
        ),
      ),
    );
  }

  Future<void> _follow() async {
    final result = await getIt<IPostRepo>()
        .followUser(userid: widget.admin.id, followUser: widget.user.id);

    result.fold((l) {
      followingNotifier.value = false;
    }, (r) {
      widget.admin.following.add(widget.user.id);
      AppUtils.saveUserDetails(widget.admin);
    });
  }

  Future<void> _unfollow() async {
    final result = await getIt<IPostRepo>()
        .unFollowUser(userid: widget.admin.id, followUser: widget.user.id);

    result.fold((l) {
      followingNotifier.value = true;
    }, (r) {
      widget.admin.following.remove(widget.user.id);
      AppUtils.saveUserDetails(widget.admin);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:social_media/domain/auth/i_auth_repo.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/helper_widgets/view_profile/profile_display.dart';

class ViewMentionedUser extends StatelessWidget {
  final String username;
  const ViewMentionedUser({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: getIt<IAuthRepo>().getUserDetailsFromUsername(username),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            return snapshot.data!.fold(
                (l) => Center(
                      child: Text(l.message),
                    ),
                (r) => ProfileDisplay(user: r));
          }),
    );
  }
}

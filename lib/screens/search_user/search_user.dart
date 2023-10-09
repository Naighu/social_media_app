import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/domain/auth/i_auth_repo.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/helper_widgets/appbar.dart';
import 'package:social_media/helper_widgets/bottom_navigation/app_bottom_navigation.dart';

import '../../helper_widgets/list_users.dart';
import 'search_field.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  //Updating the search based on the user input
  final ValueNotifier<String?> valueNotifier = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: customAppbar(context),
      bottomNavigationBar: const AppBottombar(
        currentIndex: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: [
            kSizedBox,
            SizedBox(
                height: 50,
                child: SearchFieldWidget(
                  onChanged: (value) {
                    valueNotifier.value = value;
                  },
                )),
            kSizedBox,
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: valueNotifier,
                    builder: (context, _, __) {
                      return FutureBuilder(
                          future: getIt<IAuthRepo>()
                              .searchUsers(username: valueNotifier.value),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                                      child: Text(snapshot.error.toString()),
                                    ),
                                (r) => ListUsers(
                                      users: r,
                                    ));
                          });
                    }))
          ],
        ),
      ),
    ));
  }
}

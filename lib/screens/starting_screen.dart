import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:social_media/controller/home_controller.dart';
import 'package:social_media/domain/auth/i_auth_repo.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/screens/auth/login_page.dart';
import 'package:social_media/screens/auth/update_details.dart';
import 'package:social_media/screens/home/homepage.dart';
import 'package:social_media/utils/app_utils.dart';

import '../models/user.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AppUtils.getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Offstage();
          }

          ///If the user details are null then redirect to the loginpage
          if (snapshot.hasError || !snapshot.hasData) {
            return const LoginPage();
          }

          final user = snapshot.data!;
          if (!getIt.isRegistered<User>()) {
            getIt.registerSingleton(user);
          }

          ///If the name and username are null then redirect to the updateDetailspage
          if (user.name == null || user.username == null) {
            return UpdateDetailsPage(user: user);
          }

          //Inject the controller into memory
          Get.put(HomeController());

          //Fetch the data from the server
          getIt<IAuthRepo>().getUserDetails(user.id).then((value) {
            if (getIt.isRegistered<User>()) {
              getIt.unregister<User>();
            }
            getIt.registerSingleton(user);
          });
          return const Homepage();
        });
  }
}

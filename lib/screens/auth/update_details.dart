import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/domain/auth/i_auth_repo.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/screens/home/homepage.dart';
import 'package:social_media/utils/app_utils.dart';

import '../../helper_widgets/buttons/loading_button.dart';

class UpdateDetailsPage extends StatefulWidget {
  final User user;
  const UpdateDetailsPage({super.key, required this.user});

  @override
  State<UpdateDetailsPage> createState() => _UpdateDetailsPageState();
}

class _UpdateDetailsPageState extends State<UpdateDetailsPage> {
  late TextEditingController mobileController,
      usernameController,
      nameController;
  ValueNotifier<bool> loadingNotifier = ValueNotifier(false);
  @override
  void initState() {
    mobileController = TextEditingController();
    usernameController = TextEditingController();
    nameController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    mobileController.dispose();
    usernameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: SvgPicture.asset(
                        'assets/svg/Authentication-amico.svg')),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                                color: Colors.blue.withOpacity(0.3), width: 2),
                          ),
                          hintText: 'Username',
                          hintStyle: TextStyle(),
                        ),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                                color: Colors.blue.withOpacity(0.3), width: 2),
                          ),
                          hintText: 'You name',
                          hintStyle: TextStyle(),
                        ),
                      ),
                      ValueListenableBuilder(
                          valueListenable: loadingNotifier,
                          builder: (context, _, __) {
                            return LoadingButton(
                              width: 200,
                              loading: loadingNotifier.value,
                              onPressed: () {
                                if (loadingNotifier.value) {
                                  return;
                                }
                                _onLogin();
                              },
                              text: 'Next',
                            );
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _onLogin() async {
    final msg = _validate();
    if (msg != null) {
      Fluttertoast.showToast(msg: msg);
      return;
    }
    loadingNotifier.value = true;
    final result = await getIt<IAuthRepo>().updateDetails(
        userId: widget.user.id,
        name: nameController.text,
        username: usernameController.text);
    loadingNotifier.value = false;

    result.fold((l) {
      Fluttertoast.showToast(msg: l.message);
    }, (r) {
      AppUtils.saveUserDetails(r).then((data) => {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Homepage()))
          });
    });
  }

  String? _validate() {
    if (usernameController.text.isEmpty) {
      return 'Enter a username';
    }
    if (usernameController.text.contains(' ')) {
      return 'Username should not contain any spaces';
    }
    if (nameController.text.isEmpty) {
      return 'Enter your name';
    }
    return null;
  }
}

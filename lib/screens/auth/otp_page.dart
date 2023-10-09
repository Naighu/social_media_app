import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/domain/auth/i_auth_repo.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/helper_widgets/buttons/loading_button.dart';
import 'package:social_media/screens/auth/update_details.dart';
import 'package:social_media/screens/home/homepage.dart';
import 'package:social_media/utils/app_utils.dart';

import '../../controller/home_controller.dart';
import '../../models/user.dart';

class OtpPage extends StatefulWidget {
  final String mobile;
  const OtpPage({super.key, required this.mobile});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late TextEditingController _otpController;
  ValueNotifier<bool> loading = ValueNotifier(false);
  @override
  void initState() {
    _otpController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 45, 180),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: const Text(
                      'Social Media App',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    child: SvgPicture.asset(
                      'assets/svg/Secure login-amico.svg',
                    ),
                  ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.03, bottom: screenHeight * 0.01),
                    child: const Text('Verification',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  Text('OTP send to ${widget.mobile}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kHintTextColor)),
                  kSizedBox,
                  const Text('Since it is a demo app the default OTP is 123456',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  kSizedBox,
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _otpController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                                color: Colors.blue.withOpacity(0.3), width: 2),
                          ),
                          hintText: 'OTP',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kHintTextColor)),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: ValueListenableBuilder(
                          valueListenable: loading,
                          builder: (context, _, __) {
                            return LoadingButton(
                              width: 200,
                              loading: loading.value,
                              onPressed: () {
                                if (loading.value) {
                                  return;
                                }
                                _onLogin();
                              },
                              text: "Continue",
                            );
                          })),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    final msg = _validate();
    if (msg != null) {
      Fluttertoast.showToast(msg: msg);
      return;
    }

    loading.value = true;
    final result = await getIt<IAuthRepo>().login(mob: widget.mobile);
    loading.value = false;

    result.fold((l) {
      Fluttertoast.showToast(msg: l.message);
    }, (r) {
      if (getIt.isRegistered<User>()) {
        getIt.unregister<User>();
      }
      getIt.registerSingleton(r);
      AppUtils.saveUserDetails(r).then((value) {
        if (r.name == null || r.username == null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdateDetailsPage(
                        user: r,
                      )));
        } else {
          Get.put(HomeController());
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Homepage()));
        }
      });
    });
  }

  String? _validate() {
    if (_otpController.text.isEmpty) {
      return 'Enter the OTP';
    }
    if (int.tryParse(_otpController.text) == null) {
      return 'Enter a valid OTP';
    }
    if (_otpController.text.length != 6) {
      return 'Enter a 6 digit OTP';
    }
    return null;
  }
}

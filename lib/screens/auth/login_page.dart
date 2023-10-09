import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/helper_widgets/buttons/loading_button.dart';
import 'package:social_media/screens/auth/otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  final TextEditingController mobileController = TextEditingController();
  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
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
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: SvgPicture.asset(
                        'assets/svg/Authentication-amico.svg',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: DecoratedBox(
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
                            top: screenHeight * 0.03,
                            bottom: screenHeight * 0.01),
                        child: const Text('Login',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 37, 34, 34))),
                      ),
                      const Text('Enter your mobile number',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kHintTextColor)),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: mobileController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: BorderSide(
                                  color: Colors.blue.withOpacity(0.3),
                                  width: 2),
                            ),
                            hintText: 'Mobile number',
                            hintStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kHintTextColor),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.07),
                          child: LoadingButton(
                            loading: loading,
                            onPressed: () {
                              if (int.tryParse(mobileController.text) == null) {
                                Fluttertoast.showToast(
                                    msg: 'Enter a valid mobile number');
                                return;
                              }
                              _login();
                            },
                            text: "Continue",
                            width: 200,
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<void> _login() async {
    final msg = _validate();
    if (msg != null) {
      Fluttertoast.showToast(msg: msg);
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpPage(mobile: mobileController.text)));
  }

  String? _validate() {
    if (mobileController.text.isEmpty) {
      return 'Enter your phone number';
    }
    if (int.tryParse(mobileController.text) == null) {
      return 'Enter a valid mobile number';
    }
    if (mobileController.text.length != 10) {
      return 'Enter a 10 digit number';
    }
    return null;
  }
}

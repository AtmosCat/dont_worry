import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/signin/signin_page.dart';
import 'package:dont_worry/ui/pages/signup/signup_view_model.dart';
import 'package:dont_worry/ui/pages/signup/widgets/signup_text_formfield.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameEdittingController = TextEditingController();
  final emailEdittingController = TextEditingController();
  final passwordEdittingController = TextEditingController();
  final phoneNumberEdittingController = TextEditingController();

  @override
  void dispose() {
    nameEdittingController.dispose();
    emailEdittingController.dispose();
    passwordEdittingController.dispose();
    phoneNumberEdittingController.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.containerWhite.of(context),
      appBar: AppBar(
        backgroundColor: AppColor.containerWhite.of(context),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SigninPage(),
              ),
            );
          },
          icon: Padding(
            padding: const EdgeInsets.all(20),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColor.defaultBlack.of(context),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 25,
                  color: AppColor.primaryBlue.of(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              SignupTextFormfield(
                  controller: nameEdittingController, type: "이름"),
              SizedBox(height: 10),
              SignupTextFormfield(
                  controller: emailEdittingController, type: "이메일"),
              SizedBox(height: 10),
              SignupTextFormfield(
                  controller: passwordEdittingController, type: "비밀번호"),
              SizedBox(height: 10),
              SignupTextFormfield(
                  controller: phoneNumberEdittingController, type: "전화번호"),
              SizedBox(height: 50),
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryBlue.of(context),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      String name = nameEdittingController.text.trim();
                      String email = emailEdittingController.text.trim();
                      String password = passwordEdittingController.text.trim();
                      String phoneNumber =
                          phoneNumberEdittingController.text.trim();
                      if (name.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty ||
                          phoneNumber.isEmpty) {
                        SnackbarUtil.showSnackBar(context, "모든 항목을 입력해주세요.");
                        return;
                      } else {
                        final vm = ref.read(signupViewModel.notifier);
                        final result = await vm.signup(
                          context: context,
                          name: name,
                          email: email,
                          password: password,
                          phoneNumber: phoneNumber,
                        );
                        if (result) {
                          SnackbarUtil.showSnackBar(
                              context, "회원가입 성공! 로그인해주세요.");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SigninPage(),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: AppColor.containerWhite.of(context),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

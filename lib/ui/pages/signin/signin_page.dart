import 'package:dont_worry/theme/colors.dart';
import 'package:dont_worry/ui/pages/home/home_page.dart';
import 'package:dont_worry/ui/pages/signin/signin_view_model.dart';
import 'package:dont_worry/ui/pages/signin/widgets/signin_text_formfield.dart';
import 'package:dont_worry/ui/pages/signup/signup_page.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SigninPage extends StatefulWidget {
  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final emailEdittingController = TextEditingController();
  final passwordEdittingController = TextEditingController();

  @override
  void dispose() {
    emailEdittingController.dispose();
    passwordEdittingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.containerWhite.of(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '돈워리',
                style: TextStyle(
                  fontSize: 30,
                  color: AppColor.primaryBlue.of(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '개인 대출 전용 관리대장 서비스',
                style: TextStyle(
                  fontSize: 17,
                  color: AppColor.gray20.of(context),
                ),
              ),
              SizedBox(height: 40),
              SigninTextFormfield(
                  controller: emailEdittingController, type: '이메일'),
              SizedBox(height: 10),
              SigninTextFormfield(
                  controller: passwordEdittingController, type: '비밀번호'),
              SizedBox(height: 40),
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
                      String email = emailEdittingController.text.trim();
                      String password = passwordEdittingController.text.trim();
                      if (email.isEmpty || password.isEmpty) {
                        SnackbarUtil.showSnackBar(context, "모든 항목을 입력해주세요.");
                        return;
                      } else {
                        final vm = ref.read(signinViewModel.notifier);
                        final result = await vm.signin(
                          context: context,
                          email: email,
                          password: password,
                        );
                        if (result) {
                          SnackbarUtil.showSnackBar(context, "로그인 성공! 환영합니다. ");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        color: AppColor.containerWhite.of(context),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.containerGray30.of(context),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupPage(),
                    ),
                  );
                },
                child: Text(
                  '회원가입',
                  style: TextStyle(
                    color: AppColor.containerWhite.of(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextField SigninTextfield(BuildContext context, String hint) {
  return TextField(
    decoration: InputDecoration(
      labelText: hint,
      labelStyle: TextStyle(
        color: AppColor.defaultBlack.of(context),
        fontSize: 14,
      ),
      fillColor: AppColor.containerLightGray20.of(context),
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey, width: 0.1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue, width: 1.5),
      ),
    ),
  );
}

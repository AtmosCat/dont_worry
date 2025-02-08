import 'package:dont_worry/theme/colors.dart';
import 'package:flutter/material.dart';

class SigninTextFormfield extends StatelessWidget {
  TextEditingController controller;
  String type;

  SigninTextFormfield({
    required this.controller,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(type),
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
}

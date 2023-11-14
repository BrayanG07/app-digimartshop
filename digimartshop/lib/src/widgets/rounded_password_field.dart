import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class RoundedPasswordField extends StatelessWidget {
  RoundedPasswordField({ Key? key, required this.controller }) : super(key: key);
  final TextEditingController? controller;
  final RxBool isVisible = true.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFieldContainer(
      child: TextFormField(
        controller: controller,
        obscureText: isVisible.value,
        cursorColor: Constants.colorPrimary,
         decoration: InputDecoration(
            icon: Icon(
              Icons.lock,
              color: Constants.colorPrimary,
            ),
            hintText: "Password",
            hintStyle:  const TextStyle(fontFamily: 'OpenSans'),
            suffixIcon: InkWell(
              onTap: () => isVisible.value = !isVisible.value,
              child: Icon(
              Icons.visibility,
              color: Constants.colorPrimary,
            ),
            ) ,
            border: InputBorder.none),
      ),
    ));
  }
}
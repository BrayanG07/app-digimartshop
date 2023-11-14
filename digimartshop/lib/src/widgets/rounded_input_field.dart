import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class RoundedInputField extends StatelessWidget {
  const RoundedInputField({ Key? key, this.hintText, this.icon = Icons.person, required this.controller })
      : super(key: key);
  final String? hintText;
  final IconData icon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        cursorColor: Constants.colorPrimary,
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Constants.colorPrimary,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(fontFamily: 'OpenSans'),
            border: InputBorder.none),
      ),
    );
  }
}

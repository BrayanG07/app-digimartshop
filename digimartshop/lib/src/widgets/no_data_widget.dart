import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoDataWidget extends StatelessWidget {
  NoDataWidget({ Key? key,  required this.textMessage }) : super(key: key);
  final String textMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
              'assets/img/no_items.svg',
              height: 250,
              width: 250,
          ),
          const SizedBox(height: 15),
          Text(
            textMessage,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}

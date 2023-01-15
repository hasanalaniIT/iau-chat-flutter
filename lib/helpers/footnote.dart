import 'package:flutter/material.dart';

class MyFootNote extends StatelessWidget {
  const MyFootNote({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 55,
      child: const Align(
          alignment: Alignment.center,
          child: Text(
            'By Hasan Alani ♡',
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          )),
    );
  }
}

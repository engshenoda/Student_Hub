import 'package:flutter/material.dart';


class Header extends StatelessWidget {
  const Header({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 270,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFd9fff5),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(150),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 3))
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.only(left: 20, top:60),
        child: Text(
          "Create Account",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
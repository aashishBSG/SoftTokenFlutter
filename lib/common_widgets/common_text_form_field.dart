import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.keyboardType,
    required this.obscureText,
  });

  final bool obscureText;
  final TextInputType keyboardType;
  final String hintText;
  final String prefixIcon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              obscureText: obscureText,
              keyboardType: keyboardType,
              controller: controller,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                hintText: hintText,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Image.asset(
                    prefixIcon,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

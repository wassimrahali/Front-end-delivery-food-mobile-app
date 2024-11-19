import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PhoneFieldWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  PhoneFieldWidget({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: CupertinoColors.black,
      decoration: InputDecoration(
        hintText: "Phone Number",
        hintStyle: TextStyle(fontSize: 13, fontFamily: 'Urbanist-Regular',color: Colors.black),
        prefixIcon: Icon(Icons.phone_android_rounded,color: Colors.black,),
        filled: true,
        fillColor: Colors.grey[100],
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}

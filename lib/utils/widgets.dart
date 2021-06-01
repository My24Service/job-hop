import 'package:flutter/material.dart';


Future<dynamic> displayDialog(context, title, text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(text)
        );
      }
  );
}

import 'package:flutter/material.dart';

class AdminCustomFormField extends StatefulWidget {
  final void Function(String?) onSaved;
  final String hintText;
  final bool obscureText;
  const AdminCustomFormField(
      {super.key, required this.onSaved, required this.hintText, required this.obscureText});

  @override
  State<AdminCustomFormField> createState() => _AdminCustomFormFieldState();
}

class _AdminCustomFormFieldState extends State<AdminCustomFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: true,
      onSaved: widget.onSaved,
      obscureText: widget.obscureText,
      validator: (value){
        if(value != null){
          return null;
        }else{
          return "Enter ${widget.hintText}";
        }
      },
      decoration: InputDecoration(
        label: Text(widget.hintText),
        labelStyle: const TextStyle(color: Colors.black),
        hintText: widget.hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black)),
      ),
    );
  }
}

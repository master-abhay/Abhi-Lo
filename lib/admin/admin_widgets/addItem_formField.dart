import 'package:flutter/material.dart';

class AddItemFormField extends StatefulWidget {
  final String hintText;
  int? maxLines;
  final void Function(String?) onSaved;

   AddItemFormField(
      {super.key,
      required this.hintText,
      required this.onSaved,
        this.maxLines
      });

  @override
  State<AddItemFormField> createState() => _AddItemFormFieldState();
}

class _AddItemFormFieldState extends State<AddItemFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.05),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        onSaved: widget.onSaved,
        validator: (value){
          if(value != null && value.isNotEmpty){
            return null;
          }
          else{
            return "Enter ${widget.hintText}";
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          hintText: widget.hintText,
        ),
        maxLines: widget.maxLines != null ? widget.maxLines : 1,
      ),
    );
  }
}

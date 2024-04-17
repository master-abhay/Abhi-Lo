import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({super.key, required this.text, required this.isLoading,required this.onPressed,required this.buttonColor});

  final String text;
  final bool isLoading;
  final void Function() onPressed;
  final Color buttonColor;


  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.055,
      child: MaterialButton(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          widget.onPressed();
        },
        color: widget.buttonColor,
        child: widget.isLoading
            ? const CircularProgressIndicator(color: Colors.white,strokeWidth: 2,)
            : Text(
          widget.text,
          style: const TextStyle(color: Colors.white,fontSize: 19),
        ),
      ),
    );
  }
}

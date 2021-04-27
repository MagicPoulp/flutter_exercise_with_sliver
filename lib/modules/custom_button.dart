import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({ Key? key, required this.text, required this.image, required this.onPressed}) : super(key: key);

  final String text;
  final String image;
  final VoidCallback onPressed;

  // hard-coded colors should be moved to the them config, in the MaterialApp widget
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        onPressed();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(text, style: TextStyle(color: Colors.white),                                          ),
          const SizedBox(width: 8.0),
          Image.asset(image, width: 20, height: 20,)
        ],
      ),
    );
  }
}
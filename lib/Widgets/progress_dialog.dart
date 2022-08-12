import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String? message;
  const ProgressDialog({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.pink,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const SizedBox(
                width: 6,
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(
                width: 26.0,
              ),
              Text(
                message!,
                style: const TextStyle(color: Colors.black, fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}

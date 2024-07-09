import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool loading;
  const RoundedButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: loading
                ? const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.cyanAccent,
                  )
                : Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                  )),
      ),
    );
  }
}

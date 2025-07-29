import 'package:flutter/material.dart';

class NumberPadButton extends StatelessWidget {
  final String? number;
  final IconData? icon;
  final VoidCallback onPressed;

  const NumberPadButton({
    super.key,
    this.number,
    this.icon,
    required this.onPressed,
  }) : assert(
         (number != null) ^ (icon != null),
         'Either number or icon must be provided, but not both',
       );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: number != null
              ? Text(
                  number!,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                )
              : Icon(icon!, size: 24, color: Colors.grey[600]),
        ),
      ),
    );
  }
}

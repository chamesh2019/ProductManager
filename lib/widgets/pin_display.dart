import 'package:flutter/material.dart';

class PinDisplay extends StatelessWidget {
  final int pinLength;
  final int filledDots;

  const PinDisplay({
    super.key,
    required this.pinLength,
    required this.filledDots,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Enter your $pinLength-digit PIN',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pinLength,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < filledDots ? Colors.blue[600] : Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'number_pad_button.dart';

class NumberPad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;

  const NumberPad({
    super.key,
    required this.onNumberPressed,
    required this.onBackspacePressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            children: [
              // First row: 1, 2, 3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                ],
              ),
              const SizedBox(height: 10),
              // Second row: 4, 5, 6
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                ],
              ),
              const SizedBox(height: 10),
              // Third row: 7, 8, 9
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                ],
              ),
              const SizedBox(height: 10),
              // Fourth row: empty, 0, backspace
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 55), // Empty space
                  _buildButton('0'),
                  _buildBackspaceButton(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(String number) {
    return NumberPadButton(
      number: number,
      onPressed: () => onNumberPressed(number),
    );
  }

  Widget _buildBackspaceButton() {
    return NumberPadButton(
      icon: Icons.backspace_outlined,
      onPressed: onBackspacePressed,
    );
  }
}

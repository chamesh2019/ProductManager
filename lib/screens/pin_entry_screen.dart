import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/welcome_header.dart';
import '../widgets/pin_display.dart';
import '../widgets/number_pad.dart';

class PinEntryScreen extends StatefulWidget {
  final User user;
  final int pinLength;
  final Function(String)? onPinComplete;

  const PinEntryScreen({
    super.key,
    required this.user,
    this.pinLength = 6,
    this.onPinComplete,
  });

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String pin = '';

  void _onNumberPressed(String number) {
    if (pin.length < widget.pinLength) {
      setState(() {
        pin += number;
      });

      if (pin.length == widget.pinLength) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _onPinComplete();
        });
      }
    }
  }

  void _onBackspacePressed() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
      });
    }
  }

  void _onPinComplete() {
    if (widget.onPinComplete != null) {
      widget.onPinComplete!(pin);
    } else {
      // Default behavior - show dialog
      _showPinDialog();
    }
  }

  void _showPinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PIN Entered'),
        content: Text('PIN: $pin'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                pin = '';
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Top spacing
              SizedBox(height: screenHeight * 0.05),

              // User welcome section
              WelcomeHeader(user: widget.user),

              SizedBox(height: screenHeight * 0.03),

              // PIN display
              PinDisplay(pinLength: widget.pinLength, filledDots: pin.length),

              SizedBox(height: screenHeight * 0.03),

              // Number pad
              SizedBox(
                height: 260,
                child: NumberPad(
                  onNumberPressed: _onNumberPressed,
                  onBackspacePressed: _onBackspacePressed,
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

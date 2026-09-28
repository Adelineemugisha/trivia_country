import 'package:flutter/material.dart';
import '../viewmodels/game_controller.dart';

class AnswerButton extends StatelessWidget {
  final String countryName;
  final AnswerState answerState;
  final bool isCorrectAnswer;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.countryName,
    required this.answerState,
    required this.isCorrectAnswer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color textColor = Colors.black87;
    Color borderColor = Colors.grey.shade300;
    IconData? icon;

    switch (answerState) {
      case AnswerState.correct:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        borderColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case AnswerState.wrong:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade900;
        borderColor = Colors.red;
        icon = Icons.cancel;
        break;
      case AnswerState.revealed:
        if (isCorrectAnswer) {
          backgroundColor = Colors.green.shade100;
          textColor = Colors.green.shade900;
          borderColor = Colors.green;
          icon = Icons.check_circle;
        } else {
          backgroundColor = Colors.red.shade50;
          textColor = Colors.red.shade900;
          borderColor = Colors.red;
          icon = Icons.cancel;
        }
        break;
      case AnswerState.unanswered:
        break;
    }

    final bool isDisabled = answerState == AnswerState.correct ||
        answerState == AnswerState.revealed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            side: BorderSide(color: borderColor, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                countryName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

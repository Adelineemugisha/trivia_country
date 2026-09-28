import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/game_controller.dart';
import '../widgets/answer_button.dart';

class FlagTriviaScreen extends StatelessWidget {
  const FlagTriviaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Flag Trivia'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<GameController>(
        builder: (context, game, child) {
          if (game.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading countries...'),
                ],
              ),
            );
          }

          if (game.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${game.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => game.initialize(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Score and chances row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoCard(
                      'Score',
                      '${game.score}',
                      Icons.stars,
                      Colors.amber,
                    ),
                    _buildInfoCard(
                      'Chances',
                      '${game.chancesLeft}/3',
                      Icons.favorite,
                      Colors.red,
                    ),
                    _buildInfoCard(
                      'Question',
                      '${game.questionIndex + 1}',
                      Icons.help_outline,
                      Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Flag image
                if (game.correctCountry != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        game.correctCountry!.flagUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 48),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                // Question text
                const Text(
                  'Which country does this flag belong to?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Answer options
                ...game.options.map((country) {
                  final isCorrect = country == game.correctCountry;
                  return AnswerButton(
                    countryName: country.name,
                    answerState: game.answerState,
                    isCorrectAnswer: isCorrect,
                    onTap: () => game.selectAnswer(country),
                  );
                }),

                const SizedBox(height: 16),

                // Feedback message
                if (game.answerState == AnswerState.correct)
                  _buildFeedback(
                    'Correct! +${game.chancesLeft == 2 ? 8 : 5} points',
                    Colors.green,
                    Icons.check_circle,
                  )
                else if (game.answerState == AnswerState.wrong)
                  _buildFeedback(
                    'Wrong! ${game.chancesLeft} ${game.chancesLeft == 1 ? 'chance' : 'chances'} left',
                    Colors.orange,
                    Icons.warning,
                  )
                else if (game.answerState == AnswerState.revealed)
                  _buildFeedback(
                    'The correct answer is: ${game.correctCountry?.name ?? "Unknown"}',
                    Colors.red,
                    Icons.info,
                  ),

                // Next button
                if (game.answerState == AnswerState.correct ||
                    game.answerState == AnswerState.revealed)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => game.nextQuestion(),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next Question'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback(String message, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

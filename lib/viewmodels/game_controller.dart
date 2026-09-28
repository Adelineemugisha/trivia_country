import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/country.dart';
import '../services/country_service.dart';

enum AnswerState { unanswered, correct, wrong, revealed }

class GameController extends ChangeNotifier {
  final CountryService _countryService = CountryService();
  final Random _random = Random();

  List<Country> _allCountries = [];
  List<Country> _options = [];
  Country? _correctCountry;
  int _score = 0;
  int _chancesLeft = 3;
  int _questionIndex = 0;
  AnswerState _answerState = AnswerState.unanswered;
  bool _isLoading = true;
  String? _errorMessage;

  // Getters
  List<Country> get options => _options;
  Country? get correctCountry => _correctCountry;
  int get score => _score;
  int get chancesLeft => _chancesLeft;
  int get questionIndex => _questionIndex;
  AnswerState get answerState => _answerState;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allCountries = await _countryService.fetchCountries();
      _generateQuestion();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _generateQuestion() {
    if (_allCountries.length < 4) return;

    _correctCountry = _allCountries[_random.nextInt(_allCountries.length)];

    // Pick 3 random incorrect countries
    final incorrect = <Country>{};
    while (incorrect.length < 3) {
      final candidate = _allCountries[_random.nextInt(_allCountries.length)];
      if (candidate != _correctCountry) {
        incorrect.add(candidate);
      }
    }

    _options = [_correctCountry!, ...incorrect]..shuffle(_random);
    _chancesLeft = 3;
    _answerState = AnswerState.unanswered;
  }

  void selectAnswer(Country selected) {
    if (_answerState == AnswerState.correct ||
        _answerState == AnswerState.revealed) {
      return;
    }

    if (selected == _correctCountry) {
      // Correct answer
      if (_chancesLeft == 3) {
        _score += 8;
      } else if (_chancesLeft == 2) {
        _score += 5;
      }
      _answerState = AnswerState.correct;
    } else {
      // Wrong answer
      _chancesLeft--;
      if (_chancesLeft <= 0) {
        _answerState = AnswerState.revealed;
      } else {
        _answerState = AnswerState.wrong;
      }
    }
    notifyListeners();
  }

  void nextQuestion() {
    _questionIndex++;
    _generateQuestion();
    notifyListeners();
  }

  void resetGame() {
    _score = 0;
    _questionIndex = 0;
    _generateQuestion();
    notifyListeners();
  }
}

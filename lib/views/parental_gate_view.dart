import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../l10n/app_localizations.dart';

/// Parental Gate gemäß Apple Kids Category Guidelines
/// Verhindert versehentliche Taps von Kindern durch einfache mathematische Aufgabe
class ParentalGateView extends StatefulWidget {
  const ParentalGateView({super.key});

  @override
  State<ParentalGateView> createState() => _ParentalGateViewState();
}

class _ParentalGateViewState extends State<ParentalGateView> {
  late int _firstNumber;
  late int _secondNumber;
  final TextEditingController _answerController = TextEditingController();
  bool _showError = false;
  int _attempts = 0;

  int get _correctAnswer => _firstNumber + _secondNumber;

  @override
  void initState() {
    super.initState();
    _generateRandomQuestion();
    _answerController.addListener(() {
      if (_showError) {
        setState(() {
          _showError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _generateRandomQuestion() {
    // Einfache Addition mit Zahlen zwischen 5 und 15
    setState(() {
      _firstNumber = 5 + Random().nextInt(11); // 5-15
      _secondNumber = 5 + Random().nextInt(11); // 5-15
    });
  }

  void _checkAnswer() {
    final answer = int.tryParse(_answerController.text);

    if (answer == null) {
      setState(() {
        _showError = true;
      });
      return;
    }

    if (answer == _correctAnswer) {
      // Richtige Antwort - schließe mit Erfolg
      Navigator.of(context).pop(true);
    } else {
      // Falsche Antwort
      setState(() {
        _showError = true;
        _attempts++;
      });
      _answerController.clear();

      // Nach 3 Fehlversuchen neue Frage generieren
      if (_attempts >= 3) {
        _generateRandomQuestion();
        _attempts = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Titel
              Text(
                l10n.parentalGateTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Erklärung
              Text(
                l10n.parentalGateExplanation,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha:0.9),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Mathematische Aufgabe
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.parentalGateQuestion,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha:0.8),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      '$_firstNumber + $_secondNumber = ?',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Eingabefeld
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _answerController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Fehlermeldung
                    AnimatedOpacity(
                      opacity: _showError ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        l10n.parentalGateError,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Abbrechen Button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.grey.withValues(alpha:0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.parentalGateCancel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Prüfen Button
                  TextButton(
                    onPressed: _checkAnswer,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.parentalGateSubmit,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;



class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  String _currentLocale = 'en_US';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
          localeId: _currentLocale,
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text'),
        actions: [
          DropdownButton(
            onChanged: (selectedVal) {
              setState(() {
                _currentLocale = selectedVal!;
                if (_isListening) {
                  _startListening();
                }
              });
            },
            value: _currentLocale,
            items: const [
              DropdownMenuItem(
                value: 'en_US',
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: 'ml_IN',
                child: Text('Malayalam'),
              ),
              DropdownMenuItem(
                value: 'ta_IN',
                child: Text('Tamil'),
              ),
              DropdownMenuItem(
                value: 'hi_IN',
                child: Text('Hindi'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Text(
            _text,
            style: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startListening,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }
}
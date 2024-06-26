import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

class TimerScreen extends StatefulWidget {
  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Start";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.mode == WearMode.active
              ? Opacity(
                  opacity: 0.5, // Make the image more opaque
                  child: Image.asset(
                    'assets/images/background.jpeg',
                    fit: BoxFit.cover,
                  ),
                )
              : Container(color: Color.fromARGB(255, 146, 140, 140)),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.mode != WearMode.active)
                  Container(
                    width: 90.0, // Adjust the width as needed
                    height: 90.0, // Adjust the height as needed
                    child: Image.asset(
                      'assets/images/marie-aristocats.gif', // Path to your cat image
                      fit: BoxFit.contain,
                    ),
                  ),
                const SizedBox(height: 8.0), // Adding space between elements
                Text(
                  _strCount,
                  style: TextStyle(
                    fontFamily: 'Digital-7', // Ensure this font is available
                    fontSize: 18.0, // Adjusted font size for smartwatch
                    color: widget.mode == WearMode.active
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0), // Adding space between elements
                _buildWidgetButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetButton() {
    if (widget.mode == WearMode.active) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (_status == "Start") {
                    _startTimer();
                  } else if (_status == "Stop") {
                    _timer.cancel();
                    setState(() {
                      _status = "Continue";
                    });
                  } else if (_status == "Continue") {
                    _startTimer();
                  }
                },
                child: Text(
                  _status,
                  style: TextStyle(
                      fontSize: 10.0), // Adjusted font size for button
                ),
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _timer.cancel();
                  setState(() {
                    _count = 0;
                    _strCount = "00:00:00";
                    _status = "Start";
                  });
                },
                child: const Text(
                  "Reset",
                  style: TextStyle(
                      fontSize: 10.0), // Adjusted font size for button
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void _startTimer() {
    _status = "Stop";
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}

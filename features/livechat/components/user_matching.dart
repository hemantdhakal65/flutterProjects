import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/live_chat_provider.dart';
import '../services/geolocation_service.dart';
import '../services/matching_service.dart';
import 'decline_button.dart';

class UserMatching extends StatefulWidget {
  const UserMatching({super.key});

  @override
  State<UserMatching> createState() => _UserMatchingState();
}

class _UserMatchingState extends State<UserMatching> {
  Timer? _timer;
  int _countdown = 5;
  String _status = 'Finding nearby users...';

  @override
  void initState() {
    super.initState();
    _startMatching();
  }

  Future<void> _startMatching() async {
    // Reset countdown and status in case of retry
    setState(() {
      _countdown = 5;
      _status = 'Finding nearby users...';
    });

    final provider = Provider.of<LiveChatProvider>(context, listen: false);

    try {
      final position = await GeolocationService.getCurrentLocation();
      final match = await MatchingService.findMatch(
        position.latitude,
        position.longitude,
        null,
      );

      if (match != null) {
        provider.matchedUser = match;
        provider.isInitiator = true;
        setState(() => _status = 'Match found! Connecting...');

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_countdown <= 1) {
            timer.cancel();
            provider.callStatus = 'connecting';
          } else {
            setState(() => _countdown--);
          }
        });
      } else {
        setState(() => _status = 'No matches found. Try again later.');
      }
    } catch (e) {
      setState(() => _status = 'Error: ${e.toString()}');
    }
  }

  void _cancelMatching() {
    _timer?.cancel();
    final provider = Provider.of<LiveChatProvider>(context, listen: false);
    provider.reset();
    setState(() {
      _status = 'Matching cancelled.';
      _countdown = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(_status, style: const TextStyle(fontSize: 18)),
              if (_countdown > 0) ...[
                const SizedBox(height: 10),
                Text(
                  'Connecting in $_countdown...',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
              const SizedBox(height: 40),
              const Text(
                'Tips for better matching:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('• Enable location services'),
              const Text('• Add interests to your profile'),
              const Text('• Try during peak hours'),
              const SizedBox(height: 40),
              DeclineButton(
                onDecline: _cancelMatching,
                size: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FinancialFactSheet extends StatefulWidget {
  const FinancialFactSheet({super.key});

  @override
  State<FinancialFactSheet> createState() => _FinancialFactSheetState();
}

class _FinancialFactSheetState extends State<FinancialFactSheet> {
  static const _serverUrl = String.fromEnvironment('ASSISTANT_URL');

  bool _loading = true;
  String? _fact;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateFact();
  }

  Future<void> _generateFact() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (_serverUrl.isEmpty) {
        throw Exception('The assistant server address is missing.');
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Please log in to GoalDen first.');
      }

      final token = await user.getIdToken();
      if (token == null) {
        throw Exception('Please log in again.');
      }

      final response = await http.post(
        Uri.parse('$_serverUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // Preserves compatibility with the server's existing validation.
        body: jsonEncode({'message': 'Generate a financial fact.'}),
      ).timeout(const Duration(seconds: 35));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        throw Exception(data['error'] ?? 'Could not generate a fact.');
      }

      final reply = data['reply'];
      if (reply is! String || reply.trim().isEmpty) {
        throw Exception('No fact was returned. Please try again.');
      }

      if (!mounted) return;
      setState(() => _fact = reply.trim());
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.green),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Money Fact',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: SelectableText(
                  _fact ?? '',
                  style: const TextStyle(fontSize: 17, height: 1.5),
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Powered by AI',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _loading ? null : _generateFact,
              icon: const Icon(Icons.refresh),
              label: Text(_error != null ? 'Try again' : 'Another fact'),
            ),
          ],
        ),
      ),
    );
  }
}
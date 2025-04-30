import 'dart:io';

import 'package:altibbi/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Asksina extends StatefulWidget {
  const Asksina({Key? key}) : super(key: key);

  @override
  State<Asksina> createState() => _AsksinaState();
}

class _AsksinaState extends State<Asksina> {
  final TextEditingController _questionBodyController = TextEditingController();
  final ApiService _apiService = ApiService();

  String? _errorEmptyBody;
  String _chatSessionId = "";

  @override
  void dispose() {
    _questionBodyController.dispose();
    super.dispose();
  }

  Future<void> _createNewChatSession() async {
    try {
      final chatSession = await _apiService.createChat();
      setState(() {
        _chatSessionId = chatSession.id!;
      });
      print("createNewChatSession = $_chatSessionId");
    } catch (error) {
      _handleApiError(error);
    }
  }

  Future<void> _sendSinaMessage() async {
    if (_chatSessionId == null || _chatSessionId!.isEmpty) {
      setState(() {
        _errorEmptyBody = 'Please create a session first.';
      });
      return;
    }

    try {
      final chatResponse = await _apiService.sendSinaMessage(
          _questionBodyController.text, _chatSessionId!);
      print("sinaMessage = ${chatResponse.sinaMessage.text}");
      print("userMessage = ${chatResponse.userMessage.text}");
    } catch (error) {
      _handleApiError(error);
    }
  }

  Future<void> _getChatMessagesList() async {
    if (_chatSessionId == null || _chatSessionId!.isEmpty) {
      _showErrorSnackbar("No chat session is created.");
      return;
    }
    try {
      final chatMessages = await _apiService.getSinaChatMessages(
          sessionId: _chatSessionId
      );
      print("Consultation List Length = ${chatMessages.length}");
    } catch (error) {
      _handleApiError(error);
    }
  }

  void _handleApiError(Object error) {
    if (error is http.Response) {
      print("API Error - Status Code: ${error.statusCode}");
      _showErrorSnackbar("Error: ${error.statusCode}");
    } else {
      print("An unexpected error occurred: $error");
      _showErrorSnackbar("An unexpected error occurred.");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0099D1),
        title: const Text('Consultation Page'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildButton(
                text: "Create new chat session",
                onPressed: _createNewChatSession,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _questionBodyController,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  errorText: _errorEmptyBody,
                  hintText: "Enter Your question",
                  contentPadding: const EdgeInsets.all(20.0),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _buildButton(
                text: "Send new chat message",
                onPressed: _sendSinaMessage,
              ),
              const SizedBox(height: 20),
              _buildButton(
                text: "Get Chat messages list",
                onPressed: _getChatMessagesList,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0099D1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}

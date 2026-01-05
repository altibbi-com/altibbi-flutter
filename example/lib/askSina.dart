import 'dart:io';

import 'package:altibbi/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  String? mediaId;
  Future<void> _selectImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    if (source == ImageSource.camera) {
      final cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        final status = await Permission.camera.request();
        if (!status.isGranted) return;
      }
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      var media = await _apiService.uploadSinaMedia(File(image.path));
      setState(() {
        mediaId = media.id;
      });

    }
  }

  Future<void> _selectDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        var media = await _apiService.uploadSinaMedia(File(filePath));
        print(media.id);
        print("media.id");
        setState(() {
          mediaId = media.id;
        });
      }
    } catch (e) {
      print("Error picking document: $e");
      _showErrorSnackbar("Error picking document: $e");
    }
  }

  @override
  void dispose() {
    _questionBodyController.dispose();
    super.dispose();
  }

  Future<void> _createNewChatSession() async {
    try {
      final chatSession = await _apiService.createSinaSession();
      setState(() {
        _chatSessionId = chatSession.id!;
      });
      print("createNewChatSession = $_chatSessionId");
    } catch (error) {
      _handleApiError(error);
    }
  }

  Future<void> _sendSinaMessage() async {
    if (_chatSessionId.isEmpty) {
      setState(() {
        _errorEmptyBody = 'Please create a session first.';
      });
      return;
    }

    try {
      final chatResponse = await _apiService.sendSinaMessage(
          _questionBodyController.text, _chatSessionId, mediaId );
      print("sinaMessage = ${chatResponse.sinaMessage.text}");
      print("userMessage = ${chatResponse.userMessage.text}");
    } catch (error) {
      _handleApiError(error);
    }
  }

  Future<void> _getChatMessagesList() async {
    if (_chatSessionId.isEmpty) {
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
        title: const Text('Sina Page'),
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
              Row(
                children: [
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: _selectImage,
                    tooltip: 'Pick Image',
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.insert_drive_file),
                    onPressed: _selectDocument,
                    tooltip: 'Pick Document',
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0099D1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: _sendSinaMessage,
                        child: const Text(
                          "Send new chat message",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
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

import 'package:altibbi/model/consultation.dart';
import 'package:altibbi/service/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:altibbi/altibbi_chat.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


class MyChannelHandler extends GroupChannelHandler {
  final Function(BaseMessage) onChannelMessageReceived;
  final Consultation consultation;

  MyChannelHandler({required this.consultation, required this.onChannelMessageReceived});
  @override
  Future<void> onMessageReceived(BaseChannel channel, BaseMessage message) async {
    if(message.message.isNotEmpty){
            onChannelMessageReceived(message);
    }
  }
  @override
  Future<void> onTypingStatusUpdated(BaseChannel channel) async {
    print("typing started from Dr side");
  }

  @override
  Future<void> onUserLeft(BaseChannel channel, User user) async {
    print("Chat finished");
  }
}

class MyConnectionHandler extends ConnectionHandler {
  final Function(String)? onConnectionError;
  final Function()? onReconnectFailed;
  final Function(String)? onDisconnectedCallback;

  MyConnectionHandler({
    this.onConnectionError,
    this.onReconnectFailed,
    this.onDisconnectedCallback,
  });

  @override
  void onConnected(String userId, bool isReconnection) {
    print('Sendbird connected: userId=$userId, isReconnection=$isReconnection');
  }

  @override
  void onDisconnected(String userId) {
    print('Sendbird disconnected: userId=$userId');
    onDisconnectedCallback?.call(userId);
  }

  @override
  void onReconnectStarted() {
    print('Sendbird reconnection started');
  }

  @override
  void onReconnectSucceeded() {
    print('Sendbird reconnection succeeded');
  }

  @override
  void onReconnectFailed() {
    print('Sendbird reconnection failed');
    onReconnectFailed?.call();
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<BaseMessage> messages = [];

  final TextEditingController _textEditingController = TextEditingController();
  late Map channelUrl = {};
  late GroupChannel groupChannels;

  var consultation;
  bool _isConnected = false;
  String? _connectionError;

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeSendbird();
  }

  @override
  void dispose() {
    AltibbiChat().removeConnectionHandler('myConnectionHandler');
    AltibbiChat().removeChannelHandler('myChannelHandler');
    super.dispose();
  }

  void _scrollToBottom() {
    // Delay the scroll animation to allow the list to update
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> initializeSendbird() async {
    try {
      consultation = await ApiService().getLastConsultation();

      MyConnectionHandler connectionHandler = MyConnectionHandler(
        onConnectionError: (String error) {
          setState(() {
            _connectionError = error;
            _isConnected = false;
          });
          print('Connection error: $error');
        },
        onReconnectFailed: () {
          setState(() {
            _connectionError = 'Reconnection failed. Please check your connection.';
            _isConnected = false;
          });
          print('Reconnection failed');
          _attemptReconnection();
        },
        onDisconnectedCallback: (String userId) {
          setState(() {
            _isConnected = false;
          });
          print('Disconnected: $userId');
        },
      );
      AltibbiChat().addConnectionHandler('myConnectionHandler', connectionHandler);

      try {
        await AltibbiChat().init(consultation: consultation);
        setState(() {
          _isConnected = true;
          _connectionError = null;
        });
        print('Sendbird initialized successfully');
      } on ConnectionCanceledException catch (e) {
        setState(() {
          _connectionError = 'Connection was canceled. Error code: ${e.code}';
          _isConnected = false;
        });
        print('ConnectionCanceledException: ${e.code} - ${e.message}');
        _attemptReconnection();
      } on LoginTimeoutException catch (e) {
        setState(() {
          _connectionError = 'Login timeout. Please check your network connection. Error code: ${e.code}';
          _isConnected = false;
        });
        print('LoginTimeoutException: ${e.code} - ${e.message}');
        _attemptReconnection();
      } catch (e) {
        setState(() {
          _connectionError = 'Failed to initialize Sendbird: $e';
          _isConnected = false;
        });
        print('Error initializing Sendbird: $e');
      }

      try {
        MyChannelHandler channelHandler = MyChannelHandler(
          onChannelMessageReceived: (BaseMessage message) {
            setState(() {
              messages.add(message);
              _scrollToBottom();
            });
          },
          consultation: consultation,
        );
        AltibbiChat().addChannelHandler('myChannelHandler', channelHandler);
      } catch (e) {
        print('Error setting up channel handler: $e');
      }

      try {
        PreviousMessageListQuery previousMessageListQuery = PreviousMessageListQuery(
          channelType: ChannelType.group,
          channelUrl: "channel_${consultation.chatConfig!.groupId!}",
        );
        previousMessageListQuery.limit = 200;
        var fetchedMessages = await previousMessageListQuery.next();
        List<BaseMessage> allMessages = [];
        while (fetchedMessages.isNotEmpty) {
          allMessages.addAll(fetchedMessages);
          fetchedMessages = await previousMessageListQuery.next();
        }
        setState(() {
          messages = allMessages.reversed.toList();
        });
      } catch (e) {
        print('Error loading previous messages: $e');
      }
    } catch (e) {
      setState(() {
        _connectionError = 'Failed to load consultation: $e';
      });
      print('Error in initializeSendbird: $e');
    }
  }

  Future<void> _attemptReconnection() async {
    try {
      print('Attempting to reconnect...');
      bool reconnected = await AltibbiChat().reconnect();
      if (reconnected) {
        setState(() {
          _isConnected = true;
          _connectionError = null;
        });
        print('Reconnection successful');
      } else {
        setState(() {
          _connectionError = 'Reconnection failed. Please try again later.';
        });
        print('Reconnection failed');
      }
    } catch (e) {
      setState(() {
        _connectionError = 'Reconnection error: $e';
      });
      print('Error during reconnection: $e');
    }
  }

  Future<void> _sendMessage(String message) async {
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not connected. Please wait for connection to be established.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (message.trim().isEmpty) {
      return;
    }

    try {
      GroupChannel groupChannels = await AltibbiChat().getGroupChannel(consultation);
      var msg = await groupChannels.sendUserMessage(UserMessageCreateParams(message: message));
      setState(() {
        messages.add(msg);
        _textEditingController.clear();
      });
      if (messages.length > 5) {
        _scrollToBottom();
      }
    } on ConnectionCanceledException catch (e) {
      setState(() {
        _isConnected = false;
        _connectionError = 'Connection canceled while sending message. Error code: ${e.code}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: Connection canceled'),
          backgroundColor: Colors.red,
        ),
      );
      _attemptReconnection();
    } on LoginTimeoutException catch (e) {
      setState(() {
        _isConnected = false;
        _connectionError = 'Login timeout while sending message. Error code: ${e.code}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: Login timeout'),
          backgroundColor: Colors.red,
        ),
      );
      _attemptReconnection();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? path;

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
      setState(() {
        path = image.path;
      });
      if (path != null) {
        var media = await ApiService().uploadMedia(File(path!));
        _sendMessage(media.url.toString());
      }
    }
  }



  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  _isConnected ? Icons.wifi : Icons.wifi_off,
                  color: _isConnected ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  _isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    color: _isConnected ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_connectionError != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              color: Colors.orange,
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _connectionError!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _attemptReconnection,
                    tooltip: 'Retry connection',
                  ),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 500)),
              builder: (context, snapshot) {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    final isSentMessage = consultation.chatConfig!.chatUserId! == message.sender!.userId;
                    if (message.message.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: isSentMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(18.0),
                                decoration: BoxDecoration(
                                  color: isSentMessage ? Colors.blueGrey[200] : Colors.green[200],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  message.message,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message',
                    ),
                    // handle text change to send user typing status
                    onChanged: (String text) async {
                      if (!_isConnected) return;
                      try {
                        GroupChannel groupChannels = await AltibbiChat().getGroupChannel(consultation);
                        groupChannels.startTyping();
                      } catch (e) {
                        print('Error starting typing indicator: $e');
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _sendMessage(_textEditingController.text);
                    _textEditingController.clear();
                  },
                  child: const Text('Send'),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _selectImage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

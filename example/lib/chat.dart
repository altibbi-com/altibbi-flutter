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

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeSendbird();
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
    consultation = await ApiService().getLastConsultation();
    try {
      AltibbiChat().init(consultation: consultation);
    } catch (e){
    }
    try{
      MyChannelHandler channelHandler = MyChannelHandler(
          onChannelMessageReceived: (BaseMessage message) {
            setState(() {
              messages.add(message);
              _scrollToBottom();
            });
          },
          consultation: consultation
      );
      AltibbiChat().addChannelHandler('myChannelHandler', channelHandler);
    }catch(e){
    }

    try{
      PreviousMessageListQuery previousMessageListQuery = PreviousMessageListQuery(channelType: ChannelType.group,
          channelUrl: "channel_${consultation.chatConfig!.groupId!}");
      previousMessageListQuery.limit = 200;
      var messages = await previousMessageListQuery.next();
      while (messages.isNotEmpty) {
        messages.addAll(messages);
        messages = await previousMessageListQuery.next();
      }
    }catch(e){
    }

  }

  Future<void> _sendMessage(String message) async {

    try{
      GroupChannel groupChannels = await AltibbiChat().getGroupChannel(consultation);
      var msg = groupChannels.sendUserMessage(UserMessageCreateParams(message: message));
      setState(() {
        messages.add(msg);
        _textEditingController.clear();
      });
      if(messages.length >5){
        _scrollToBottom();
      }
    }catch(e){
    }

    try{
      PreviousMessageListQuery previousMessageListQuery = PreviousMessageListQuery(channelType: ChannelType.group,
          channelUrl: "channel_${consultation.chatConfig!.groupId!}");
      previousMessageListQuery.limit = 200;
      var messages = await previousMessageListQuery.next();
      while (messages.isNotEmpty) {
        messages.addAll(messages);
        messages = await previousMessageListQuery.next();
      }


    }catch(e){
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
      ),
      body: Column(
        children: [
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
                      try{
                        GroupChannel groupChannels = await AltibbiChat().getGroupChannel(consultation);
                        groupChannels.startTyping();
                      }catch(e){
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

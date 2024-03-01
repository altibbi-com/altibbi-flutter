import 'dart:convert';

import 'package:altibbi/pusher.dart';
import 'package:altibbi/service/api_service.dart';
import 'package:altibbi_example/video.dart';
import 'package:flutter/material.dart';

import 'chat.dart';
import 'model.dart';

class WaitingRoom extends StatefulWidget {
  final String pusherID;
  final int id;
  final String pusherApiKey;

  const WaitingRoom({required this.pusherID , required this.id , required this.pusherApiKey});

  @override
  _WaitingRoomState createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  ApiService apiService = ApiService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPusher();
  }

  void initPusher () {
    Pusher().init(onEvent:onEvent ,channelName: widget.pusherID , apiKey: widget.pusherApiKey);
  }

  void onEvent(event) async {
    print("event Name = " + event.eventName);
    if(event != null && event.eventName == "subscription_succeeded"){
      print("event Name = " + event.eventName);
      print(event);
    }else if(event != null && event.eventName == "call-status"){
      print("event Name = " + event.eventName);
      print(event);
    }else if (event != null && event.eventName == "video-conference-ready"){
      VideoData data = VideoData.fromJson(jsonDecode(event.data));
      Navigator.push(
        context,
          MaterialPageRoute(builder: (context) =>
              VideoPage(
                consultationID: widget.id,
                voip: false,
                apikey: data.apiKey!,
                token: data.token!,
                callID: data.callId!,
              )),
      );
    }else if (event != null && event.eventName == "voip-conference-ready"){
      VideoData data = VideoData.fromJson(jsonDecode(event.data));
      print("event.data");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            VideoPage(
              consultationID: widget.id,
              voip: true,
              apikey: data.apiKey!,
              token: data.token!,
              callID: data.callId!,
            )),
      );
    }else if (event != null && event.eventName == "chat-conference-ready"){
      VideoData data = VideoData.fromJson(jsonDecode(event.data));
      print("event.data");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            const ChatScreen(
              // apikey: data.apiKey!,
              // token: data.token!,
              // callID: data.callId!,
            )),
      );
    }
  }

  void cancelConsultation () async {
    final cancelValue = await apiService.cancelConsultation(widget.id);
    if(cancelValue == true)
      Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child:  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(), // Loader
                  SizedBox(height: 20),
                  Expanded(
                    child: Text(
                      "waiting for the doctor to accept ",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0099D1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: cancelConsultation,
                      child: const Text(
                        "cancel Consultation",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

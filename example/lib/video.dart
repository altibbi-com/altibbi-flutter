import 'dart:math';

import 'package:altibbi/altibbi_video.dart';
import 'package:altibbi/service/api_service.dart';
import 'package:altibbi/video_view.dart';
import 'package:altibbi_example/consultation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoPage extends StatefulWidget {
  final String apikey;
  final String callID;
  final String token;
  final int consultationID;
  final bool voip;
  const VideoPage({Key? key , required this.consultationID, required this.apikey,  required this.callID, required this.token , required this.voip}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with WidgetsBindingObserver {
  late VideoConfig _config;
  VideoController? _controller;
  bool isFullScreen = true;

  bool audioEnabled = true;
  bool videoEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _controller?.resume();
        break;
      case AppLifecycleState.paused:
        _controller?.pause();
        break;
      default:
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _config = VideoConfig(
      apiKey: widget.apikey,
      sessionId:widget.callID,
      token: widget.token,
    );

    _controller = VideoController();

    _controller?.stateUpdateCallBack = (ConnectionStateCallback stateUpdate) async {
      if (stateUpdate.state.toString() == "ConnectionState.loggedIn" && widget.voip){
        _controller?.toggleVideo(false);
        setState(() => videoEnabled = false);
      }
    };
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final cameraStatus = await Permission.camera.status;
      final microphoneStatus = await Permission.microphone.status;

      if (cameraStatus.isGranted && microphoneStatus.isGranted) {
        _controller?.initSession(_config);
        return;
      }
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();
      final finalCameraStatus = await Permission.camera.status;
      final finalMicrophoneStatus = await Permission.microphone.status;

      final isGranted =
          finalCameraStatus.isGranted && finalMicrophoneStatus.isGranted;

      if (isGranted) {
        _controller?.initSession(_config);
      } else {
        debugPrint(
            "Camera or Microphone permission or both denied by the user!");
        debugPrint("Camera status: $finalCameraStatus, Microphone status: $finalMicrophoneStatus");
      }
    });
  }

  void videoControl (isEnabled){
    _controller?.toggleVideo(!isEnabled);
    setState(() => videoEnabled = !isEnabled);
  }
  void endSession () async {
    try {
      await ApiService().cancelConsultation(widget.consultationID);
    } catch (e) {
      debugPrint("endSession error $e");
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Consultation()),
          (Route<dynamic> route) => false,
    );
  }
  void onCameraButtonTap (){
    _controller?.toggleCamera();
  }
 void onMicButtonTap (isEnabled){
   _controller?.toggleAudio(!isEnabled);
   setState(() => audioEnabled = !isEnabled);
  }
   void onFullScreenButtonTap (){
     setState(() => isFullScreen = !isFullScreen);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),

      ),
      body: Column(
        children: [
          Flexible(
            child: SizedBox(
              height: isFullScreen
                  ? MediaQuery.of(context).size.height
                  : MediaQuery.of(context).size.height * 0.5,
              child: VideoView(
                controller: _controller ?? VideoController(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:const EdgeInsets.all(10.0),
              child: Wrap(
                direction:  Axis.horizontal,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing:10,
                children:widget.voip ? [
                  ElevatedButton(
                    onPressed: endSession,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder()),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(10.0),
                      ),
                      elevation: MaterialStateProperty.all<double>(8.0),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: const Icon(Icons.call_end),
                  ),
                  ElevatedButton(
                    onPressed: () => onMicButtonTap.call(audioEnabled),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder()),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(10.0),
                      ),
                      elevation: MaterialStateProperty.all<double>(8.0),
                    ),
                    child:audioEnabled
                        ? const Icon(Icons.mic)
                        : const Icon(Icons.mic_off),
                  ),
                ] : [
                  ElevatedButton(
                    onPressed: endSession,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder()),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(10.0),
                      ),
                      elevation: MaterialStateProperty.all<double>(8.0),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: const Icon(Icons.call_end),
                  ),
                  ElevatedButton(
                    onPressed: onCameraButtonTap,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder()),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(10.0),
                      ),
                      elevation: MaterialStateProperty.all<double>(8.0),
                    ),
                    child: const Icon(Icons.cameraswitch),
                  ),
                  ElevatedButton(
                    onPressed: () => onMicButtonTap.call(audioEnabled),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder()),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(10.0),
                      ),
                      elevation: MaterialStateProperty.all<double>(8.0),
                    ),
                    child:audioEnabled
                        ? const Icon(Icons.mic)
                        : const Icon(Icons.mic_off),
                  ),
                  ElevatedButton(
                    onPressed: () => videoControl.call(videoEnabled),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder()),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(10.0),
                      ),
                      elevation: MaterialStateProperty.all<double>(8.0),
                    ),
                    child: videoEnabled
                        ? const Icon(Icons.videocam)
                        : const Icon(Icons.videocam_off),
                  ),

                  ElevatedButton(
                    onPressed: onFullScreenButtonTap,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder()),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(10.0),
                      ),
                      elevation: MaterialStateProperty.all<double>(8.0),
                    ),
                    child: const Icon(Icons.fullscreen),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

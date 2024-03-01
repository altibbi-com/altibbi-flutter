import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'altibbi_video.dart' as open_tok;
import 'video_flutter.dart';


/// The connection state, audio enabled & video enabled settings of a [VideoController]
@immutable
class OpenTokValue {
  /// Current connection state of the session.
  /// Default to [open_tok.ConnectionState.loggedOut].
  final open_tok.ConnectionState state;

  /// Whether publisher audio (microphone) is enabled or not.
  final bool audioEnabled;

  /// Whether publisher video is enabled or not.
  final bool videoEnabled;

  /// An optional error description. This will be non-null
  /// if the [open_tok.ConnectionState] is [open_tok.ConnectionState.error].
  final String? errorDescription;

  /// Constructs a [OpenTokValue] with the given values.
  ///
  /// [open_tok.ConnectionState] is [open_tok.ConnectionState.loggedOut] by default.
  /// [audioEnabled] & [videoEnabled] are default to true.
  const OpenTokValue({
    this.state = open_tok.ConnectionState.loggedOut,
    this.audioEnabled = true,
    this.videoEnabled = true,
    this.errorDescription,
  });

  /// Returns a new instance that has the same values as this current instance,
  /// except for any overrides passed in as arguments to [copyWith].
  OpenTokValue copyWith({
    open_tok.ConnectionState? state,
    bool? audioEnabled,
    bool? videoEnabled,
    String? errorDescription,
  }) {
    return OpenTokValue(
      state: state ?? this.state,
      audioEnabled: audioEnabled ?? this.audioEnabled,
      videoEnabled: videoEnabled ?? this.videoEnabled,
      errorDescription: errorDescription,
    );
  }
}

/// Controls OpenTok video platform and provides updates when the state is changing.
///
/// The publisher/subscriber video is displayed in a Flutter app by creating a [VideoView] widget.
class VideoController extends ValueNotifier<OpenTokValue> {
  OpenTokFlutter? _openTokFlutter;

  var stateUpdateCallBack = (open_tok.ConnectionStateCallback stateUpdate) async {
    //print("stateUpdate= => ${stateUpdate.state}");
  };
  /// Constructs a [VideoController].
  VideoController() : super(const OpenTokValue());

  /// This method gets called whenever the OpenTok session state changes.
  ///
  /// The new state value is also passed as a parameter.
  void onStateUpdate(open_tok.ConnectionStateCallback connection) async {
    value = value.copyWith(
        state: connection.state, errorDescription: connection.errorDescription);
    stateUpdateCallBack(connection);
  }

  /// Initiates a OpenTok session with the given [open_tok.VideoConfig] values.
  void initSession(open_tok.VideoConfig config) async {
    _openTokFlutter = OpenTokFlutter(config, onUpdate: onStateUpdate);
    await _openTokFlutter?.initSession();
  }

  /// Ends the OpenTok session.
  void endSession() async {
    await _openTokFlutter?.endSession();

    // Reset the OpenTok session to default values
    value = value.copyWith(
      state: open_tok.ConnectionState.loggedOut,
      audioEnabled: true,
      videoEnabled: true,
    );
  }

  /// Toggle/Switch between front/back camera if available.
  void toggleCamera() async {
    await _openTokFlutter?.toggleCamera();
  }

  /// Enable/Disable audio (Microphone) for current OpenTok session.
  void toggleAudio(bool enabled) async {
    value = value.copyWith(audioEnabled: enabled);
    await _openTokFlutter?.toggleAudio(enabled);
  }

  /// Enable/Disable video for current OpenTok session.
  void toggleVideo(bool enabled) async {
    value = value.copyWith(videoEnabled: enabled);
    await _openTokFlutter?.toggleVideo(enabled);
  }

  /// Pauses the video session.
  ///
  /// Invoke it when the app goes to background with an active session.
  ///
  /// This method is only for Android. On iOS will do nothing.
  void pause() async {
    await _openTokFlutter?.onPause();
  }

  /// Resumes the video session.
  ///
  /// Invoke it when the app comes back to foreground with an active session.
  ///
  /// This method is only for Android. On iOS will do nothing.
  void resume() async {
    await _openTokFlutter?.onResume();
  }

  /// Disposes the already ended session so that the hardware resources can be freed.
  ///
  /// Invoke it after [endSession] if needed.
  ///
  /// This method is only for Android. On iOS will do nothing.
  void disposeVideo() async {
    await _openTokFlutter?.onStop();
  }
}

/// Widget that displays the OpenTok video controlled by [controller].
class VideoView extends StatefulWidget {
  /// Constructs an instance of [VideoView] with the given [controller].
  const VideoView({
    Key? key,
    required this.controller,
    this.alignment = Alignment.bottomCenter,
    this.direction = Axis.horizontal,
    this.spacing = 10,
    this.padding,
    this.buttonPadding,
    this.onEndButtonTap,
    this.onCameraButtonTap,
    this.onMicButtonTap,
    this.onVideoButtonTap,
    this.onFullScreenButtonTap,
  }) : super(key: key);

  /// The [VideoController] responsible for the OpenTok video being rendered in this widget.
  final VideoController controller;

  /// Alighnment of the child. Default to [Alignment.bottomCenter].
  final Alignment alignment;

  /// The direction of the action buttons. Default to [Axis.horizontal]
  final Axis direction;

  /// The spacing between the action buttons. Defaults to 10.
  final double spacing;

  /// The padding around the action buttons. Defaults to 10.0.
  final EdgeInsetsGeometry? padding;

  /// The padding of the action buttons. Defaults to 10.0.
  final EdgeInsetsGeometry? buttonPadding;

  /// Called when end button is tapped.
  /// The button will be hidden if its null;
  final VoidCallback? onEndButtonTap;

  /// Called when camera button is tapped.
  /// The button will be hidden if its null;
  final VoidCallback? onCameraButtonTap;

  /// Called when microphone/audio button is tapped.
  /// The button will be hidden if its null;
  final void Function(bool)? onMicButtonTap;

  /// Called when video button is tapped.
  /// The button will be hidden if its null;
  final void Function(bool)? onVideoButtonTap;

  /// Called when full screen button is tapped.
  /// The button will be hidden if its null;
  final VoidCallback? onFullScreenButtonTap;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  /// This is used in the platform side to register the view.
  static const String viewType = 'opentok-video-container';

  @override
  void initState() {
    widget.controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (defaultTargetPlatform == TargetPlatform.android)
          const AndroidOpenTokVideoView(viewType: viewType)
        else if (defaultTargetPlatform == TargetPlatform.iOS)
          const IOSOpenTokVideoView(viewType: viewType)
        else
          throw UnsupportedError('Unsupported platform view'),
      ],
    );
  }
}

/// A widget to host native android view for OpenTok.
class AndroidOpenTokVideoView extends StatelessWidget {
  /// This is used in the platform side to register the view.
  final String viewType;

  /// Constructs an [AndroidOpenTokVideoView] instance with the given [viewType].
  const AndroidOpenTokVideoView({Key? key, required this.viewType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory:
          (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        // Currently Flutter 3.0 has a bug where flutter widgets can't be rendered
        // on top of a native view. This bug is occuring when using initSurfaceAndroidView or
        // initAndroidView. We should revert back to one of these methods once the bug is fixed.
        // Track it here: https://github.com/flutter/flutter/issues/103630
        return PlatformViewsService.initExpensiveAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: {},
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () => params.onFocusChanged(true),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }
}

/// A widget to host native iOS view for OpenTok.
class IOSOpenTokVideoView extends StatelessWidget {
  /// This is used in the platform side to register the view.
  final String viewType;

  /// Constructs an [IOSOpenTokVideoView] instance with the given [viewType].
  const IOSOpenTokVideoView({Key? key, required this.viewType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: const {},
      creationParamsCodec: const StandardMessageCodec(),
      gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
    );
  }
}

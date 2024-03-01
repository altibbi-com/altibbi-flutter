import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import 'altibbi_service.dart';

class Pusher {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  void init(
      {Function(PusherEvent)? onEvent,
        Function(String, String)? onConnectionStateChange,
        Function(String, int?, dynamic)? onError,
        Function(String, dynamic)? onSubscriptionSucceeded,
        Function(String, dynamic)? onSubscriptionError,
        Function(String, String)? onDecryptionFailure,
        Function(String, PusherMember)? onMemberAdded,
        Function(String, PusherMember)? onMemberRemoved,
        String channelName = "" ,
        String apiKey = "" ,
      }) async {

    if(channelName == "" ){
      throw Exception('Error : channelName needed ');
    }

    if(apiKey == "" ){
      throw Exception('Error : apiKey needed ');
    }
    final token = AltibbiService.authToken;
    final baseURL = AltibbiService.url;
    try {
      await pusher.init(
          apiKey: apiKey,
          cluster: "eu",
          onEvent: onEvent,
          onConnectionStateChange: onConnectionStateChange,
          onError: onError,
          onSubscriptionSucceeded: onSubscriptionSucceeded,
          onSubscriptionError: onSubscriptionError,
          onDecryptionFailure: onDecryptionFailure,
          onMemberAdded: onMemberAdded,
          onMemberRemoved: onMemberRemoved,
          authEndpoint: "$baseURL/v1/auth/pusher?access-token=$token");
      await pusher.subscribe(channelName: channelName);
      await pusher.connect();
    } catch (e) {
      throw Exception('ERROR 12: $e');
    }
  }

  void disconnect() async {
    await pusher.disconnect();
  }

  void unsubscribe(String channelName) async {
    await pusher.unsubscribe(channelName: channelName);
  }
}

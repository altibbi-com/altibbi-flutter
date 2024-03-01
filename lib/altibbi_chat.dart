import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

import 'model/consultation.dart';
export 'package:sendbird_chat_sdk/src/public/core/channel/base_channel/base_channel.dart';
export 'package:sendbird_chat_sdk/src/public/core/channel/group_channel/group_channel.dart';
export 'package:sendbird_chat_sdk/src/public/core/channel/open_channel/open_channel.dart';
export 'package:sendbird_chat_sdk/src/public/core/message/admin_message.dart';
export 'package:sendbird_chat_sdk/src/public/core/message/base_message.dart';
export 'package:sendbird_chat_sdk/src/public/core/message/file_message.dart';
export 'package:sendbird_chat_sdk/src/public/core/message/user_message.dart';
export 'package:sendbird_chat_sdk/src/public/core/user/member.dart';
export 'package:sendbird_chat_sdk/src/public/core/user/restricted_user.dart';
export 'package:sendbird_chat_sdk/src/public/core/user/sender.dart';
export 'package:sendbird_chat_sdk/src/public/core/user/user.dart';
export 'package:sendbird_chat_sdk/src/public/main/chat/sendbird_chat.dart';
export 'package:sendbird_chat_sdk/src/public/main/chat/sendbird_chat_options.dart';
export 'package:sendbird_chat_sdk/src/public/main/collection/collection_event_source.dart';
export 'package:sendbird_chat_sdk/src/public/main/collection/group_channel_collection/group_channel_context.dart';
export 'package:sendbird_chat_sdk/src/public/main/collection/group_channel_collection/group_channel_collection.dart';
export 'package:sendbird_chat_sdk/src/public/main/collection/group_channel_collection/group_channel_collection_handler.dart';
export 'package:sendbird_chat_sdk/src/public/main/collection/group_channel_message_collection/message_collection.dart';
export 'package:sendbird_chat_sdk/src/public/main/collection/group_channel_message_collection/message_collection_handler.dart';
export 'package:sendbird_chat_sdk/src/public/main/collection/group_channel_message_collection/message_context.dart';
export 'package:sendbird_chat_sdk/src/public/main/define/enums.dart';
export 'package:sendbird_chat_sdk/src/public/main/define/exceptions.dart';
export 'package:sendbird_chat_sdk/src/public/main/define/sendbird_error.dart';
export 'package:sendbird_chat_sdk/src/public/main/handler/channel_handler.dart';
export 'package:sendbird_chat_sdk/src/public/main/handler/connection_handler.dart';
export 'package:sendbird_chat_sdk/src/public/main/handler/session_handler.dart';
export 'package:sendbird_chat_sdk/src/public/main/handler/user_event_handler.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/channel/group_channel_change_logs.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/channel/group_channel_filter.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/channel/group_channel_unread_item_count.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/chat/do_not_disturb.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/chat/emoji.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/chat/snooze_period.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/info/app_info.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/info/file_info.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/info/mute_info.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/info/scheduled_info.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/message/apple_critical_alert_options.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/message/message_change_logs.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/message/message_meta_array.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/og/og_image.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/og/og_meta_data.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/poll/poll.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/poll/poll_change_logs.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/poll/poll_data.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/poll/poll_option.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/poll/poll_update_event.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/poll/poll_vote_event.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/reaction/reaction.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/reaction/reaction_event.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/thread/thread_info.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/thread/thread_info_updated_event.dart';
export 'package:sendbird_chat_sdk/src/public/main/model/thread/threaded_messages.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/channel/group_channel_change_logs_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/channel/group_channel_create_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/channel/group_channel_total_unread_channel_count_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/channel/group_channel_total_unread_message_count_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/channel/group_channel_update_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/channel/open_channel_create_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/channel/open_channel_update_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/base_message_create_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/base_message_fetch_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/base_message_update_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/file_message_create_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/file_message_update_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/message_change_logs_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/message_list_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/message_retrieval_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/scheduled_file_message_create_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/scheduled_file_message_update_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/scheduled_message_list_query_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/scheduled_message_retrieval_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/scheduled_user_message_create_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/scheduled_user_message_update_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/threaded_message_list_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/total_scheduled_message_count_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/user_message_create_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/message/user_message_update_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/poll/poll_create_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/poll/poll_list_query_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/poll/poll_option_retrieval_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/poll/poll_retrieval_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/poll/poll_update_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/params/poll/poll_voter_list_query_params.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/base_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/channel/group_channel_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/channel/open_channel_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/channel/public_group_channel_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/message/message_search_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/message/previous_message_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/message/scheduled_message_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/poll/poll_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/poll/poll_voter_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/user/application_user_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/user/banned_user_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/user/blocked_user_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/user/member_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/user/muted_user_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/user/operator_list_query.dart';
export 'package:sendbird_chat_sdk/src/public/main/query/user/participant_list_query.dart';

class AltibbiChat {

  /// Initializes the SendBird Chat Sdk with the specified `appID` and `option`.
  ///
  /// [appId] : the sendBird application ID
  ///
  /// [option] : Additional option for initializing the sdk.
  Future<User> init({required Consultation consultation, SendbirdChatOptions? options}) async {
    SendbirdChat.init(appId: consultation.chatConfig!.appId!, options: options);
    return await SendbirdChat.connect(consultation.chatConfig!.chatUserId!,accessToken: consultation.chatConfig!.chatUserToken!);
  }

  //    SendbirdChat.addChannelHandler('xxx', channelHandler);


  /// Retrieves the version of the sendbird Chat Sdk.
  ///
  /// returns the SDK version as a string
  String getSdkVersion() {
    return SendbirdChat.getSdkVersion();
  }

  /// set the option for the Sendbird Chat SDK
  ///
  /// [option] : the options to set for the SDK.
  void setOptions(SendbirdChatOptions options) {
    SendbirdChat.setOptions(options);
  }

  /// Retrieve the currently set options for the Sendbird Chat SDK
  ///
  /// Retruns the current options of the SDK
  SendbirdChatOptions getOptions() {
    return SendbirdChat.getOptions();
  }

  /// Sets the version of the application
  ///
  /// [version] : The version of the application
  void setAppVersion(String version) {
    SendbirdChat.setAppVersion(version);
  }

  /// Sets the log level for the Sendbird Chat SDK.
  ///
  /// [level] : the log level to set
  void setLogLevel(LogLevel level) {
    SendbirdChat.setLogLevel(level);
  }

  /// Checks if the Sendbird Chat SDK is initialized.
  ///
  /// Returns `true` if the SDK is initialized, `false` otherwise.
  bool isInitialized() {
    return SendbirdChat.isInitialized();
  }

  /// Retrieves the Sendbird application ID.
  ///
  /// Returns the application ID as a string.
  String? getApplicationId() {
    return SendbirdChat.getApplicationId();
  }

  /// Retrieves the information about the Sendbird application.
  ///
  /// Returns the application information.
  AppInfo? getAppInfo() {
    return SendbirdChat.getAppInfo();
  }

  /// Adds an extension to the Sendbird Chat SDK.
  ///
  /// [key] : The key of the extension.
  ///
  /// [version] : The version of the extension.
  void addExtension(String key, String version) {
    SendbirdChat.addExtension(key, version);
  }

  /// Sets the preference for automatically accepting channel invitations.
  ///
  /// [autoAccept] : Determines whether to automatically accept channel invitations.
  Future<void> setChannelInvitationPreference(bool autoAccept) async {
    await SendbirdChat.setChannelInvitationPreference(autoAccept);
  }

  /// Retrieves the preference for automatically accepting channel invitations.
  ///
  /// Returns `true` if channel invitations are automatically accepted, `false` otherwise.
  Future<bool> getChannelInvitationPreference() async {
    return await SendbirdChat.getChannelInvitationPreference();
  }

  /// Retrieves the change logs of the user's group channels.
  ///
  /// [params] : The parameters for retrieving group channel change logs.
  ///
  /// [token] : The token for pagination.
  ///
  /// [timestamp] : The timestamp for the change logs.
  Future<GroupChannelChangeLogs> getMyGroupChannelChangeLogs(
      GroupChannelChangeLogsParams params, {
        String? token,
        int? timestamp,
      }) async {
    return SendbirdChat.getMyGroupChannelChangeLogs(
        params, token: token, timestamp: timestamp);
  }

  /// Marks all messages as read in the current user's group channels.
  Future<void> markAsReadAll() async {
    await SendbirdChat.markAsReadAll();
  }

  /// Marks the messages in the specified channels as read.
  ///
  /// [channelUrls] : The URLs of the channels to mark as read.
  Future<void> markAsRead({required List<String> channelUrls}) async {
    await SendbirdChat.markAsRead(channelUrls: channelUrls);
  }

  /// Marks the messages as delivered with the specified data.
  ///
  /// [data] : The data for marking the messages as delivered.
  Future<void> markAsDelivered({required Map<String, dynamic> data}) async {
    await SendbirdChat.markAsDelivered(data: data);
  }

  /// Retrieves the count of group channels that the current user is a member of.
  ///
  /// [filter] : The filter for counting the group channels.
  Future<int> getGroupChannelCount(MyMemberStateFilter filter) async {
    return await SendbirdChat.getGroupChannelCount(filter);
  }

  /// Retrieves the total count of unread channels for the current user.
  ///
  /// [params] : The parameters for retrieving the total unread channel count.
  Future<int> getTotalUnreadChannelCount(
      [GroupChannelTotalUnreadChannelCountParams? params]) async {
    return await SendbirdChat.getTotalUnreadChannelCount(params);
  }

  /// Retrieves the total count of unread messages for the current user.
  ///
  /// [params] : The parameters for retrieving the total unread message count.
  Future<int> getTotalUnreadMessageCount(
      [GroupChannelTotalUnreadMessageCountParams? params]) async {
    return await SendbirdChat.getTotalUnreadMessageCount(params);
  }

  /// Retrieves the count of unread items for the specified keys.
  ///
  /// [keys] : The keys of the items to retrieve the unread count for.
  Future<GroupChannelUnreadItemCount> getUnreadItemCount(
      List<UnreadItemKey> keys) async {
    return await SendbirdChat.getUnreadItemCount(keys);
  }

  /// Retrieves the total count of unread messages for the subscribed channels.
  ///
  /// Returns the total count of unread messages.
  int getSubscribedTotalUnreadMessageCount() {
    return SendbirdChat.getSubscribedTotalUnreadMessageCount;
  }

  /// Retrieves the total count of unread messages for the subscribed channels with custom types.
  ///
  /// Returns the total count of unread messages.
  int getSubscribedCustomTypeTotalUnreadMessageCount() {
    return SendbirdChat.getSubscribedCustomTypeTotalUnreadMessageCount;
  }

  /// Retrieves the count of unread messages for the subscribed channels with the specified custom type.
  ///
  /// [customType] : The custom type of the channels to retrieve the unread count for.
  ///
  /// Returns the count of unread messages for the specified custom type.
  int? getSubscribedCustomTypeUnreadMessageCount(String customType) {
    return SendbirdChat.getSubscribedCustomTypeUnreadMessageCount(customType);
  }

  /// Retrieves the total count of scheduled messages.
  ///
  /// [params] : The parameters for retrieving the total scheduled message count.
  Future<int> getTotalScheduledMessageCount({
    TotalScheduledMessageCountParams? params,
  }) async {
    return await SendbirdChat.getTotalScheduledMessageCount(params: params);
  }

  /// getGroupChannel
  Future<GroupChannel> getGroupChannel(Consultation consultation) async{
    var group = GroupChannel(channelUrl: "channel_${consultation.chatConfig!.groupId!}");
    group.set(SendbirdChat().chat);
    return group;
  }

  /// Disconnects the current user from Sendbird Chat.
  Future<void> disconnect() async {
    await SendbirdChat.disconnect();
  }

  /// Reconnects the current user to Sendbird Chat.
  ///
  /// Returns `true` if the reconnection is successful, `false` otherwise.
  Future<bool> reconnect() async {
    return await SendbirdChat.reconnect();
  }

  /// Retrieves the timestamp of the last successful connection to Sendbird Chat.
  ///
  /// Returns the timestamp of the last successful connection, or `null` if not available.
  int? getLastConnectedAt() {
    return SendbirdChat.getLastConnectedAt();
  }

  /// Retrieves the connection state of the current user.
  ///
  /// Returns the connection state.
  MyConnectionState getConnectionState() {
    return SendbirdChat.getConnectionState();
  }

  /// Retrieves all the available emoji.
  ///
  /// Returns the container of all emoji.
  Future<EmojiContainer> getAllEmoji() async {
    return await SendbirdChat.getAllEmoji();
  }

  /// Retrieves the emoji with the specified key.
  ///
  /// [key] : The key of the emoji to retrieve.
  ///
  /// Returns the emoji.
  Future<Emoji> getEmoji(String key) async {
    return await SendbirdChat.getEmoji(key);
  }

  /// Retrieves the emoji category with the specified ID.
  ///
  /// [categoryId] : The ID of the emoji category to retrieve.
  ///
  /// Returns the emoji category.
  Future<EmojiCategory> getEmojiCategory(int categoryId) async {
    return await SendbirdChat.getEmojiCategory(categoryId);
  }

  /// Adds a channel event handler with the specified identifier and handler.
  ///
  /// [identifier] : The identifier for the handler.
  ///
  /// [handler] : The channel event handler to add.
  void addChannelHandler(String identifier, BaseChannelHandler handler) {
    SendbirdChat.addChannelHandler(identifier, handler);
  }

  /// Retrieves the channel event handler with the specified identifier.
  ///
  /// [identifier] : The identifier of the handler to retrieve.
  ///
  /// Returns the channel event handler.
  BaseChannelHandler? getChannelHandler(String identifier) {
    return SendbirdChat.getChannelHandler(identifier);
  }

  /// Removes the channel event handler with the specified identifier.
  ///
  /// [identifier] : The identifier of the handler to remove.
  void removeChannelHandler(String identifier) {
    SendbirdChat.removeChannelHandler(identifier);
  }

  /// Removes all the channel event handlers.
  void removeAllChannelHandlers() {
    SendbirdChat.removeAllChannelHandlers();
  }

  /// Adds a connection event handler with the specified identifier and handler.
  ///
  /// [identifier]: The identifier for the handler.
  ///
  /// [handler] : The connection event handler to add.
  void addConnectionHandler(String identifier, ConnectionHandler handler) {
    SendbirdChat.addConnectionHandler(identifier, handler);
  }

  /// Retrieves the connection event handler with the specified identifier.
  ///
  /// [identifier] : The identifier of the handler to retrieve.
  ///
  /// Returns the connection event handler.
  ConnectionHandler? getConnectionHandler(String identifier) {
    return SendbirdChat.getConnectionHandler(identifier);
  }

  /// Removes the connection event handler with the specified identifier.
  ///
  /// [identifier] : The identifier of the handler to remove.
  void removeConnectionHandler(String identifier) {
    SendbirdChat.removeConnectionHandler(identifier);
  }

  /// Removes all the connection event handlers.
  void removeAllConnectionHandlers() {
    SendbirdChat.removeAllConnectionHandlers();
  }

  /// Adds a user event handler with the specified identifier and handler.
  ///
  /// [identifier] : The identifier for the handler.
  ///
  /// [handler] : The user event handler to add.
  void addUserEventHandler(String identifier, UserEventHandler handler) {
    SendbirdChat.addUserEventHandler(identifier, handler);
  }

  /// Retrieves the user event handler with the specified identifier.
  ///
  /// [identifier] : The identifier of the handler to retrieve.
  ///
  /// Returns the user event handler.
  UserEventHandler? getUserEventHandler(String identifier) {
    return SendbirdChat.getUserEventHandler(identifier);
  }

  /// Removes the user event handler with the specified identifier.
  ///
  /// [identifier] : The identifier of the handler to remove.
  void removeUserEventHandler(String identifier) {
    SendbirdChat.removeUserEventHandler(identifier);
  }

  /// Removes all the user event handlers.
  void removeAllUserEventHandlers() {
    SendbirdChat.removeAllUserEventHandlers();
  }

  /// Sets a handler to receive session events.
  void setSessionHandler(SessionHandler handler) {
    SendbirdChat.setSessionHandler(handler);
  }

  /// Gets the currently set session handler.
  SessionHandler? getSessionHandler() {
    return SendbirdChat.getSessionHandler();
  }

  /// Removes the currently set session handler.
  void removeSessionHandler() {
    SendbirdChat.removeSessionHandler();
  }

  /// Registers a push token for push notifications.
  Future<PushTokenRegistrationStatus> registerPushToken({
    required PushTokenType type,
    required String token,
    bool alwaysPush = false,
    bool unique = false,
  }) async {
    return await SendbirdChat.registerPushToken(
      type: type,
      token: token,
      alwaysPush: alwaysPush,
      unique: unique,
    );
  }

  /// Retrieves the pending push token.
  String? getPendingPushToken() {
    return SendbirdChat.getPendingPushToken();
  }

  /// Unregisters a push token.
  Future<void> unregisterPushToken({
    required PushTokenType type,
    required String token,
  }) async {
    return await SendbirdChat.unregisterPushToken(
      type: type,
      token: token,
    );
  }

  /// Unregisters all push tokens.
  Future<void> unregisterPushTokenAll() async {
    return await SendbirdChat.unregisterPushTokenAll();
  }

  /// Sets the push trigger option.
  Future<void> setPushTriggerOption(PushTriggerOption option) async {
    await SendbirdChat.setPushTriggerOption(option);
  }

  /// Retrieves the push trigger option.
  Future<PushTriggerOption> getPushTriggerOption() async {
    return await SendbirdChat.getPushTriggerOption();
  }

  /// Sets the push sound.
  Future<void> setPushSound(String sound) async {
    return await SendbirdChat.setPushSound(sound);
  }

  /// Gets push notification sound path for the current `User`.
  Future<String> getPushSound() async {
    return await SendbirdChat.getPushSound();
  }

  /// Sets push template option for the current `User`.
  /// The only valid arguments for template name are [SendbirdChat.pushTemplateDefault] and [SendbirdChat.pushTemplateAlternative].
  /// If [SendbirdChat.pushTemplateDefault] is set,
  /// the push notification will contain the original message in the `message` field of the push notification.
  /// If [SendbirdChat.pushTemplateAlternative] is set,
  /// `message` of push notification will be replaced by the content you've set on
  /// [Sendbird Dashboard](https://dashboard.sendbird.com).
  Future<void> setPushTemplate(String name) async {
    return await SendbirdChat.setPushTemplate(name);
  }

  /// Gets push template option for the current `User`.
  /// For details of push template option, refer to [setPushTemplate].
  /// This can be used, for instance,
  /// when you need to check the push notification content preview is on or off at the moment.
  Future<String> getPushTemplate() async {
    return await SendbirdChat.getPushTemplate();
  }

  /// The current connected [User]. `null` if [connect] is not called.
  User? get currentUser {
    return SendbirdChat.currentUser;
  }

  /// Updates current `User`'s information.
  Future<void> updateCurrentUserInfo({
    String? nickname,
    FileInfo? profileFileInfo,
    List<String>? preferredLanguages,
    ProgressHandler? progressHandler,
  }) async {
    await SendbirdChat.updateCurrentUserInfo(
      nickname: nickname,
      profileFileInfo: profileFileInfo,
      preferredLanguages: preferredLanguages,
      progressHandler: progressHandler,
    );
  }

  /// Blocks the specified `User` ID.
  /// Blocked `User` cannot send messages to the blocker.
  Future<User> blockUser(String userId) async {
    return await SendbirdChat.blockUser(userId);
  }

  /// Unblocks the specified `User` ID.
  /// Unblocked `User` cannot send messages to the ex-blocker.
  Future<void> unblockUser(String userId) async {
    await SendbirdChat.unblockUser(userId);
  }

  /// Sets Do-not-disturb option for the current `User`.
  /// If this option is enabled,
  /// the current `User` does not receive push notification during the specified time repeatedly.
  /// If you want to snooze specific period, use [setSnoozePeriod].
  Future<void> setDoNotDisturb({
    required bool enable,
    int startHour = 0,
    int startMin = 0,
    int endHour = 23,
    int endMin = 59,
    String timezone = 'UTC',
  }) async {
    return await SendbirdChat.setDoNotDisturb(
      enable: enable,
      startHour: startHour,
      startMin: startMin,
      endHour: endHour,
      endMin: endMin,
      timezone: timezone,
    );
  }

  /// Gets Do-not-disturb option for the current `User`.
  Future<DoNotDisturb> getDoNotDisturb() async {
    return await SendbirdChat.getDoNotDisturb();
  }

  /// Sets snooze period for the current `User`.
  /// If this option is enabled,
  /// the current `User` does not receive push notification during the given period.
  /// It's not a repetitive operation.
  /// If you want to snooze repeatedly, use [setDoNotDisturb].
  Future<void> setSnoozePeriod({
    required bool enable,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await SendbirdChat.setSnoozePeriod(
      enable: enable,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Gets snooze period for the current `User`.
  Future<SnoozePeriod> getSnoozePeriod() async {
    return await SendbirdChat.getSnoozePeriod();
  }

}

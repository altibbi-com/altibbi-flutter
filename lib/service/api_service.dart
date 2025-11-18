import 'dart:convert';
import 'package:altibbi/altibbi_service.dart';
import 'package:altibbi/enum.dart';
import 'package:altibbi/model/Article.dart';
import 'package:altibbi/model/media.dart';
import 'package:altibbi/model/consultation.dart';
import 'package:altibbi/model/predict_specialty.dart';
import 'package:altibbi/model/predict_summary.dart';
import 'package:altibbi/model/sina/chatMessage.dart';
import 'package:altibbi/model/soap.dart';
import 'package:altibbi/model/transcription.dart';
import 'package:altibbi/model/user.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show debugPrint;

import '../model/sina/chat.dart';

class HttpResponseException extends http.Response implements Exception {
  final String? errorMessage;

  HttpResponseException._(
    String body,
    int statusCode, {
    Map<String, String>? headers,
    bool isRedirect = false,
    bool persistentConnection = true,
    String? reasonPhrase,
    http.BaseRequest? request,
    this.errorMessage,
  }) : super(
          body,
          statusCode,
          headers: headers ?? <String, String>{},
          isRedirect: isRedirect,
          persistentConnection: persistentConnection,
          reasonPhrase: reasonPhrase,
          request: request,
        );

  factory HttpResponseException.fromResponse(
    http.Response response, {
    String? errorMessage,
  }) {
    return HttpResponseException._(
      response.body,
      response.statusCode,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
      request: response.request,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() => errorMessage ?? super.toString();
}

class ApiService {
  void _log(String message) {
    if (AltibbiService.enableLogging) {
      debugPrint(message);
    }
  }
  String _extractErrorMessage(http.Response response) {
    try {
      if (response.body.isEmpty) {
        return 'API request failed with status ${response.statusCode}: ${response.reasonPhrase ?? 'Unknown error'}';
      }

      final responseData = json.decode(response.body);

      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('message')) {
          return responseData['message'].toString();
        }
        if (responseData.containsKey('error')) {
          final error = responseData['error'];
          if (error is Map) {
            if (error.containsKey('message')) {
              return error['message'].toString();
            }
            return error.toString();
          }
          return error.toString();
        }
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'];
          if (errors is List && errors.isNotEmpty) {
            return errors.join(', ');
          }
          if (errors is Map) {
            return errors.entries.map((e) => '${e.key}: ${e.value}').join(', ');
          }
          return errors.toString();
        }
      }

      return 'API request failed with status ${response.statusCode}: ${response.body}';
    } catch (e) {
      return 'API request failed with status ${response.statusCode}: ${response.body.isNotEmpty ? response.body : (response.reasonPhrase ?? 'Unknown error')}';
    }
  }

  Never _throwApiError(http.Response response) {
    final message = _extractErrorMessage(response);
    throw HttpResponseException.fromResponse(
      response,
      errorMessage: message,
    );
  }

  String _generateCurlCommand({
    required String method,
    required Uri url,
    required Map<String, String> headers,
    String? body,
    File? file,
  }) {
    final methodUpper = method.toUpperCase();
    final buffer = StringBuffer('curl -X $methodUpper');

    buffer.write(' \'$url\'');

    headers.forEach((key, value) {
      if (file != null && key.toLowerCase() == 'content-type') {
        return; // Skip Content-Type for multipart uploads
      }
      final escapedValue = value.replaceAll("'", "'\\''");
      buffer.write(' -H \'$key: $escapedValue\'');
    });

    if (file != null) {
      buffer.write(' -F \'file=@${file.path}\'');
    } else if (body != null && body.isNotEmpty && methodUpper != 'GET') {
      final escapedBody = body.replaceAll("'", "'\\''");
      buffer.write(' -d \'$escapedBody\'');
    }

    return buffer.toString();
  }

  Future<http.Response> callApi(
      {required String? endpoint,
      required String? method,
      Map<String, dynamic> body = const {},
      File? file,
      int? page,
      int? perPage,
      bool? isSinaAPI = false}) async {
    final token = AltibbiService.authToken;
    final baseURL = isSinaAPI == true ? AltibbiService.sinaModelEndPointUrl : AltibbiService.url;
    final lang = AltibbiService.lang;
    if (token == null) {
      throw Exception('Token is missing or invalid.');
    }

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'accept-language': lang!
    };

    String? encodedBody;

    Map<String, dynamic> requestBody = Map<String, dynamic>.from(body);

    if (isSinaAPI == true) {
      headers['partner-host'] = AltibbiService.url!;
      headers['partner-user-token'] = token;
    } else {
      headers['Authorization'] = 'Bearer ${token}';
    }

    if (requestBody.isNotEmpty) {
      encodedBody = json.encode(requestBody);
      _log('\n========== REQUEST BODY ==========');
      _log(encodedBody);
      _log('==================================\n');
    }

    Uri url;

    if (method == 'get') {
      final queryParameters = Map.fromEntries(requestBody.entries
          .map((entry) => MapEntry(entry.key, entry.value.toString())));
      if (perPage != null && page != null) {
        queryParameters['per-page'] = perPage.toString();
        queryParameters['page'] = page.toString();
      }

      url = Uri.parse(baseURL!.contains("rest-api") ? baseURL : (isSinaAPI == true ? '$baseURL/$endpoint' : '$baseURL/v1/$endpoint'))
          .replace(queryParameters: queryParameters);
    } else {
      url = Uri.parse(baseURL!.contains("rest-api") ? baseURL : (isSinaAPI == true ? '$baseURL/$endpoint' : '$baseURL/v1/$endpoint'));
      if (method == 'post' && requestBody.containsKey('expand')) {
        final expand = requestBody['expand'];
        url = url.replace(queryParameters: {'expand': expand});
      }
    }
    // Generate and print curl command
    final curlCommand = _generateCurlCommand(
      method: method!,
      url: url,
      headers: headers,
      body: encodedBody,
      file: file,
    );
    _log('\n========== CURL COMMAND ==========');
    final maxChunkSize = 800;
    if (curlCommand.length <= maxChunkSize) {
      _log(curlCommand);
    } else {
      for (int i = 0; i < curlCommand.length; i += maxChunkSize) {
        final end = (i + maxChunkSize < curlCommand.length) ? i + maxChunkSize : curlCommand.length;
        _log(curlCommand.substring(i, end));
      }
    }
    _log('==================================\n');

    http.Response response;

    if (file != null) {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);
    } else {
    switch (method) {
      case 'get':
          response = await http.get(url, headers: headers);
          break;
      case 'post':
          response = await http.post(url, headers: headers, body: encodedBody);
          break;
      case 'put':
          response = await http.put(url, headers: headers, body: encodedBody);
          break;
      case 'delete':
          response = await http.delete(url, headers: headers, body: encodedBody);
          break;
      default:
        throw Exception('Invalid method type: $method');
    }
    }

    _log('\n========== RESPONSE ==========');
    _log('Status Code: ${response.statusCode}');
    _log('Headers: ${response.headers}');
    _log('Body: ${response.body}');
    _log('==============================\n');

    return response;
  }

  /// Retrieves a user with the given [userID] from the API.
  /// Returns the user object if the API call is successful.
  Future<User> getUser(int userID) async {
    final response = await callApi(endpoint: 'users/$userID', method: 'get');
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final user = User.fromJson(responseData);
      return user;
    } else {
      _throwApiError(response);
    }
  }

  /// Retrieves a list of users from the API.
  ///
  /// [page] - The page number of the consultations to retrieve Defaults to 1.
  /// [perPage] - The number of consultations to retrieve per page Defaults to 20.
  ///
  /// Returns a list of user objects if the API call is successful.
  Future<List<User>> getUsers({int page = 1, int perPage = 20}) async {
    final response = await callApi(
        perPage: perPage, page: page, endpoint: 'users', method: 'get');

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<User> users =
          responseData.map((json) => User.fromJson(json)).toList();
      return users;
    } else {
      _throwApiError(response);
    }
  }

  /// Creates a new user using the provided [user] object.
  /// Returns the created user object if the API call is successful.
  Future<User> createUser(User user) async {
    final response =
        await callApi(endpoint: 'users', method: 'post', body: user.toJson());

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final createdUser = User.fromJson(responseData);
      return createdUser;
    } else {
      _throwApiError(response);
    }
  }

  /// Updates the user with the given [userID] using the provided [userData].
  /// Returns the updated user object if the API call is successful.
  Future<User> updateUser(User userData, int userID) async {
    final response = await callApi(
        endpoint: 'users/$userID', method: 'put', body: userData.toJson());

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final updatedUser = User.fromJson(responseData);
      return updatedUser;
    } else {
      _throwApiError(response);
    }
  }

  /// Deletes the user with the given [userID] from the API.
  /// Returns true if the API call is successful.
  Future deleteUser(int userID) async {
    final response = await callApi(endpoint: 'users/$userID', method: 'delete');

    if (response.statusCode == 204) {
      return true;
    } else {
      _throwApiError(response);
    }
  }

  /// Retrieves a list of consultations from the API.
  ///
  /// [page] - The page number of the consultations to retrieve. Defaults to 1.
  /// [perPage] - The number of consultations to retrieve per page. Defaults to 20.
  ///
  /// Returns a list of consultation objects if the API call is successful.
  Future<List<Consultation>> getConsultationList(
      {int page = 1, int perPage = 20, int? userId, String? sort}) async {
    Map<String, dynamic> body = {
      "expand":
          "pusherAppKey,parentConsultation,consultations,user,media,pusherChannel,"
              "chatConfig,chatHistory,voipConfig,videoConfig,recommendation"
    };
    if (userId != null) {
      body["filter[user_id]"] = userId;
    }
    if (sort != null) {
      body["sort"] = sort;
    }
    final response = await callApi(
        perPage: perPage,
        page: page,
        endpoint: 'consultations',
        method: 'get',
        body: body);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<Consultation> consultations =
          responseData.map((json) => Consultation.fromJson(json)).toList();
      return consultations;
    } else {
      _throwApiError(response);
    }
  }

  /// Creates a new consultation with the provided [question], [medium], [userID], and optional [mediaIDs].
  /// Returns the created consultation object if the API call is successful.
  Future<Consultation> createConsultation(
      {required String question,
      required Medium medium,
      required int userID,
      List<String>? mediaIDs,
      String? followUpId,
      String? forceWhiteLabelingPartnerName,
      int? consultationCategoryId}) async {
    if (!Medium.values.contains(medium)) {
      throw Exception('Invalid medium value');
    }
    final Map<String, dynamic> body = {
      "question": question,
      "medium": medium.toString().split('.').last,
      "user_id": userID,
      "media_ids": mediaIDs,
      "expand":
          "pusherAppKey,parentConsultation,consultations,user,media,pusherChannel,"
              "chatConfig,chatHistory,voipConfig,videoConfig,recommendation"
    };
    if (followUpId != null) {
      body['parent_consultation_id'] = followUpId;
    }
    if (forceWhiteLabelingPartnerName != null && forceWhiteLabelingPartnerName.length > 3) {
      body['question'] = "${body['question']} ~$forceWhiteLabelingPartnerName~";
    }
    if (consultationCategoryId != null) {
      body['consultation_category_id'] = consultationCategoryId;
    }
    final response =
        await callApi(endpoint: 'consultations', method: 'post', body: body);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final createdConsultation = Consultation.fromJson(responseData);
      return createdConsultation;
    } else {
      _throwApiError(response);
    }
  }

  /// Retrieves the consultation information for the given [consultationID] from the API.
  /// Returns the consultation object if the API call is successful.
  Future<Consultation> getConsultationInfo(int consultationID) async {
    final response = await callApi(
        endpoint: 'consultations/$consultationID',
        method: 'get',
        body: {
          "expand":
              "pusherAppKey,parentConsultation,consultations,user,media,pusherChannel,"
                  "chatConfig,chatHistory,voipConfig,videoConfig,recommendation"
        });
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final consultation = Consultation.fromJson(responseData);
      return consultation;
    } else {
      _throwApiError(response);
    }
  }

  /// Retrieves the last consultation from the API.
  /// Returns the last consultation object if the API call is successful.
  Future<Consultation> getLastConsultation() async {
    final response =
        await callApi(endpoint: 'consultations', method: 'get', body: {
      "per-page": 1,
      "sort": "-id",
      "expand":
          "pusherAppKey,parentConsultation,consultations,user,media,pusherChannel,"
              "chatConfig,chatHistory,voipConfig,videoConfig,recommendation"
    });
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final consultation = Consultation.fromJson(responseData[0]);
      return consultation;
    } else {
      _throwApiError(response);
    }
  }

  /// Deletes the consultation with the given [consultationID] from the API.
  /// Returns true if the API call is successful.
  Future<bool> deleteConsultation(int consultationID) async {
    final response = await callApi(
        endpoint: 'consultations/$consultationID', method: 'delete');

    if (response.statusCode == 204) {
      return true;
    } else {
      _throwApiError(response);
    }
  }

  /// Cancels the consultation with the given [consultationID].
  /// Returns true if the API call is successful.
  Future<bool> cancelConsultation(int consultationID) async {
    final response = await callApi(
        endpoint: 'consultations/$consultationID/cancel', method: 'post');

    if (response.statusCode == 200) {
      return true;
    } else {
      _throwApiError(response);
    }
  }

  /// Uploads a media [file] to the API.
  /// Returns the uploaded media object if the API call is successful.
  Future<Media> uploadMedia(File file) async {
    var response = await callApi(endpoint: 'media', method: 'post', file: file);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final media = Media.fromJson(responseData);
      return media;
    } else {
      _throwApiError(response);
    }
  }

  Future getPrescription(int consultationID, String savePath) async {
    final response = await callApi(
        endpoint: 'consultations/$consultationID/download-prescription',
        method: 'get');

    if (response.statusCode == 200) {
      final file = await File(savePath).writeAsBytes(response.bodyBytes);
      return file.path;
    } else {
      _throwApiError(response);
    }
  }

  Future<bool> rateConsultation(int consultationID, double score) async {
    final response = await callApi(
        endpoint: 'consultations/$consultationID/rate',
        method: "post",
        body: {"score": score});

    if (response.statusCode == 200) {
      return true;
    }
    _throwApiError(response);
  }

  Future<PredictSummary> getPredictSummary(int consultationID) async {
    final response = await callApi(
        endpoint: 'consultations/$consultationID/predict-summary',
        method: 'get'
      );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final predictSummary = PredictSummary.fromJson(responseData);
      return predictSummary;
    } else {
      _throwApiError(response);
    }
  }

  Future<Soap> getSoapSummary(int consultationID) async {
    final response = await callApi(
        endpoint: 'consultations/$consultationID/soap-summary',
        method: 'get'
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final soap = Soap.fromJson(responseData);
      return soap;
    } else {
      _throwApiError(response);
    }
  }

  Future<Transcription> getTranscription(int consultationID) async {
    final response = await callApi(
        endpoint: 'consultations/$consultationID/transcription',
        method: 'get'
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final transcription = Transcription.fromJson(responseData);
      return transcription;
    } else {
      _throwApiError(response);
    }
  }

  Future<List<PredictSpecialty>> getPredictSpecialty(int consultationID) async {
    final response = await callApi(
        endpoint: 'consultations/$consultationID/predict-specialty',
        method: 'get');
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<PredictSpecialty> predictSpecialty =
      responseData.map((json) => PredictSpecialty.fromJson(json)).toList();
      return predictSpecialty;
    } else {
      _throwApiError(response);
    }
  }

  /// Retrieves a list of media attachments from the API.
  ///
  /// [page] - The page number of the emdia list to retrieve. Defaults to 1.
  /// [perPage] - The number of media items to retrieve per page. Defaults to 20.
  ///
  /// Returns a list of consultation objects if the API call is successful.
  Future<List<Media>> getMediaList(
      {int page = 1, int perPage = 20}) async {
    final response = await callApi(
        perPage: perPage,
        page: page,
        endpoint: 'media',
        method: 'get');

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<Media> mediaList =
      responseData.map((json) => Media.fromJson(json)).toList();
      return mediaList;
    } else {
      _throwApiError(response);
    }
  }

  /// Deletes the media with the given [mediaID] from the API.
  /// Returns true if the API call is successful.
  Future deleteMedia(int mediaID) async {
    final response = await callApi(endpoint: 'media/$mediaID', method: 'delete');

    if (response.statusCode == 204) {
      return true;
    } else {
      _throwApiError(response);
    }
  }

  /// Retrieves a list of articles from the API.
  ///
  /// [subcategoryIds] - The articles topics to be retrieved.
  /// [page] - The page number of the article list to retrieve. Defaults to 1.
  /// [perPage] - The number of articles items to retrieve per page. Defaults to 20.
  ///
  /// Returns a list of consultation objects if the API call is successful.
  Future<List<Article>> getArticlesList(
      {required List<int> subcategoryIds, int page = 1, int perPage = 20}) async {
    final response = await callApi(
        perPage: perPage,
        page: page,
        endpoint: 'https://rest-api.altibbi.com/active/v1/articles',
        body: {
          'filter[sub_category_id][in]': subcategoryIds,
          'sort': '-article_id',
        },
        method: 'get');

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<Article> articlesList =
      responseData.map((json) => Article.fromJson(json)).toList();
      return articlesList;
    } else {
      _throwApiError(response);
    }
  }


  /// Creates a new chat.
  /// Returns the session ID if the API call is successful.
  Future<Chat> createSinaSession() async {
    final response =
    await callApi(endpoint: 'chats', method: 'post', isSinaAPI: true);
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final createdUser = Chat.fromJson(responseData);
      return createdUser;
    } else {
      _throwApiError(response);
    }
  }

  /// Creates a new chat.
  /// Returns the session ID if the API call is successful.
  Future<ChatResponse> sendSinaMessage(String text, String sessionId, String? mediaId) async {
    final Map<String, dynamic> body = {
      "text": text,
    };
    if (mediaId != null) {
      body['media_id'] = mediaId;
    }
    final response =
    await callApi(endpoint: 'chats/$sessionId/messages',
        method: 'post',
        body: body,
        isSinaAPI: true);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final createdUser = ChatResponse.fromJson(responseData);
      return createdUser;
    } else {
      _throwApiError(response);
    }
  }

  /// gets a list of chats based on sessions Id.
  /// Returns the chat messages list if the API call is successful.
  Future<List<ChatMessage>> getSinaChatMessages({
    required String sessionId,
    int page = 1,
    int perPage = 20
  }) async {
    final response =
    await callApi(
        perPage: perPage,
        page: page,
        endpoint: 'chats/$sessionId/messages',
        method: 'get',
        isSinaAPI: true);

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      final List<dynamic> rawList = responseData['data'] as List<dynamic>;
       final List<ChatMessage> chatMessagesList = rawList
          .map<ChatMessage>((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
          .toList();
      return chatMessagesList;
    } else {
      _throwApiError(response);
    }
  }


  /// Uploads Sina media [file] to the API.
  /// Returns the uploaded media object if the API call is successful.
  Future<Media> uploadSinaMedia(File file) async {
    var response = await callApi(endpoint: 'media', method: 'post', file: file,isSinaAPI: true);
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final media = Media.fromJson(responseData);
      return media;
    } else {
      _throwApiError(response);
    }
  }

}

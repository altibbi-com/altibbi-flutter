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

import '../model/sina/chat.dart';
class ApiService {
  /// Makes an API call with the specified endpoint, method, body, and file (optional).
  /// Returns the HTTP response from the API.
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
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${isSinaAPI == true ? "" : token}',
      'accept-language': lang!
    };

    String? encodedBody;

    Map<String, dynamic> requestBody = Map<String, dynamic>.from(body);

    if (isSinaAPI == true) {
      requestBody['partner'] = AltibbiService.url;
      requestBody['partnerUser'] = token;
    }

    if (requestBody.isNotEmpty) {
      encodedBody = json.encode(requestBody);
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
    if (file != null) {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    }

    switch (method) {
      case 'get':
        return await http.get(url, headers: headers);
      case 'post':
        return await http.post(url, headers: headers, body: encodedBody);
      case 'put':
        return await http.put(url, headers: headers, body: encodedBody);
      case 'delete':
        return await http.delete(url, headers: headers, body: encodedBody);
      default:
        throw Exception('Invalid method type: $method');
    }
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
      throw Exception(response);
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
      throw Exception(response);
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
      throw Exception(response);
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
      throw Exception(response);
    }
  }

  /// Deletes the user with the given [userID] from the API.
  /// Returns true if the API call is successful.
  Future deleteUser(int userID) async {
    final response = await callApi(endpoint: 'users/$userID', method: 'delete');

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception(response);
    }
  }

  /// Retrieves a list of consultations from the API.
  ///
  /// [page] - The page number of the consultations to retrieve. Defaults to 1.
  /// [perPage] - The number of consultations to retrieve per page. Defaults to 20.
  ///
  /// Returns a list of consultation objects if the API call is successful.
  Future<List<Consultation>> getConsultationList(
      {int page = 1, int perPage = 20, int? userId}) async {
    Map<String, dynamic> body = {
      "expand":
          "pusherAppKey,parentConsultation,consultations,user,media,pusherChannel,"
              "chatConfig,chatHistory,voipConfig,videoConfig,recommendation"
    };
    if (userId != null) {
      body["filter[user_id]"] = userId;
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
      throw Exception(response);
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
      String? forceWhiteLabelingPartnerName}) async {
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
    final response =
        await callApi(endpoint: 'consultations', method: 'post', body: body);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final createdConsultation = Consultation.fromJson(responseData);
      return createdConsultation;
    } else {
      throw Exception(response);
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
      throw Exception(response);
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
      throw Exception(response);
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
      throw Exception(response);
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
      throw Exception(response);
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
      throw Exception(response);
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
      throw Exception(response);
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
    throw Exception(response);
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
      throw Exception(response);
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
      throw Exception(response);
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
      throw Exception(response);
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
      throw Exception(response);
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
      throw Exception('Error: ${response.body}');
    }
  }

  /// Deletes the media with the given [mediaID] from the API.
  /// Returns true if the API call is successful.
  Future deleteMedia(int mediaID) async {
    final response = await callApi(endpoint: 'media/$mediaID', method: 'delete');

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Error : ${response.body}');
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
      throw Exception('Error: ${response.body}');
    }
  }


  /// Creates a new chat.
  /// Returns the session ID if the API call is successful.
  Future<Chat> createChat() async {
    final response =
    await callApi(endpoint: 'chats', method: 'post', isSinaAPI: true);
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final createdUser = Chat.fromJson(responseData);
      return createdUser;
    } else {
      throw Exception(response);
    }
  }

  /// Creates a new chat.
  /// Returns the session ID if the API call is successful.
  Future<ChatResponse> sendSinaMessage(String text, String sessionId) async {
    final Map<String, dynamic> body = {
      "text": text,
    };
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
      throw Exception(response);
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
      throw Exception(response);
    }
  }

}

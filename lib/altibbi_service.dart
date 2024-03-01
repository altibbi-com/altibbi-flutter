/// The AltibbiService class provides methods for initializing and managing the Altibbi service.
class AltibbiService {
  static String? authToken; // Authentication token for the service
  static String? url; // Base URL for the service
  static String? lang; // lang preference (ar or en)

  /// Initializes the Altibbi service with the specified parameters.
  ///
  /// - [token]: The authentication token for the service.
  /// - [baseUrl]: The base URL for the service.
  /// - [language]: The language preference for the service (default is 'en').
  static void init({required String token, required String baseUrl, String language = 'en'}) {
    authToken = token;
    url = baseUrl;
    lang = language;
  }
}

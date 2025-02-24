import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:swag_post/App/request/create/controllers/request_controller.dart';

enum AuthType {
  none(name: 'None Auth'),
  basicAuth(name: 'Basic Auth'),
  bearerToken(name: 'Bearer Token'),
  apiKey(name: 'Api Key'),
  oauth2(name: 'OAuth 2.0'),
  digestAuth(name: 'Digest Auth'),
  awsSigV4(name: 'AWS Signature');

  const AuthType({required this.name, required});
  final String name;
}

// Authentication Model
class AuthConfiguration {
  AuthType? type;
  Map<String, dynamic> credentials = {};

  AuthConfiguration({required this.type, required this.credentials});
}

// Authentication Service
class AuthService {
  // Basic Authentication
  Map<String, String> getBasicAuthHeader(String username, String password) {
    final credentials = '$username:$password';
    final encodedCredentials = base64Encode(utf8.encode(credentials));
    return {'Authorization': 'Basic $encodedCredentials'};
  }

  // Bearer Token Authentication
  Map<String, String> getBearerTokenHeader(String token) {
    return {'Authorization': 'Bearer $token'};
  }

  // API Key Authentication
  Map<String, String> getApiKeyHeader(
      {required String apiKey,
      String location = 'header',
      String keyName = 'X-API-Key'}) {
    final _sc = Get.put(RequestCreateController());

    switch (location) {
      case 'header':
        _sc.dio.options.headers.addAll({keyName: apiKey});
        return {keyName: apiKey};
      case 'query':
        _sc.dio.options.queryParameters = {keyName: apiKey};
        return {};
      case 'body':
        // If using body, handle in request method
        return {};
      default:
        return {};
    }
  }

  // OAuth 2.0 Authentication
  Future<String> getOAuth2Token({
    required String clientId,
    required String clientSecret,
    required String tokenUrl,
    List<String> scopes = const [],
  }) async {
    try {
      final response = await Dio().post(tokenUrl, data: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
        'scope': scopes.join(' ')
      });

      return response.data['access_token'];
    } catch (e) {
      // Handle token retrieval error
      throw Exception('Failed to retrieve OAuth token');
    }
  }

  // Digest Authentication (Simplified)
  Map<String, String> getDigestAuthHeader({
    required String username,
    required String password,
    required String realm,
    required String nonce,
  }) {
    // Simplified digest auth implementation
    final ha1 =
        md5.convert(utf8.encode('$username:$realm:$password')).toString();
    final ha2 = md5.convert(utf8.encode('GET:/your-endpoint')).toString();
    final response = md5.convert(utf8.encode('$ha1:$nonce:$ha2')).toString();

    return {
      'Authorization': 'Digest '
          'username="$username", '
          'realm="$realm", '
          'nonce="$nonce", '
          'response="$response"'
    };
  }

  // AWS Signature V4
  Map<String, String> getAwsSignatureV4Headers({
    required String accessKey,
    required String secretKey,
    required String region,
    required String service,
    required DateTime timestamp,
    required String httpMethod,
    required String canonicalUri,
    Map<String, String>? queryParams,
  }) {
    // Implement AWS Signature V4 algorithm
    // This is a simplified version and needs more robust implementation
    final datetime = DateFormat('yyyyMMdd\'T\'HHmmss\'Z\'').format(timestamp);
    final date = DateFormat('yyyyMMdd').format(timestamp);

    // Canonical request creation
    final canonicalQueryString = queryParams?.entries
            .map((e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&') ??
        '';

    // Implement full AWS Signature V4 algorithm here
    // This is a placeholder and needs complete implementation
    return {
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential': '$accessKey/$date/$region/$service/aws4_request',
      'X-Amz-Date': datetime,
      // Add other required headers
    };
  }

  authenticateRequest({
    required AuthConfiguration authConfig,
    Map<String, String>? additionalHeaders,
  }) async {
    // Prepare headers based on auth type
    final headers = <String, String>{};
    final _sc = Get.put(RequestCreateController());

    switch (authConfig.type) {
      case AuthType.basicAuth:
        _sc.dio.options.headers.addAll(getBasicAuthHeader(
            _sc.authConfiguration.credentials['username'],
            _sc.authConfiguration.credentials['password']));
        break;

      case AuthType.bearerToken:
        _sc.dio.options.headers
            .addAll(getBearerTokenHeader(authConfig.credentials['token']));
        break;

      case AuthType.apiKey:
        getApiKeyHeader(
            apiKey: authConfig.credentials['apiKey'],
            location: authConfig.credentials['location'] ?? 'header',
            keyName: authConfig.credentials['keyName'] ?? 'X-API-Key');
        break;

      // Add other auth type handlers
      default:
        break;
    }

    // Add any additional headers
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
  }
}

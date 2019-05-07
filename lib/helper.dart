import 'dart:convert' show base64Encode, jsonDecode, jsonEncode, utf8;
import 'dart:convert';

import 'package:crypto/crypto.dart' show Hmac, sha256;
import 'package:googleapis_auth/auth.dart';
import 'package:http/http.dart' as Http;

import 'constants.dart' show apiKey, client, googleApiUrl, googleSheetsApiUrl;

String _createJwt() {
  var currentTime = DateTime.now();
  var header = jsonEncode({'alg': 'RS256', 'typ': 'JWT'});
  var headerEncoded = base64Encode(
    utf8.encode(header),
  );
  var claim = jsonEncode({
    'iss': client['client_email'],
    'scope': 'https://www.googleapis.com/auth/spreadsheets.readonly',
    'aud': 'https://www.googleapis.com/oauth2/v4/token',
    'exp': (currentTime.add(Duration(hours: 1)).millisecondsSinceEpoch / 1000)
        .round(),
    'iat': (currentTime.millisecondsSinceEpoch / 1000).round(),
  });
  var claimEncoded = base64Encode(
    utf8.encode(claim),
  );
  var rs256encrypt = Hmac(sha256, utf8.encode(client['private_key']));
  var signatureEncoded = base64Encode(
    rs256encrypt.convert(utf8.encode('$headerEncoded.$claimEncoded')).bytes,
  );

  return '$headerEncoded.$claimEncoded.$signatureEncoded}';
}

bool notNull(item) => item != null;

Future<Map<String, dynamic>> getAccessToken() {
  print('test');

  return Http.post(
    '$googleApiUrl/oauth2/v4/token',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: Uri(
      queryParameters: {
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': _createJwt(),
      },
    ).toString().substring(1),
  ).then((response) {
    var decodedResponse = Map<String, dynamic>.of(jsonDecode(response.body));

    if (decodedResponse['error'] != null) {
      throw Exception(response.body);
    }

    return decodedResponse
      ..addAll({'time_added': DateTime.now().millisecondsSinceEpoch});
  });
}

dynamic getHistory({AuthClient client, String url, String accessToken}) {
  var metadata = Uri.parse(url).pathSegments[0].split('-');
  print('metadata $metadata');

  // Hardcode for demo
  var creationDate = metadata[0];
  String clientName = metadata[2].toString();
  int key = 0;
  switch (clientName) {
    case 'simonli':
      key = 4;
      break;
    case 'benchau':
      key = 5;
      break;
    default:
        key = 0;
  }

  return client.get('$googleApiUrl/drive/v2/files').then((response) {
    var id = List<Map<String, dynamic>>.of(jsonDecode(response.body)['items']
            .map<Map<String, dynamic>>((item) => Map<String, dynamic>.of(item)))
        .firstWhere((file) =>
            file['title'] ==
            'Memory Ever Service Limited - 申請服務 (Responses)')['id'];
    print('id $id');
    return Http.get('$googleSheetsApiUrl/v4/spreadsheets/$id?key=$apiKey');
  }).then((response) {
    print(response.body);
  });
}

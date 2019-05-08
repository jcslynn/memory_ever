import 'dart:convert' show base64Encode, jsonDecode, jsonEncode, utf8;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart' show Hmac, sha256;
import 'package:googleapis_auth/auth.dart';
import 'package:http/http.dart' as Http;
import 'package:http/http.dart';

import 'classes/history/history.dart';
import 'classes/person/person.dart';
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

dynamic getHistory({AuthClient client, String url, String accessToken}) async {
  var metadata = Uri.parse(url).pathSegments[0].split('-');
  print('metadata $metadata');

  // Hardcode for demo
  int key = 0;
  if (metadata.length == 3) {
    String clientName = metadata[2].toString();
    switch (clientName) {
      case 'benchau':
        key = 5;
        break;
      case 'simonli':
        key = 4;
        break;
      default:
        key = 0;
    }
  } else if (metadata.length == 4) {
    key = int.parse(metadata[0]);
  }

  Response response = await client.get('$googleApiUrl/drive/v2/files');

  var id = List<Map<String, dynamic>>.of(jsonDecode(response.body)['items']
      .map<Map<String, dynamic>>(
          (item) => Map<String, dynamic>.of(item))).firstWhere((file) =>
      file['title'] == 'Memory Ever Service Limited - 申請服務 (Responses)')['id'];
  print('id $id');
  print('apiKey $apiKey');
  Response spreadsheetResponse = await Http.get(
      '$googleSheetsApiUrl/v4/spreadsheets/$id/values/Form responses 1!A$key:AK$key?key=$apiKey');
  var values = jsonDecode(spreadsheetResponse.body)['values'][0];
  print('values $values');

  // parse data
  DateFormat format = new DateFormat('dd/MM/yyyy');
  List<Person> people = new List();

  String hometown = values[26];
  String description = values[27];
  List<String> images = values[28].split(',');
  String bless = values[29];
  String finalSay = values[30];
  if (values[7] == '一位') {
    String name = values[20];
    String image = values[21];
    DateTime birthDate = format.parse(values[22]);
    String birthTime = values[23];
    DateTime deathDate = format.parse(values[24]);
    String deathTime = values[25];
    int age = deathDate.year - birthDate.year;

    Person p = new Person(hometown: hometown, name: name, imageUrl: image, age: age.toString());
    people.add(p);
  } else {
    String name = values[8];
    String image = values[9];
    DateTime birthDate = format.parse(values[10]);
    String birthTime = values[11];
    DateTime deathDate = format.parse(values[12]);
    String deathTime = values[13];
    int age = deathDate.year - birthDate.year;

    String name2 = values[14];
    String image2 = values[15];
    DateTime birthDate2 = format.parse(values[16]);
    String birthTime2 = values[17];
    DateTime deathDate2 = format.parse(values[18]);
    String deathTime2 = values[19];
    int age2 = deathDate2.year - birthDate2.year;

    Person p1 = new Person(hometown: hometown, name: name, imageUrl: image, age: age.toString());
    Person p2 = new Person(hometown: hometown, name: name2, imageUrl: image2, age: age2.toString());
    people.add(p1);
    people.add(p2);
  }
  return new History(people: people, description: description, url: url);
}

import 'dart:convert' show base64Encode, jsonDecode, jsonEncode, utf8;
import 'dart:convert';

import 'package:crypto/crypto.dart' show Hmac, sha256;
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart' as Http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'classes/history/history.dart';
import 'classes/person/person.dart';
import 'constants.dart' show apiKey, googleApiUrl, googleSheetsApiUrl;

bool notNull(item) => item != null;

Future<String> loadImage(AuthClient client, String imageId) async {
  DriveApi drive = new DriveApi(client);
  Media imageFile = await drive.files.get(imageId, downloadOptions: DownloadOptions.FullMedia);
  List<int> result = <int>[];
  await imageFile.stream.forEach((bytes) {
    result = result + bytes;
  });
  return base64Encode(result);
}

Future<History> getHistory({AuthClient client, String url, String accessToken}) async {
  var metadata = Uri.parse(url).pathSegments[0].split('-');

  // Hardcode for demo
  int key = 0;
  if (metadata.length == 3) {
    String clientName = metadata[2];
    switch (clientName) {
      case 'benchau':
        key = 3;
        break;
      case 'simonli':
        key = 2;
        break;
      default:
        key = 0;
    }
  } else if (metadata.length == 4) {
    key = int.parse(metadata[0]);
  }

  Response response = await client.get('$googleApiUrl/drive/v2/files');

  var id = List<Map<String, dynamic>>.of(
          jsonDecode(response.body)['items'].map<Map<String, dynamic>>((item) => Map<String, dynamic>.of(item)))
      .firstWhere((file) => file['title'] == 'Memory Ever Service Limited - 申請服務 (Responses)')['id'];

  var spreadsheetResponse =
      await Http.get('$googleSheetsApiUrl/v4/spreadsheets/$id/values/Form responses 1!A$key:AZ$key?key=$apiKey');
  var values = jsonDecode(spreadsheetResponse.body)['values'][0];

  // parse data
  var people = <Person>[];

//  String hometown = values[35];
  String description = values[35];
  String theme = metadata[metadata.length - 2];

  if (values[7] == '一位') {
    // values[7] specifies numbers of people
    String name = values[26];
    String hometown = values[29];
    String age = values[27];
    String imageId = Uri.parse(values[30]).queryParameters['id'];
    String image = await loadImage(client, imageId);

    Person p = Person(
      hometown: hometown,
      name: name,
      imageBase64: image,
      age: age,
    );
    people.add(p);
  } else {
    String name = values[8];
    String hometown = values[11];
    String age = values[9];
    String imageId = Uri.parse(values[12]).queryParameters['id'];
    String image = await loadImage(client, imageId);

    String name2 = values[17];
    String hometown2 = values[20];
    String age2 = values[18];
    String image2Id = Uri.parse(values[21]).queryParameters['id'];
    String image2 = await loadImage(client, image2Id);

    Person p1 = Person(
      hometown: hometown,
      name: name,
      imageBase64: image,
      age: age,
    );
    Person p2 = Person(
      hometown: hometown2,
      name: name2,
      imageBase64: image2, // base64Encode(imageContentResponse[1].bodyBytes),
      age: age2,
    );
    people.add(p1);
    people.add(p2);
  }

  return History(
    people: people,
    description: description,
    url: url,
    theme: theme,
  );
}

Future<bool> saveHistory(History history) async {
  var prefs = await SharedPreferences.getInstance();
  var historyJson = jsonEncode(history);

  return prefs.setStringList(
    'history',
    Set.of((prefs.getStringList('history') ?? <String>[])..add(historyJson)).toList(),
  );
}

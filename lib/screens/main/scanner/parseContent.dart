
import 'dart:convert'; // Contains the JSON encoder

import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'; // Contains DOM related classes for extracting data from elements

Future initiate(String url) async {
  var client = Client();
//  print(url);
  Response response = await client.get(url);

//  print('body: ' + response.body);

  // Use html parser and query selector
  var document = parse(response.body);
  List<Element> names = document.querySelectorAll('div.me-profile h1');
  List<Element> contents = document.querySelectorAll('div.me-profile table');

  List<Element> images = document.querySelectorAll('div.me-profile img');

  List<Map<String, dynamic>> linkMap = [];

  for (int i=0; i < names.length; i++) {
    List<String> content = contents[i].text.trim().split('\n\n\n\t');
    String hometown = content[0];
    String age = content[content.length - 1];
    linkMap.add({
      'name': names[i].text.trim(),
      'hometown': hometown,
      'age': age,
      'image': images[i].attributes['src'],
    });
  }

  return json.encode(linkMap);
}
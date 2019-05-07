import 'package:http/http.dart' as Http
    show Response, get; // Contains a client for making API calls
import 'package:html/parser.dart'
    show parse; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'
    show
        Element; // Contains DOM related classes for extracting data from elements
import 'package:memory_ever/classes/person/person.dart';
import 'package:memory_ever/classes/history/history.dart';

Future<History> initiate(String url) async {
//  var client = Client();
  Http.Response response = await Http.get(url);

  // Use html parser and query selector
  var document = parse(response.body);
  List<Element> names = document.querySelectorAll('div.me-profile h1');
  List<Element> contents = document.querySelectorAll('div.me-profile table');
  List<Element> images = document.querySelectorAll('div.me-profile img');
  Element info = document.querySelector('div.me-story p');

  List<Person> peopleInfo = [];

  for (int i = 0; i < names.length; i++) {
    List<String> content = contents[i].text.trim().split('\n\n\n\t');
    String hometown = content[0];
    String age = content.last;

    peopleInfo.add(Person(
      name: names[i].text.trim(),
      hometown: hometown,
      age: age,
      imageUrl: images[i].attributes['src'],
    ));
  }

  return History(
    people: peopleInfo,
    description: info.text.trim(),
    url: url,
  );
}

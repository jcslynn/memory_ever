import 'package:json_annotation/json_annotation.dart' show JsonSerializable;
import 'package:memory_ever/classes/person/person.dart';

part 'history.g.dart';

@JsonSerializable(nullable: false)
class History {
  const History({
    this.people,
    this.description,
    this.url,
    this.age,
    this.theme,
  });

  final List<Person> people;
  final String description;
  final String url;
  final String age;
  final String theme;

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);

  String getTrimmedDescription() => description.length > 40
      ? '${description.substring(0, 40)}...'
      : description;

  String getName() => people.length == 1 ? people[0].name : people[0].name + ' & ' + people[1].name;
}

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
  });

  final List<Person> people;
  final String description;
  final String url;
  final String age;

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}

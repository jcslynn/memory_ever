import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

part 'person.g.dart';

@JsonSerializable(nullable: false)
class Person {
  const Person({
    this.name,
    this.hometown,
    this.age,
    this.imageUrl,
  });

  final String name;
  final String hometown;
  final String imageUrl;
  final String age;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  String getHometown() => hometown.split('：')[1];

  String getAge() => age.split('：')[1];

  // those two methods should be temporary
}

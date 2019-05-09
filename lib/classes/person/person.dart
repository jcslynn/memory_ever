import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

part 'person.g.dart';

@JsonSerializable(nullable: false)
class Person {
  const Person({
    this.name,
    this.hometown,
    this.age,
    this.imageUrl,
    this.imageBase64,
  });

  final String name;
  final String hometown;
  final String imageUrl;
  final String imageBase64;
  final String age;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

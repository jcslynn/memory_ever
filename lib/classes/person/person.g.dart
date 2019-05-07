// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
      name: json['name'] as String,
      hometown: json['hometown'] as String,
      age: json['age'] as String,
      imageUrl: json['imageUrl'] as String);
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'name': instance.name,
      'hometown': instance.hometown,
      'imageUrl': instance.imageUrl,
      'age': instance.age
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) {
  return History(
      people: (json['people'] as List).map((e) => Person.fromJson(e as Map<String, dynamic>)).toList(),
      description: json['description'] as String,
      url: json['url'] as String,
      age: json['age'] as String,
      theme: json['theme'] as String);
}

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'people': instance.people,
      'description': instance.description,
      'url': instance.url,
      'age': instance.age,
      'theme': instance.theme
    };

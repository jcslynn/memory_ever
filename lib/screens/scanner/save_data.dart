import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveScannedData(String value) async {
  print('value $value');
  // saving to shared_preferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> data = prefs.getStringList('history') ?? [];
  data.add(value);
  return prefs.setStringList(
    'history',
    Set.of(data).toList(),
  );
}

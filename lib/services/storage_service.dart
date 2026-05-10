import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> saveInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<void> saveJson(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    await saveString(key, jsonString);
  }

  Map<String, dynamic>? getJson(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> saveJsonList(String key, List<Map<String, dynamic>> value) async {
    final jsonString = jsonEncode(value);
    await saveString(key, jsonString);
  }

  List<Map<String, dynamic>>? getJsonList(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded.map((dynamic e) => e as Map<String, dynamic>).toList();
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_service.dart';
import 'package:intl/intl.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(ref.watch(storageServiceProvider));
});

final userProfileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(userServiceProvider).getProfile();
});

class UserService {
  final StorageService _storage;
  static const String _profileKey = 'user_profile';

  UserService(this._storage);

  Future<Map<String, dynamic>> getProfile() async {
    final profile = _storage.getJson(_profileKey);
    if (profile == null) {
      final defaultProfile = _getDefaultProfile();
      await updateProfile(defaultProfile);
      return defaultProfile;
    }
    return profile;
  }

  Future<void> updateProfile(Map<String, dynamic> profile) async {
    await _storage.saveJson(_profileKey, profile);
  }

  Map<String, dynamic> _getDefaultProfile() {
    return <String, dynamic>{
      'name': 'Fitness User',
      'age': 30,
      'weight': 70,
      'height': 175,
      'calorieGoal': 2000,
      'memberSince': DateFormat('MMMM y').format(DateTime.now()),
    };
  }
}

import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<bool> saveImages({required String containerImages});

  Future<String> loadImages();

  Future<bool> setData({String? Key, String? Value});
  Future<String> getData({String? Key});
}

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences _sharedPref;

  LocalStorageImpl({required SharedPreferences sharedPreferences})
      : _sharedPref = sharedPreferences;

  @override
  Future<bool> saveImages({required String containerImages}) async {
    if (containerImages.isEmpty) {
      return false;
    }
    final result =
        await _sharedPref.setString("ImagesContainer", containerImages);
    return result;
  }

  @override
  Future<String> loadImages() async {
    final result = await _sharedPref.getString("ImagesContainer");
    return result ?? '';
  }

  @override
  Future<String> getData({String? Key}) async {
    final result = await _sharedPref.getString(Key ?? '');
    return result ?? '';
  }

  @override
  Future<bool> setData({String? Key, String? Value}) async {
    if (Key == null || Value == null) {
      return false;
    }
    final result = await _sharedPref.setString(Key ?? '', Value ?? '');
    return result;
  }
}

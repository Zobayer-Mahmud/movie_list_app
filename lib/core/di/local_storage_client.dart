import 'package:hive_flutter/hive_flutter.dart';
import '../error/exceptions.dart';

abstract class LocalStorageClient {
  Future<void> init();
  Future<void> put<T>(String boxName, String key, T value);
  Future<T?> get<T>(String boxName, String key);
  Future<List<T>> getAll<T>(String boxName);
  Future<void> delete(String boxName, String key);
  Future<void> clear(String boxName);
  Future<void> close();
}

class HiveLocalStorageClient implements LocalStorageClient {
  final Map<String, Box> _boxes = {};

  @override
  Future<void> init() async {
    try {
      await Hive.initFlutter();
    } catch (e) {
      throw CacheException('Failed to initialize Hive: $e');
    }
  }

  Future<Box<T>> _openBox<T>(String boxName) async {
    try {
      if (_boxes.containsKey(boxName)) {
        return _boxes[boxName]! as Box<T>;
      }

      final box = await Hive.openBox<T>(boxName);
      _boxes[boxName] = box;
      return box;
    } catch (e) {
      throw CacheException('Failed to open box $boxName: $e');
    }
  }

  @override
  Future<void> put<T>(String boxName, String key, T value) async {
    try {
      final box = await _openBox<T>(boxName);
      await box.put(key, value);
    } catch (e) {
      throw CacheException('Failed to put data in $boxName: $e');
    }
  }

  @override
  Future<T?> get<T>(String boxName, String key) async {
    try {
      final box = await _openBox<T>(boxName);
      return box.get(key);
    } catch (e) {
      throw CacheException('Failed to get data from $boxName: $e');
    }
  }

  @override
  Future<List<T>> getAll<T>(String boxName) async {
    try {
      final box = await _openBox<T>(boxName);
      return box.values.toList();
    } catch (e) {
      throw CacheException('Failed to get all data from $boxName: $e');
    }
  }

  @override
  Future<void> delete(String boxName, String key) async {
    try {
      final box = await _openBox(boxName);
      await box.delete(key);
    } catch (e) {
      throw CacheException('Failed to delete data from $boxName: $e');
    }
  }

  @override
  Future<void> clear(String boxName) async {
    try {
      final box = await _openBox(boxName);
      await box.clear();
    } catch (e) {
      throw CacheException('Failed to clear $boxName: $e');
    }
  }

  @override
  Future<void> close() async {
    try {
      for (final box in _boxes.values) {
        await box.close();
      }
      _boxes.clear();
      await Hive.close();
    } catch (e) {
      throw CacheException('Failed to close Hive: $e');
    }
  }
}

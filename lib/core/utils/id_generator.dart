import 'dart:math';

class IdGenerator {
  static String generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        16,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
  
  static String generateIdWithTimestamp() {
    return '${DateTime.now().millisecondsSinceEpoch}_${generateId()}';
  }
}

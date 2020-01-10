import 'package:flutter_test/flutter_test.dart';
import 'package:silicon_beach_admin/services/firestore_service.dart';

void main() {
  group('FirestoreService', () {
    // has a method that checks in a user at a space

    test('check the member in at space with id.', () async {
      final service = FirestoreService();

      print(service);
    });
  });
}

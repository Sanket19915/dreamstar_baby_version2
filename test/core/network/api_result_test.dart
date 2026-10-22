import 'package:dream_baby/core/network/api_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiResult', () {
    test('reports successful data', () {
      final result = ApiResult.success({'cycle': 1}, statusCode: 200);

      expect(result.isSuccess, isTrue);
      expect(result.data, {'cycle': 1});
      expect(result.statusCode, 200);
      expect(result.errorMessage, isNull);
    });

    test('reports backend failure details', () {
      final result = ApiResult<Map<String, dynamic>>.failure(
        'Please complete Cycle 2 next.',
        statusCode: 422,
        fieldErrors: {'cycle_number': 'Invalid cycle.'},
      );

      expect(result.isSuccess, isFalse);
      expect(result.data, isNull);
      expect(result.statusCode, 422);
      expect(result.errorMessage, 'Please complete Cycle 2 next.');
      expect(result.fieldErrors, {'cycle_number': 'Invalid cycle.'});
    });
  });
}

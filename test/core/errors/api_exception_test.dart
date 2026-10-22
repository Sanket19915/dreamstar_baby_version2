import 'package:dream_baby/core/errors/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiException', () {
    test('uses Laravel field errors when available', () {
      final message = ApiException.parseMessage({
        'message': 'Validation error',
        'errors': {
          'cycle_number': ['Please complete Cycle 2 next.'],
          'answers': ['One or more answers are missing.'],
        },
      });

      expect(
        message,
        'Please complete Cycle 2 next.\nOne or more answers are missing.',
      );
    });

    test('uses the backend message when field errors are absent', () {
      expect(
        ApiException.parseMessage({
          'message': 'Shuddhi Darpan access is required.',
        }),
        'Shuddhi Darpan access is required.',
      );
    });

    test('provides a safe fallback for an empty error response', () {
      expect(
        ApiException.parseMessage({}),
        'Something went wrong. Please try again.',
      );
    });

    test('preserves status code and response body', () {
      final exception = ApiException.fromResponse(
        statusCode: 403,
        body: {
          'message': 'Shuddhi Darpan access is required.',
        },
      );

      expect(exception.statusCode, 403);
      expect(exception.message, 'Shuddhi Darpan access is required.');
      expect(exception.body?['message'], 'Shuddhi Darpan access is required.');
    });
  });
}

import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/core/network/api_result.dart';
import 'package:dream_baby/core/errors/api_exception.dart';
import 'package:dream_baby/models/cycle_models.dart';

class ConceptionCycleService {
  ConceptionCycleService._();

  /// Step 1 & 2: Initialize cycle with LMP and avg cycle length
  static Future<ApiResult<MenstrualCycleModel>> initCycle({
    required String lmpDate,
    required int avgCycleLength,
  }) async {
    try {
      final body = await ApiClient.postForm(
        ApiConfig.conceptionCycleInit,
        {
          'lmp_date': lmpDate,
          'avg_cycle_length': avgCycleLength.toString(),
        },
        authenticated: true,
      );
      final cycle = MenstrualCycleModel.fromJson(
          body['data'] as Map<String, dynamic>? ?? {});
      return ApiResult.success(cycle);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, statusCode: e.statusCode);
    } catch (_) {
      return ApiResult.failure('Failed to initialize cycle. Please try again.');
    }
  }

  /// Step 3 & 5B: Get current cycle status, phase, fertile window
  static Future<ApiResult<CycleStatusModel>> getCycleStatus() async {
    try {
      final body = await ApiClient.get(
        ApiConfig.conceptionCycleStatus,
        authenticated: true,
      );
      final status = CycleStatusModel.fromJson(
          body['data'] as Map<String, dynamic>? ?? {});
      return ApiResult.success(status);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, statusCode: e.statusCode);
    } catch (_) {
      return ApiResult.failure('Failed to get cycle status. Please try again.');
    }
  }

  static Future<ApiResult<bool>> startShuddhiJourney() async {
    try {
      await ApiClient.postForm(
        ApiConfig.startShuddhiJourney,
        {},
        authenticated: true,
      );
      return ApiResult.success(true);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, statusCode: e.statusCode);
    } catch (_) {
      return ApiResult.failure('Failed to start Shuddhi journey.');
    }
  }

  /// Step 5A & 6A: Log period start date
  static Future<ApiResult<MenstrualCycleModel>> logPeriod({
    required String lmpDate,
  }) async {
    try {
      final body = await ApiClient.postForm(
        ApiConfig.conceptionCycleLogPeriod,
        {'lmp_date': lmpDate},
        authenticated: true,
      );
      final cycle = MenstrualCycleModel.fromJson(
          body['data'] as Map<String, dynamic>? ?? {});
      return ApiResult.success(cycle);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, statusCode: e.statusCode);
    } catch (_) {
      return ApiResult.failure('Failed to log period. Please try again.');
    }
  }

  /// Step 6B: Log pregnancy test result
  static Future<ApiResult<bool>> logPregnancyTest({
    required String result, // 'positive', 'negative', 'not_yet'
  }) async {
    try {
      await ApiClient.postForm(
        ApiConfig.conceptionCyclePregnancyTest,
        {'result': result},
        authenticated: true,
      );
      return ApiResult.success(true);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, statusCode: e.statusCode);
    } catch (_) {
      return ApiResult.failure(
          'Failed to log pregnancy test. Please try again.');
    }
  }

  /// Step 7 & 8: Get cycle history and irregular pattern check
  static Future<ApiResult<CycleHistoryModel>> getCycleHistory() async {
    try {
      final body = await ApiClient.get(
        ApiConfig.conceptionCycleHistory,
        authenticated: true,
      );
      final history = CycleHistoryModel.fromJson(
          body['data'] as Map<String, dynamic>? ?? {});
      return ApiResult.success(history);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, statusCode: e.statusCode);
    } catch (_) {
      return ApiResult.failure('Failed to get cycle history. Please try again.');
    }
  }

  /// Step 9: Submit the 3 questions for calendar mapping
  static Future<ApiResult<bool>> submitStep9Questions({
    required String lmpDate,
    required int periodDuration,
    required int avgCycleLength,
  }) async {
    try {
      await ApiClient.postForm(
        ApiConfig.conceptionCycleStep9,
        {
          'lmp_date': lmpDate,
          'period_duration': periodDuration.toString(),
          'avg_cycle_length': avgCycleLength.toString(),
        },
        authenticated: true,
      );
      return ApiResult.success(true);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, statusCode: e.statusCode);
    } catch (_) {
      return ApiResult.failure(
          'Failed to submit your answers. Please try again.');
    }
  }
}

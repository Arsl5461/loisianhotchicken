import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> handleError({
  required String tag,
  required String error,
  String? stack,
}) async {
  await ErrorLogger.handleError(tag: tag, error: error, stack: stack);
}

class ErrorLogger {
  static const _fileName = "plate_error_logs.json";

  static Future<File> _getLogFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/$_fileName");
  }

  /// Save new error log
  static Future<void> handleError({
    required String tag,
    required String error,
    String? stack,
  }) async {
    final logEntry = {
      "tag": tag,
      "error": error,
      "stack": stack ?? "No stack trace",
      "time": DateTime.now().toIso8601String(),
    };

    final file = await _getLogFile();

    List<Map<String, dynamic>> logs = [];
    if (await file.exists()) {
      try {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          logs = List<Map<String, dynamic>>.from(jsonDecode(content));
        }
      } catch (e) {
        // JSON corrupted → reset logs
        debugPrint("⚠️ Corrupted log file, resetting. Error: $e");
        logs = [];
      }
    }

    logs.add(logEntry);

    await file.writeAsString(jsonEncode(logs));

    debugPrint(
      "Occurred From Class = $tag\nError = $error\nStack = ${stack ?? 'No stack trace'}",
    );
  }

  /// Get logs safely
  static Future<List<Map<String, dynamic>>> getLogs() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      try {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          return List<Map<String, dynamic>>.from(jsonDecode(content));
        }
      } catch (e) {
        debugPrint("⚠️ Failed to parse logs: $e, returning empty.");
        return [];
      }
    }
    return [];
  }

  /// Clear logs
  static Future<void> clearLogs() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      await file.writeAsString("[]"); // reset JSON to empty array
    }
  }
}

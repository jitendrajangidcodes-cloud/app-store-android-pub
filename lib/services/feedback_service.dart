import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';

enum FeedbackType { feedback, suggestion, bug }

extension FeedbackTypeX on FeedbackType {
  String get wire => switch (this) {
        FeedbackType.feedback => "feedback",
        FeedbackType.suggestion => "suggestion",
        FeedbackType.bug => "bug",
      };
  String get title => switch (this) {
        FeedbackType.feedback => "Feedback",
        FeedbackType.suggestion => "Suggestion",
        FeedbackType.bug => "Bug report",
      };
}

class FeedbackException implements Exception {
  final String message;
  const FeedbackException(this.message);
  @override
  String toString() => message;
}

// Posts feedback to the Worker, which creates the GitHub issue. The app sends
// no captcha token (it has no browser Origin, so the Worker skips Turnstile and
// relies on the honeypot + per-IP rate limit); the honeypot field is always
// empty from the real app.
class FeedbackService {
  static Future<void> submit({
    required FeedbackType type,
    required String message,
    String? email,
    String? appName,
    String? appId,
  }) async {
    final res = await http
        .post(
          Uri.parse(Config.feedbackEndpoint),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "type": type.wire,
            "message": message,
            "email": email ?? "",
            "appName": appName ?? "",
            "appId": appId ?? "",
            "website": "",
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (res.statusCode == 429) {
      throw const FeedbackException("You've sent a few already — try again later.");
    }
    if (res.statusCode != 200 || !_ok(res.body)) {
      throw const FeedbackException("Could not send right now. Please try again.");
    }
  }

  static bool _ok(String body) {
    try {
      return (jsonDecode(body) as Map<String, dynamic>)["ok"] == true;
    } catch (_) {
      return false;
    }
  }
}

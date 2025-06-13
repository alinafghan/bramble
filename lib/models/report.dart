import 'package:journal_app/models/user.dart';

class Report {
  final Users user;
  final String reason;
  final String reportedAt;

  Report({
    required this.user,
    required this.reason,
    required this.reportedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user.toDocument(),
      'reason': reason,
      'reportedAt': reportedAt,
    };
  }

  static Report fromMap(Map<String, dynamic> map) {
    return Report(
      user: Users.fromDocument(map['user'] as Map<String, dynamic>),
      reason: map['reason'] as String,
      reportedAt: map['reportedAt'] as String,
    );
  }
}

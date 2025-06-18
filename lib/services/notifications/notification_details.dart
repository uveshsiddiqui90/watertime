class NotificationDetailModel {
  final int id;
  final String? title;
  final String? body;
  final DateTime? scheduledTime;
  final int? reminderId;

  NotificationDetailModel({
    required this.id,
    this.title,
    this.body,
    this.scheduledTime,
    this.reminderId,
  });
}
class NotificationDetailModel {
  final int id;
  final String? title;
  final String? body;
  final DateTime? scheduledTime;
  final int? reminderId;
  final String? waterML;

  NotificationDetailModel({
    required this.id,
    this.title,
    this.body,
    this.scheduledTime,
    this.reminderId,
    this.waterML,
  });

  
}
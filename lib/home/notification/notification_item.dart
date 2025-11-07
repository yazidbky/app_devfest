class NotificationItem {
  final String id;
  final String title;
  final String location;
  final String date;
  final String time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    this.isRead = false,
  });
}

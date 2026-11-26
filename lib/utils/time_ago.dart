/// "2d ago", "3h ago" ... for a past [date]. Empty dates read "Just now".
String timeAgo(DateTime? date) {
  if (date == null) return 'Just now';
  final diff = DateTime.now().difference(date);
  if (diff.inDays >= 7) return '${diff.inDays ~/ 7}w ago';
  if (diff.inDays >= 1) return '${diff.inDays}d ago';
  if (diff.inHours >= 1) return '${diff.inHours}h ago';
  return 'Just now';
}

import 'package:intl/intl.dart';
import 'constants.dart';

class Helpers {
  static final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat timeFormat = DateFormat('HH:mm');

  static String formatDate(DateTime date) => dateFormat.format(date);
  static String formatDateTime(DateTime date) => dateTimeFormat.format(date);
  static String formatTime(DateTime date) => timeFormat.format(date);
  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return formatDate(date);
  }

  static String formatPoints(int points) {
    if (points >= 1000) return '${(points / 1000).toStringAsFixed(1)}K';
    return points.toString();
  }

  static BadgeLevel? getBadgeLevel(int totalPoints) {
    if (totalPoints >= AppConstants.platinumThreshold) return BadgeLevel.platinum;
    if (totalPoints >= AppConstants.goldThreshold) return BadgeLevel.gold;
    if (totalPoints >= AppConstants.silverThreshold) return BadgeLevel.silver;
    if (totalPoints >= AppConstants.bronzeThreshold) return BadgeLevel.bronze;
    return null;
  }

  static String getBadgeEmoji(int totalPoints) {
    if (totalPoints >= AppConstants.platinumThreshold) return '💎';
    if (totalPoints >= AppConstants.goldThreshold) return '🥇';
    if (totalPoints >= AppConstants.silverThreshold) return '🥈';
    if (totalPoints >= AppConstants.bronzeThreshold) return '🥉';
    return '🌱';
  }
}

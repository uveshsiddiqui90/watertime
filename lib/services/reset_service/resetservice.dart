import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:intl/intl.dart';
import 'package:watertime/database/app_database.dart';
import 'dart:convert';

// @pragma('vm:entry-point')
//    Future<void> resetConsumedAmountTask() async {
//     final db = AppDatabase();
//     await db.updateConsumedAmount(0.0, reset: true);
//   }




@pragma('vm:entry-point')
Future<void> resetConsumedAmountTask() async {
  final db = AppDatabase();

  // ✅ Save yesterday's consumed amount into history
  final user = await db.getLatestUser();
  if (user != null) {
    await db.addDailyHistory(
      user.consumedAmount ?? 0.0,
      forDate: DateTime.now().subtract(Duration(days: 1)), // pichle din ka record
    );
  }

  // ✅ Reset consumed amount
  await db.updateConsumedAmount(0.0, reset: true);

  print("✅ Consumed amount reset done (background)");
}




class ResetService {



  static void scheduleMidnightReset() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);

    AndroidAlarmManager.oneShotAt(
      midnight,
      0,
      resetConsumedAmountTask,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );

    print("⏰ Midnight reset scheduled for $midnight");
  }




static Future<void> endDayManuallytesting() async {
  final database = AppDatabase();
  final user = await database.getLatestUser();
  if (user == null) return;

  // Today's total
  final todayTotal = user.consumedAmount ?? 0;

  // Old history
  List<Map<String, dynamic>> history = [];
  if (user.historyJson != null && user.historyJson!.isNotEmpty) {
    history = List<Map<String, dynamic>>.from(jsonDecode(user.historyJson!));
  }

  // Add new record
  history.add({
    'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'amount': todayTotal,
  });

  // Update in DB
  await database.updateUserData(
    user.id,
    historyJson: jsonEncode(history),
    consumedAmount: 0, // reset
  );

  print("✅ Day ended: $todayTotal ml saved to history");
}
}

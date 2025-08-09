import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watertime/database/app_database.dart';
import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';

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
    await db.addDailyHistory(user.consumedAmount ?? 0.0);
  }

  // ✅ Reset consumed amount
  await db.updateConsumedAmount(0.0, reset: true);

  print("✅ Consumed amount reset done (background)");
}



class ResetService {

 final database = AppDatabase();

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


}

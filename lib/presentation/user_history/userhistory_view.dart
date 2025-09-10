import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:watertime/database/app_database.dart';


class UserhistoryView extends StatelessWidget {
  final  db = AppDatabase();

  UserhistoryView({super.key,});

  String getDayName(DateTime date) {
    return DateFormat('EEE').format(date); // Mon, Tue, Wed
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('dd MMM').format(date); // 09 Aug
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Last 7 Days History")),
      body: FutureBuilder(
        future: db.getLatestUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final user = snapshot.data!;

           List<dynamic> history = jsonDecode(user.historyJson ?? '[]');
          
          if (history.isEmpty) {
            return const Center(child: Text("No history found"));
          }

          return Padding(
            padding:  EdgeInsets.symmetric(vertical: 5.h),
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final date = DateTime.parse(item["date"]);
                final amount = item["consumedAmount"];
               
            
                return Card(
                   margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                   elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(getDayName(date)),
                    ),
                    title: Text(getFormattedDate(date)),
                    trailing: Text("${amount % 1 == 0 ? amount.toInt() : amount} ml"),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

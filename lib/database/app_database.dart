import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:watertime/database/remider.dart';
import 'user.dart';
part 'app_database.g.dart'; 

@DriftDatabase(tables: [Users, Reminders])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 15;



  Future<int> insertUser(String name, {String? gender, double? weight, double consumedAmount = 0.0,}) {
  return into(users).insert(
    UsersCompanion(
      name: Value(name),
      gender: Value(gender),
      weight: Value(weight),
      consumedAmount: Value(0.0),
    ),
  );
}


Future<void> updateUserWeight(int id, double weight) async {
    await (update(users)..where((u) => u.id.equals(id)))
      .write(UsersCompanion(weight: Value(weight)));
  }


// Get users by weight range
Future<List<User>> getUsersByWeightRange(double min, double max) {
  return (select(users)
    ..where((u) => u.weight.isBetweenValues(min, max)))
    .get();
}

  // Update multiple fields
  // Future<void> updateUser(int id, {String? name, String? gender, double? weight}) async {
  //   await (update(users)..where((u) => u.id.equals(id))).write(
  //     UsersCompanion(
  //       name: Value(name??''),
  //       gender: Value(gender),
  //       weight: Value(weight),
  //     ),
  //   );
  // }

Future<void> updateUserData(int id,
    {String? name,
    String? gender,
    double? weight,
    String? historyJson,
    double? consumedAmount}) async {
  await (update(users)..where((u) => u.id.equals(id))).write(
    UsersCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      gender: gender != null ? Value(gender) : const Value.absent(),
      weight: weight != null ? Value(weight) : const Value.absent(),
      historyJson: historyJson != null ? Value(historyJson) : const Value.absent(),
      consumedAmount: consumedAmount != null ? Value(consumedAmount) : const Value.absent(),
    ),
  );
}


Future<void> updateConsumedAmount(double amount, {bool reset = false}) async {
  final user = await getLatestUser();
  if (user != null) {
    await (update(users)..where((u) => u.id.equals(user.id)))
        .write(UsersCompanion(
          consumedAmount: Value(reset ? amount : (user.consumedAmount ?? 0) + amount),
        ));
  }
}




  Future<List<User>> getAllUsers() => select(users).get();

// app_database.dart me function add karo
Future<User?> getLatestUser() async {
  return (select(users)
          ..orderBy([(u) => OrderingTerm.desc(u.id)])
          ..limit(1))
      .getSingleOrNull();
}

// Add a reminder
Future<int> insertReminder(RemindersCompanion reminder) {
  return into(reminders).insert(reminder);
}

// Get reminders for user
Future<List<Reminder>> getRemindersForUser(int userId) 
{
  return (select(reminders)..where((r) => r.userId.equals(userId))).get();
}

// Delete
Future<void> deleteReminder(int id) {
  return (delete(reminders)..where((r) => r.id.equals(id))).go();
}

Future<void> deleteAllReminders() async {
  await delete(reminders).go();
}

// 🔹 Get all reminders (no user filtering)
Future<List<Reminder>> getAllReminders() {
  return select(reminders).get();
}


Future<void> addDailyHistory(double consumed, {DateTime? forDate}) async {
  final user = await getLatestUser();
  if (user == null) return;

  // Agar date di gayi hai to wo use karo, warna current date lo
  final saveDate = forDate ?? DateTime.now();

  // Parse old history
  final oldHistory = List<Map<String, dynamic>>.from(
    jsonDecode(user.historyJson ?? '[]'),
  );

  // Add entry
  oldHistory.add({
    "date": DateFormat('yyyy-MM-dd').format(saveDate), // sirf date part
    "consumedAmount": consumed,
  });

  // Keep last 7 days only
  while (oldHistory.length > 7) {
    oldHistory.removeAt(0);
  }

  // Save back to DB
  await (update(users)..where((u) => u.id.equals(user.id))).write(
    UsersCompanion(historyJson: Value(jsonEncode(oldHistory))),
  );
}


Future<List<Map<String, dynamic>>> getLast7DaysHistory() async {
  final user = await getLatestUser();
  if (user == null) return [];

  final history = List<Map<String, dynamic>>.from(
    jsonDecode(user.historyJson ?? '[]'),
  );

  return history;
}


@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) async {
    await m.createAll();
    // Purane null crash se bachne ke liye default value set
    await customStatement("UPDATE users SET history_json = '[]'");
  },
  onUpgrade: (m, from, to) async {
    await m.createAll();
    await customStatement("UPDATE users SET history_json = '[]'");
  },
);







}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:watertime/database/remider.dart';
import 'user.dart';
part 'app_database.g.dart'; 

@DriftDatabase(tables: [Users, Reminders])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 10;



  Future<int> insertUser(String name, {String? gender, double? weight}) {
  return into(users).insert(
    UsersCompanion(
      name: Value(name),
      gender: Value(gender),
      weight: Value(weight),
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
  Future<void> updateUser(int id, {String? name, String? gender, double? weight}) async {
    await (update(users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(
        name: Value(name??''),
        gender: Value(gender),
        weight: Value(weight),
      ),
    );
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
Future<List<Reminder>> getRemindersForUser(int userId) {
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



@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) => m.createAll(),
  onUpgrade: (m, from, to) async {
    await m.createAll();  // Important for dev/testing
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

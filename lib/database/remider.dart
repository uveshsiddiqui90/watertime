// reminder.dart
import 'package:drift/drift.dart';
import 'package:watertime/database/user.dart';

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)(); // Link to user
  TextColumn get title => text()();
  TextColumn get body => text()();
  DateTimeColumn get scheduledTime => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get reminderId => integer().nullable()(); // for system notification id
  TextColumn get time => text()();          // e.g. "10:00 AM"
  TextColumn get waterML => text()();       // e.g. "250"
}

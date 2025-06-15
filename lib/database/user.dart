// lib/database/user.dart
import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  TextColumn get gender => text().nullable()();
  // Add weight column (nullable or with default as needed)
  RealColumn get weight => real().nullable()(); 
}

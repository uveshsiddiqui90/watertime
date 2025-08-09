// lib/database/user.dart
import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  TextColumn get gender => text().nullable()();
  RealColumn get weight => real().nullable()(); 
  RealColumn get consumedAmount => real().withDefault(Constant(0.0))();
  DateTimeColumn get lastUpdatedDate => dateTime().nullable()();
  TextColumn get historyJson => text().nullable()();
  
  
  
  
}

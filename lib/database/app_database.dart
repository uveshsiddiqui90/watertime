import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'user.dart';
part 'app_database.g.dart'; 

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;



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


@override
  MigrationStrategy get migration => MigrationStrategy(
    // Runs when the database is first created
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    // Runs when upgrading versions
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Add new columns when upgrading to version 2
        await m.addColumn(users, users.gender);
        await m.addColumn(users, users.weight);
      }
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

import 'package:bytebanksqlite/database/app_database.dart';
import 'package:bytebanksqlite/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {
  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';
  static const String tableSql = "CREATE TABLE $_tableName( "
      "$_id INTEGER PRIMARY KEY, "
      "$_name TEXT, "
      "$_accountNumber INTEGER)";

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();

    return db.insert(_tableName, _toMap(contact), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();

    contactMap[_name] = contact.name;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);

    return _toList(result);
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = List();

    for (Map<String, dynamic> row in result) {
      final Contact contact =
          Contact(row[_id], row[_name], row[_accountNumber]);

      contacts.add(contact);
    }

    return contacts;
  }

  Future<void> update(Contact contact) async {
    final Database db = await getDatabase();
    
    await db.update(_tableName, _toMap(contact), where: "$_id = ?", whereArgs: [contact.id]);
  }

  Future<void> delete(Contact contact) async {
    final Database db = await getDatabase();

    db.delete(_tableName, where: "$_id = ?", whereArgs: [contact.id]);
  }
}

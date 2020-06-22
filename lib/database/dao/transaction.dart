import 'package:bytebanksqlite/database/app_database.dart';
import 'package:bytebanksqlite/models/transaction.dart';
import 'package:sqflite/sqflite.dart' show Database;

class TransactionDAO {
  static const String _tableName = 'transactions';
  static const String _id = 'id';
  static const String _value = 'value';
  static const String _contact = 'contact';
  static const String _datetime = 'datetime';
  static const String tableSql = "CREATE TABLE $_tableName( "
      "$_id INTEGER PRIMARY KEY, "
      "$_value DOUBLE, "
      "$_contact INTEGER,"
      "$_datetime DATETIME"
      "FOREIGN KEY($_contact) REFERENCES contacts(id))";

  Future<List<Transaction>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);

    return _toList(result);
  }

  List<Transaction> _toList(List<Map<String, dynamic>> result) {
    final List<Transaction> transactions = List();

    for (Map<String, dynamic> row in result) {
      final Transaction transaction =
      Transaction(row[_value], row[_contact]);

      transactions.add(transaction);
    }

    return transactions;
  }
}
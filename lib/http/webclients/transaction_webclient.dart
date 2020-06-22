import 'dart:convert';

import 'package:bytebanksqlite/http/webclient.dart';
import 'package:bytebanksqlite/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebclient {
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(baseUrl).timeout(Duration(seconds: 5));
    List<Transaction> transactions = _toTransactions(response);

    return transactions;
  }

  Future<Transaction> save(Transaction transaction) async {
    final Response response = await client.post(
      baseUrl,
      headers: {
        'Content-type': 'application/json',
        'password': '1000',
      },
      body: jsonEncode(transaction.toJson()),
    );

    return _toTransaction(response);
  }

  Transaction _toTransaction(Response response) {
    final Map<String, dynamic> json = jsonDecode(response.body);

    return Transaction.fromJson(json);
  }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> decodeTransactions = jsonDecode(response.body);
    final List<Transaction> transactions = List();

    for (Map<String, dynamic> decodeTransaction in decodeTransactions) {
      transactions.add(Transaction.fromJson(decodeTransaction));
    }

    return transactions;
  }
}

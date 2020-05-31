import 'dart:convert';

import 'package:bytebanksqlite/http/webclient.dart';
import 'package:bytebanksqlite/models/contact.dart';
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
    Map<String, dynamic> transactionMap = _toMap(transaction);

    final Response response = await client.post(
      baseUrl,
      headers: {
        'Content-type': 'application/json',
        'password': '1000',
      },
      body: jsonEncode(transactionMap),
    );

    return _toTransaction(response);
  }

  Transaction _toTransaction(Response response) {
    final Map<String, dynamic> decodeTransaction = jsonDecode(response.body);
    final Contact contact = Contact(0, decodeTransaction['contact']['name'],
        decodeTransaction['contact']['accountNumber']);

    return Transaction(decodeTransaction['value'], contact);
  }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> decodeTransactions = jsonDecode(response.body);
    final List<Transaction> transactions = List();

    for (Map<String, dynamic> decodeTransaction in decodeTransactions) {
      final Contact contact = Contact(0, decodeTransaction['contact']['name'],
          decodeTransaction['contact']['accountNumber']);
      transactions.add(Transaction(decodeTransaction['value'], contact));
    }
    return transactions;
  }

  Map<String, dynamic> _toMap(Transaction transaction) {
    final Map<String, dynamic> transactionMap = {
      'value': transaction.value,
      'contact': {
        'name': transaction.contact.name,
        'accountNumber': transaction.contact.accountNumber
      }
    };
    return transactionMap;
  }
}

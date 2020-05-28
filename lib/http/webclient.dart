import 'dart:convert';

import 'package:bytebanksqlite/models/contact.dart';
import 'package:bytebanksqlite/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('Request');
    print('url: ${data.url}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('Response');
    print('Status code: ${data.statusCode}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');

    return data;
  }
}

final Client client =
    HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);
final String baseUrl = 'http://192.168.0.34:8080/transactions';

Future<List<Transaction>> findAll() async {
  final Response response =
      await client.get(baseUrl).timeout(Duration(seconds: 5));
  final List<dynamic> decodeTransactions = jsonDecode(response.body);
  final List<Transaction> transactions = List();

  for (Map<String, dynamic> decodeTransaction in decodeTransactions) {
    final Contact contact = Contact(0, decodeTransaction['contact']['name'],
        decodeTransaction['contact']['accountNumber']);
    transactions.add(Transaction(decodeTransaction['value'], contact));
  }

  return transactions;
}

Future<Transaction> save(Transaction transaction) async {
  final Map<String, dynamic> transactionMap = {
    'value': transaction.value,
    'contact': {
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber
    }
  };

  final Response response = await client.post(
    baseUrl,
    headers: {
      'Content-type': 'application/json',
      'password': '1000',
    },
    body: jsonEncode(transactionMap),
  );

  final Map<String, dynamic> decodeTransaction = jsonDecode(response.body);
  final Contact contact = Contact(0, decodeTransaction['contact']['name'],
      decodeTransaction['contact']['accountNumber']);

  return Transaction(decodeTransaction['value'], contact);
}

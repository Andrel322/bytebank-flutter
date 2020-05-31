import 'package:bytebanksqlite/components/share/centered_message.dart';
import 'package:bytebanksqlite/components/share/progress.dart';
import 'package:bytebanksqlite/http/webclients/transaction_webclient.dart';
import 'package:bytebanksqlite/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {
  final TransactionWebclient _transactionWebclient = new TransactionWebclient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _transactionWebclient.findAll(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress();
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                final List<Transaction> transactions = snapshot.data;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Transaction transaction = transactions[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.monetization_on),
                        title: Text(
                          transaction.value.toString(),
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          transaction.contact.accountNumber.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: transactions.length,
                );
              }

              return CenteredMessage('No Transactions Found',
                  icon: Icons.warning);
              break;
          }

          return CenteredMessage('Unknown Error');
        },
      ),
    );
  }
}

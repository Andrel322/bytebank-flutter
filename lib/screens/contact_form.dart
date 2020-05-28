import 'package:bytebanksqlite/database/dao/contact.dart';
import 'package:bytebanksqlite/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accontController = TextEditingController();
  final ContactDao _contactDao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Form'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full name',
            ),
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: _accontController,
              decoration: InputDecoration(
                labelText: 'Accont number',
              ),
              style: TextStyle(
                fontSize: 24.0,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RaisedButton(
              onPressed: () {
                final String name = _nameController.text;
                final int accountNumber = int.tryParse(_accontController.text);
                final Contact newContact = Contact(0, name, accountNumber);

                _contactDao
                    .save(newContact)
                    .then((id) => Navigator.pop(context));
              },
              child: Text('Create'),
            ),
          )
        ],
      ),
    );
  }
}

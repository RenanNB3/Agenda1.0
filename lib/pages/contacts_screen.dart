import 'package:flutter/material.dart';
import 'contact_details_screen.dart';
import 'add_contact_screen.dart';
import 'contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late Database _database;
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _getContacts();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'contacts_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phoneNumber TEXT, email TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> _getContacts() async {
    final List<Map<String, dynamic>> maps = await _database.query('contacts');
    setState(() {
      contacts = List.generate(maps.length, (index) {
        return Contact.fromMap(maps[index]);
      });
    });
  }

  Future<void> _insertContact(Contact contact) async {
    await _database.insert('contacts', contact.toMap());
  }

  Future<void> _deleteContact(int id) async {
    await _database.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Contatos'),
        backgroundColor: Color.fromARGB(255, 230, 181, 89),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 252, 236, 197),
              Color.fromARGB(255, 255, 221, 158),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: ListTile(
                key: Key(contacts[index].id.toString()), // Adiciona uma chave única
                title: Text(contacts[index].name),
                subtitle: Text(contacts[index].phoneNumber),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactDetailsScreen(contacts[index]),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await _deleteContact(contacts[index].id!);
                    setState(() {
                      contacts.remove(contacts[index]); // Usa remove em vez de removeAt
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddContactScreen()),
              ).then((newContact) {
                if (newContact != null) {
                  _insertContact(newContact);
                  setState(() {
                    contacts.add(newContact);
                  });
                }
              });
            },
            child: Text('Adicionar Contato'),
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 230, 181, 89),
              minimumSize: Size(200, 50),
            ),
          ),
        ),
      ),
    );
  }
}

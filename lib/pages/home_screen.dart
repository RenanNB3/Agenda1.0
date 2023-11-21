import 'package:flutter/material.dart';
import 'contacts_screen.dart';

class HomeScreen extends StatelessWidget {
  static const IconData _contactsIcon = Icons.folder_copy_outlined;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de contatos'),
        backgroundColor: Color.fromARGB(255, 230, 181, 89),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/foto.png', width: 400, height:400),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactsScreen()),
                );
              },
              child: ElevatedButton.icon(
                onPressed: null,
                icon: Icon(_contactsIcon),
                label: Text('Ir para contatos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

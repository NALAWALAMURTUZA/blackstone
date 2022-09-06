import 'package:flutter/material.dart';

class NoContacts extends StatelessWidget {
  const NoContacts({Key key, @required this.onAdd}) : super(key: key);
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.black45,
          ),
          const Text(
            'No contacts listed',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          FlatButton(
            color: Colors.purple,
            onPressed: onAdd,
            child: const Text(
              'Add your first',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

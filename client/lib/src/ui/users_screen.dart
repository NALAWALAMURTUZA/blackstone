import 'package:client/src/dataprovider/userdp.dart';
import 'package:client/src/ui/dailog/user_dialog.dart';
import 'package:core/model/user.dart';
import 'package:flutter/material.dart';

import 'users_listing.dart';

class UsersScreen extends StatefulWidget {
  UsersScreen({Key key, @required this.title}) : super(key: key);

  final String title;
  final UserDp api = UserDp();

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts([bool showSpinner = false]) {
    if (showSpinner) {
      setState(() {
        loading = true;
      });
    }

    widget.api.get().then((data) {
      setState(() {
        users = data;
        loading = false;
      });
    });
  }

  void _addUser(User value) async {
    if (value.id != null && value.id.isNotEmpty) {
      final createdContact = await widget.api.update(value.id, value);
      setState(() {
        users.removeWhere((element) => element.id == value.id);
        users.add(createdContact);
      });
    } else {
      final createdContact = await widget.api.save(value);
      setState(() {
        users.add(createdContact);
      });
    }
  }

  void _deleteContact(String id) async {
    await widget.api.delete(id);
    setState(() {
      users.removeWhere((contact) => contact.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : UsersListing(
              users: users,
              onAdd: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return UserDialog(
                        onClickedDone: (User user) {
                          _addUser(user);
                        },
                      );
                    });
              },
              onDelete: _deleteContact,
              onUpdate: (User user) {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UserDialog(
                      user: user,
                      onClickedDone: (User user) {
                        _addUser(user);
                      },
                    );
                  },
                );
              },
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _loadContacts(true);
            },
            tooltip: 'Refresh list',
            backgroundColor: Colors.purple,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UserDialog(onClickedDone: (User user) {
                      _addUser(user);
                    });
                  });
            },
            tooltip: 'Add new contact',
            child: const Icon(Icons.person_add),
          ),
        ],
      ),
    );
  }
}

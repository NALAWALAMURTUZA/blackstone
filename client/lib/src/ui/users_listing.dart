import 'package:client/src/ui/no_contacts.dart';
import 'package:core/model/user.dart';
import 'package:flutter/material.dart';

class UsersListing extends StatelessWidget {
  const UsersListing({
    Key key,
    @required this.users,
    @required this.onAdd,
    @required this.onDelete,
    @required this.onUpdate,
  }) : super(key: key);

  final List<User> users;
  final VoidCallback onAdd;
  final Function(String id) onDelete;
  final Function(User user) onUpdate;

  @override
  Widget build(BuildContext context) {
    return users.isEmpty
        ? NoContacts(
            onAdd: onAdd,
          )
        : ListView(
            children: [
              ...users
                  .map<Widget>(
                    (users) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child:
                              Text(users.name.characters.first.toUpperCase()),
                        ),
                        title: Text(
                          users.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                          users.email + " | " + users.phone,
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: [
                            FlatButton(
                              onPressed: () {
                                onUpdate(users);
                              },
                              child: const Icon(
                                Icons.edit,
                                size: 30,
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                onDelete(users.id);
                              },
                              child: const Icon(
                                Icons.delete,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 70),
            ],
          );
  }
}

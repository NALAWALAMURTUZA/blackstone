import 'package:core/model/user.dart';
import 'package:flutter/material.dart';

class UserDialog extends StatefulWidget {
  const UserDialog({
    @required this.onClickedDone,
    Key key,
    this.user,
  }) : super(key: key);

  final User user;
  final Function(User user) onClickedDone;

  @override
  _UserDialogState createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  User user;
  @override
  void initState() {
    super.initState();
    user = widget.user;
    user ??= User.empty();
    if (widget.user != null) {
      final transaction = widget.user;
      nameController.text = transaction.name;
      phoneController.text = transaction.phone;
      emailController.text = transaction.email;
      //isExpense = transaction.isExpense;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;
    final title = isEditing ? 'Edit Transaction' : 'Add Transaction';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              _buildName(),
              const SizedBox(height: 8),
              _buildEmail(),
              const SizedBox(height: 8),
              _buildPhone(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget _buildName() => TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter First Name',
        ),
        validator: (value) =>
            value != null && value.isEmpty ? 'Enter a first name' : null,
      );

  Widget _buildEmail() => TextFormField(
        controller: emailController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Email',
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) =>
            value != null && value.isEmpty ? 'Enter a email' : null,
      );

  Widget _buildPhone() => TextFormField(
        controller: phoneController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter phone',
        ),
        keyboardType: TextInputType.number,
        validator: (value) =>
            value != null && value.isEmpty ? 'Enter a phone' : null,
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {@required bool isEditing}) {
    final text = user.id != null ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState.validate();

        if (isValid) {
          User u = user.copyWith(
            name: nameController.text,
            email: emailController.text,
            phone: phoneController.text,
            id: user.id,
          );
          widget.onClickedDone(u);
          Navigator.of(context).pop();
        }
      },
    );
  }
}

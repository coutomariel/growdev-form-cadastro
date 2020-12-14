import 'package:flutter/material.dart';
import 'package:form_cadastro/model/user.dart';
import 'package:form_cadastro/routes/app_routes.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> _users = [];

  void _save(User user) {
    setState(() {
      _users.add(user);
    });
  }

  void _update(User user) {
    setState(() {
      print(user.id);
      _users[user.id - 1] = user;
    });
  }

  void _delete(int index) {
    setState(() {
      _users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listagem de usuários'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users.elementAt(index);
          return ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text('${user.nome}'),
            subtitle: Text('${user.email}'),
            trailing: IconButton(
              alignment: Alignment.topRight,
              icon: Icon(Icons.edit),
              color: Colors.red,
              onPressed: () {
                user.id = index + 1;
                Navigator.of(context).pushNamed(
                  AppRoutes.USER_FORM,
                  arguments: {'fn': _update, 'user': user},
                );
              },
            ),
            onLongPress: () => _delete(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.USER_FORM,
            arguments: {'fn': _save},
          );
        },
      ),
    );
  }
}

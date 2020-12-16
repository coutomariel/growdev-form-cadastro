import 'package:flutter/material.dart';
import 'package:form_cadastro/model/user.dart';
import 'package:form_cadastro/repositories/user.repository.dart';
import 'package:form_cadastro/routes/app_routes.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final UserRepository _repository = UserRepository();

  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() {
    _repository.getAllUsers().then((list) {
      setState(() {
        _users = list;
      });
    });
  }

  void _save(User user) async {
    final int id = await _repository.create(user);
    user.id = id;
    setState(() {
      _users.add(user);
    });
  }

  void _update(User user) async {
    await _repository.update(user);

    final index = _users.indexWhere((u) => u.id == user.id);
    setState(() {
      _users.replaceRange(index, index + 1, [user]);
    });
  }

  _delete(int id) async {
    await _repository.delete(id);
    setState(() {
      _users = _users.where((u) => u.id != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // _load();
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
            title: Text('${user.id} - ${user.nome}'),
            subtitle: Text('${user.email}'),
            trailing: IconButton(
              alignment: Alignment.topRight,
              icon: Icon(Icons.edit),
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.USER_FORM,
                  arguments: {'fn': _update, 'user': user},
                );
              },
            ),
            onLongPress: () => _delete(user.id),
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

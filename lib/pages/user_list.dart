import 'package:flutter/material.dart';
import 'package:form_cadastro/model/user.dart';
import 'package:form_cadastro/routes/app_routes.dart';

class UserList extends StatelessWidget {
  List<User> users;

  UserList(this.users);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listagem de usuários'),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users.elementAt(index);
            return ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text('${user.nome}'),
              subtitle: Text('${user.email}'),
              trailing: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.orange,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.USER_FORM);
        },
      ),
    );
  }
}

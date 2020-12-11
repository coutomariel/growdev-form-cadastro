import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:form_cadastro/pages/user_form.dart';
import 'package:form_cadastro/pages/user_list.dart';
import 'package:form_cadastro/routes/app_routes.dart';

import 'model/user.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final primaryColor = Colors.red;

  List<User> users = [];

  void cadastrar(User user) {
    print('${user.nome}');
    users.add(user);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        systemNavigationBarColor: primaryColor,
      ),
    );
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: primaryColor,
        ),
        home: UserList(users),
        routes: {
          AppRoutes.HOME: (_) => UserList(users),
          AppRoutes.USER_FORM: (_) => UserForm(cadastrar),
        },
      ),
    );
  }
}

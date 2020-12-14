import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:form_cadastro/pages/user_form.dart';
import 'package:form_cadastro/pages/user_list.dart';
import 'package:form_cadastro/routes/app_routes.dart';

import 'model/user.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final primaryColor = Colors.red;

  List<User> users = [];

  void _cadastrar(User user) {
    setState(() {
      users.add(user);
    });
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
        home: UserList(),
        routes: {
          // AppRoutes.HOME: (_) => UserList(users),
          AppRoutes.USER_FORM: (_) => UserForm(),
        },
      ),
    );
  }
}

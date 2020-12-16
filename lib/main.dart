import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:form_cadastro/pages/user_form.dart';
import 'package:form_cadastro/pages/user_list.dart';
import 'package:form_cadastro/routes/app_routes.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final primaryColor = Colors.red;

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
          AppRoutes.USER_FORM: (_) => UserForm(),
        },
      ),
    );
  }
}

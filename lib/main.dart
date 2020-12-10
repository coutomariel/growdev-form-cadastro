import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:email_validator/email_validator.dart';
import 'package:cnpj_cpf_helper/cnpj_cpf_helper.dart';
import 'package:form_cadastro/model/endereco.dart';

import 'model/user.dart';

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
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: primaryColor,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  var user = User();
  var endereco = Endereco();

  void showInformation() async {
    showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('Informações do usuário'),
        contentPadding: EdgeInsets.all(20),
        titlePadding: EdgeInsets.all(20),
        children: [
          Text('Nome: ${user.nome}'),
          Text('Email: ${user.email}'),
          Text('CPF: ${user.cpf}'),
          Text('CEP: ${endereco.cep}'),
          Text('Rua: ${endereco.rua} Número: ${endereco.numero}'),
          Text('Bairro: ${endereco.bairro} Cidade: ${endereco.cidade}'),
          Text('UF: ${endereco.uf} País: ${endereco.pais}'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Formulário de cadastro'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nome completo',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Campo não pode estar vazio';
                          }
                          return null;
                        },
                        onSaved: (newValue) => user.nome = newValue,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          var msg = '';

                          if (value.isEmpty) {
                            msg += '- Campo não pode ser vazio\n';
                          }

                          final emailInvalido = !EmailValidator.validate(value);
                          if (emailInvalido) {
                            msg += '- Email inválido';
                          }
                          if (msg.isEmpty) {
                            return null;
                          } else {
                            return msg;
                          }
                        },
                        onSaved: (newValue) => user.email = newValue,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CPF',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          var msg = '';

                          if (value.isEmpty) {
                            msg += '- Campo não pode ser vazio\n';
                          }
                          if (!CnpjCpfBase.isCpfValid(value)) {
                            msg += '- Cpf inválido';
                          }

                          if (msg.isEmpty) {
                            return null;
                          } else {
                            return msg;
                          }
                        },
                        onSaved: (newValue) => user.cpf = newValue,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 250,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'CEP',
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo não pode estar vazio';
                                }
                                return null;
                              },
                              onSaved: (newValue) => endereco.cep = newValue,
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(Icons.search),
                          Text('Buscar CEP')
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 280,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Rua',
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo não pode estar vazio';
                                }
                                return null;
                              },
                              onSaved: (newValue) => endereco.rua = newValue,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 105,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Número',
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo não pode estar vazio';
                                }
                                return null;
                              },
                              onSaved: (newValue) => endereco.numero = newValue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Bairro',
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo não pode estar vazio';
                                }
                                return null;
                              },
                              onSaved: (newValue) => endereco.numero = newValue,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 185,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Cidade',
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo não pode estar vazio';
                                }
                                return null;
                              },
                              onSaved: (newValue) => endereco.cidade = newValue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'UF',
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo não pode estar vazio';
                                }
                                return null;
                              },
                              onSaved: (newValue) => endereco.uf = newValue,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 185,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'País',
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo não pode estar vazio';
                                }
                                return null;
                              },
                              onSaved: (newValue) => endereco.pais = newValue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Builder(
              builder: (context) {
                return Container(
                  width: double.infinity,
                  child: OutlineButton(
                    child: Text('Cadastrar'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Formulário inválido',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }

                      _formKey.currentState.save();
                      this.showInformation();
                      print('Formulario válido');
                    },
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

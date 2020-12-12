import 'package:cnpj_cpf_helper/cnpj_cpf_helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:form_cadastro/model/endereco.dart';
import 'package:form_cadastro/model/user.dart';
import 'package:form_cadastro/routes/app_routes.dart';
import 'package:form_cadastro/service/cep.service.dart';

class UserForm extends StatefulWidget {
  final void Function(User) _cadastrar;

  UserForm(this._cadastrar);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cepCtrl = TextEditingController();
  final TextEditingController _ruaCtrl = TextEditingController();
  final TextEditingController _bairroCtrl = TextEditingController();
  final TextEditingController _cidadeCtrl = TextEditingController();
  final TextEditingController _ufCtrl = TextEditingController();
  final TextEditingController _paisCtrl = TextEditingController();

  var user = User();
  var endereco = Endereco();
  var _cepService = CepService();

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
                            width: MediaQuery.of(context).size.width * 0.5,
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
                              controller: _cepCtrl,
                              onSaved: (newValue) => endereco.cep = newValue,
                            ),
                          ),
                          SizedBox(width: 20),
                          IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () async {
                                final data = await _cepService
                                    .getEnderecoByCep(_cepCtrl.text);
                                _ruaCtrl.text = data['rua'];
                                _bairroCtrl.text = data['bairro'];
                                _cidadeCtrl.text = data['cidade'];
                                _ufCtrl.text = data['uf'];
                                _paisCtrl.text = data['pais'];
                              }),
                          Text('Buscar CEP')
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
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
                              controller: _ruaCtrl,
                              onSaved: (newValue) => endereco.rua = newValue,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.28,
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
                            width: MediaQuery.of(context).size.width * 0.46,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
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
                              controller: _bairroCtrl,
                              onSaved: (newValue) => endereco.bairro = newValue,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.46,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
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
                              controller: _cidadeCtrl,
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
                            width: MediaQuery.of(context).size.width * 0.46,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
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
                              controller: _ufCtrl,
                              onSaved: (newValue) => endereco.uf = newValue,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.46,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
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
                      widget._cadastrar(user);
                      Navigator.of(context).popAndPushNamed(AppRoutes.HOME);
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

import 'dart:io';

import 'package:cnpj_cpf_helper/cnpj_cpf_helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:form_cadastro/model/user.dart';
import 'package:form_cadastro/service/cep.service.dart';
import 'package:image_picker/image_picker.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = {};

  File file;

  final TextEditingController _cepCtrl = TextEditingController();
  final TextEditingController _ruaCtrl = TextEditingController();
  final TextEditingController _bairroCtrl = TextEditingController();
  final TextEditingController _cidadeCtrl = TextEditingController();
  final TextEditingController _ufCtrl = TextEditingController();
  final TextEditingController _paisCtrl = TextEditingController();

  String _validFieldNotEmpty(String value) {
    if (value.isEmpty) {
      return 'Campo não pode ser vazio.';
    }
    return null;
  }

  String _validEmail(String value) {
    final emailInvalido = !EmailValidator.validate(value);
    if (emailInvalido) {
      return '- Email inválido';
    }
    return null;
  }

  String _validCPF(String value) {
    if (!CnpjCpfBase.isCpfValid(value)) {
      return '- Cpf inválido';
    }
    return null;
  }

  Future<void> _loadAdress() async {
    final _cepService = CepService();
    final data = await _cepService.getAdressByCep(_cepCtrl.text);

    _ruaCtrl.text = data['rua'];
    _bairroCtrl.text = data['bairro'];
    _cidadeCtrl.text = data['cidade'];
    _ufCtrl.text = data['uf'];
    _paisCtrl.text = data['pais'];
  }

  void _loadUser(User user) {
    _formData['id'] = user.id;
    _formData['nome'] = user.nome;
    _formData['email'] = user.email;
    _formData['cpf'] = user.cpf;
    _cepCtrl.text = user.cep;
    _ruaCtrl.text = user.rua;
    _formData['numero'] = user.numero;
    _bairroCtrl.text = user.bairro;
    _cidadeCtrl.text = user.cidade;
    _ufCtrl.text = user.uf;
    _paisCtrl.text = user.pais;
    setState(() {
      file = user.image != null ? File(user.image) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Object> arguments = ModalRoute.of(context).settings.arguments;
    final void Function(User) _fn = arguments['fn'];
    final User _user = arguments['user'];
    if (_user != null) _loadUser(_user);

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
                  child: Container(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 90,
                          backgroundColor: Colors.red.withOpacity(.2),
                          child: GestureDetector(
                            onTap: () async {
                              var source = await showDialog<ImageSource>(
                                context: context,
                                barrierDismissible: false,
                                child: AlertDialog(
                                  title: Text('Escolha uma opção...'),
                                  actions: [
                                    FlatButton(
                                      child: Text('Galeria'),
                                      onPressed: () {
                                        Navigator.pop(
                                            context, ImageSource.gallery);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Camera'),
                                      onPressed: () {
                                        Navigator.pop(
                                            context, ImageSource.camera);
                                      },
                                    ),
                                  ],
                                ),
                              );
                              var picker = ImagePicker();
                              var pickedFile =
                                  await picker.getImage(source: source);
                              if (pickedFile != null) {
                                _formData['image'] = pickedFile.path;
                                setState(() {
                                  file = File(pickedFile.path);
                                  print(file);
                                });
                              }
                            },
                            child: Hero(
                              tag: _user?.id?.toString() ?? '',
                              child: CircleAvatar(
                              radius: 80,
                              backgroundImage: file != null
                                ? FileImage(file)
                                : AssetImage('assets/avatar.jpeg')
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nome completo',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          initialValue: _formData['nome'],
                          validator: (value) => _validFieldNotEmpty(value),
                          onSaved: (value) => _formData['nome'] = value,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          initialValue: _formData['email'],
                          validator: (value) => _validEmail(value),
                          onSaved: (value) => _formData['email'] = value,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'CPF',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          initialValue: _formData['cpf'],
                          validator: (value) => _validCPF(value),
                          onSaved: (value) => _formData['cpf'] = value,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'CEP',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: _formData['cep'],
                                controller: _cepCtrl,
                                validator: (value) =>
                                    _validFieldNotEmpty(value),
                                onSaved: (value) => _formData['cep'] = value,
                              ),
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () => _loadAdress(),
                            ),
                            Text('Buscar CEP')
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 7,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Rua',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: _formData['rua'],
                                validator: (value) =>
                                    _validFieldNotEmpty(value),
                                controller: _ruaCtrl,
                                onSaved: (value) => _formData['rua'] = value,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Número',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: _formData['numero'],
                                validator: (value) =>
                                    _validFieldNotEmpty(value),
                                onSaved: (value) => _formData['numero'] = value,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Bairro',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: _formData['bairro'],
                                validator: (value) =>
                                    _validFieldNotEmpty(value),
                                controller: _bairroCtrl,
                                onSaved: (value) => _formData['bairro'] = value,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Cidade',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: _formData['cidade'],
                                validator: (value) =>
                                    _validFieldNotEmpty(value),
                                controller: _cidadeCtrl,
                                onSaved: (value) => _formData['cidade'] = value,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'UF',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: _formData['uf'],
                                validator: (value) =>
                                    _validFieldNotEmpty(value),
                                controller: _ufCtrl,
                                onSaved: (value) => _formData['uf'] = value,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'País',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: _formData['pais'],
                                validator: (value) =>
                                    _validFieldNotEmpty(value),
                                controller: _paisCtrl,
                                onSaved: (value) => _formData['pais'] = value,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                      _fn(User.fromJson(_formData));
                      Navigator.of(context).pop();
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

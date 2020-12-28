import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String _text;
  final double _size;

  InputText(this._text, this._size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      margin: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: _text,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 5.0,
            ),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo não pode ser vazio!';
          }
          return null;
        },
      ),
    );
  }
}

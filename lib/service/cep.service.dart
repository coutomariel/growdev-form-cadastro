import 'package:dio/dio.dart';

class CepService {
  final _dio = Dio(BaseOptions(baseUrl: 'https://viacep.com.br/ws'));

  Future<Map<String, String>> getAdressByCep(String cep) async {
    var json;
    try {
      json = await _dio.get('/$cep/json');
    } catch (e) {}
    final endereco = json.data;
    return {
      'rua': '${endereco['logradouro']}',
      'bairro': '${endereco['bairro']}',
      'cidade': '${endereco['localidade']}',
      'uf': '${endereco['uf']}',
      'pais': 'Brasil',
    };
  }
}

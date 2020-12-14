class User {
  int id;
  String nome;
  String email;
  String cpf;
  String cep;
  String rua;
  String numero;
  String bairro;
  String cidade;
  String uf;
  String pais;

  User({
    this.nome,
    this.email,
    this.cpf,
    this.cep,
    this.rua,
    this.numero,
    this.bairro,
    this.cidade,
    this.uf,
    this.pais,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    cpf = json['cpf'];
    cep = json['cep'];
    rua = json['rua'];
    numero = json['numero'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    uf = json['uf'];
    pais = json['pais'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['cpf'] = this.cpf;
    data['cep'] = this.cep;
    data['rua'] = this.rua;
    data['numero'] = this.numero;
    data['bairro'] = this.bairro;
    data['cidade'] = this.cidade;
    data['uf'] = this.uf;
    data['pais'] = this.pais;
    return data;
  }
}

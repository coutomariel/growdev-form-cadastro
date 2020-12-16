const String DATABASE_NAME = 'users.db';
const String TABLE_USER = 'user';

const String CREATE_USER_TABLE_SCRIPT = '''
  CREATE TABLE user(
    id INTEGER PRIMARY KEY,
    nome TEXT,
    email TEXT,
    cpf TEXT,
    cep TEXT,
    rua TEXT,
    numero TEXT,
    bairro TEXT,
    cidade TEXT,
    uf TEXT,
    pais TEXT
  );
  ''';

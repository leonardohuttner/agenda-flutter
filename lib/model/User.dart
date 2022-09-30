import 'dart:convert';

class UsuarioPropriedades {
  static String id = "id";
  static String nome = "nome";
  static String senha = "senha";
  static String telefone = "telefone";
  static String email = "email";
  static String imagem = "imagem";
}

class User {
  int id = 0;
  String nome = "";
  String senha = "";
  String telefone = "";
  String email = "";
  String imagem = "";
  User();

  Map<String, Object> toMap() {
    Map<String, Object> map = {
      UsuarioPropriedades.nome: nome,
      UsuarioPropriedades.senha: senha,
      UsuarioPropriedades.telefone: telefone,
      UsuarioPropriedades.email: email,
      UsuarioPropriedades.imagem: imagem
    };
    if (id > 0) {
      map["id"] = id;
    }
    return map;
  }

  User.fromMap(Map map) {
    id = map['id'];
    nome = map['nome'];
    senha = map['senha'];
    telefone = map['telefone'];
    email = map['email'];
    imagem = map['imagem'];
  }

  @override
  String toString() {
    return 'User{id: $id, '
        'nome: $nome,'
        'senha: $senha,'
        'telefone: $telefone,'
        'email: $email,'
        'imagem: $imagem}';
  }

  String? geraJson() {
    String dados = json.encode(this);
    return dados;
  }
}

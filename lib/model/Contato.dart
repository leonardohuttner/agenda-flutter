import 'dart:convert';

class ContatoPropriedades {
  static String id = "id";
  static String nome = "nome";
  static String telefone = "telefone";
  static String imagem = "imagem";
}

class Contato {
  int id = 0;
  String nome = "";
  String telefone = "";
  String imagem = "";
  Contato();

  Map<String, Object> toMap() {
    Map<String, Object> map = {
      ContatoPropriedades.nome: nome,
      ContatoPropriedades.telefone: telefone,
      ContatoPropriedades.imagem: imagem
    };
    if (id > 0) {
      map["id"] = id;
    }
    return map;
  }

  Contato.fromMap(Map map) {
    id = map['id'];
    nome = map['nome'];
    telefone = map['telefone'];
    imagem = map['imagem'];
  }

  @override
  String toString() {
    return 'Contato{id: $id, '
        'nome: $nome,'
        'telefone: $telefone,'
        'imagem: $imagem}';
  }

  String? geraJson() {
    String dados = json.encode(this);
    return dados;
  }
}

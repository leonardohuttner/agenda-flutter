import 'dart:ffi';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/User.dart';

class UsuarioHelper {
  static final UsuarioHelper _instance = UsuarioHelper._interno();
  factory UsuarioHelper() => _instance;

  UsuarioHelper._interno();

  Database? _banco;

  Future<Database> get banco async {
    if (_banco != null) {
      return _banco!;
    } else {
      _banco = await iniciarBanco();
      return _banco!;
    }
  }

  String tabela_usuario = 'usuario';

  Future<Database> iniciarBanco() async {
    final caminhoBanco = await getDatabasesPath();

    final caminho = join(caminhoBanco, 'usuarios.db');

    const versao = 6;

    String sqlCriarBanco = "create table $tabela_usuario ("
        "${UsuarioPropriedades.id} integer primary key autoincrement, ${UsuarioPropriedades.senha} text,${UsuarioPropriedades.nome} text, ${UsuarioPropriedades.telefone} text, ${UsuarioPropriedades.email} text, ${UsuarioPropriedades.imagem} text);";

    String destruirBanco = "drop table $tabela_usuario;";

    return openDatabase(caminho, version: versao,
        onCreate: (banco, versaoNova) async {
      print("criando banco com $versaoNova");
      await banco.execute(sqlCriarBanco);
    }, onUpgrade: (banco, versaoAntiga, versaoNova) async {
      print("criando banco com $versaoNova");
      await banco.execute(destruirBanco);
      await banco.execute(sqlCriarBanco);
    });
  }

  Future<User> create(User usuario) async {
    Database bancoUsuario = await banco;
    usuario.id = await bancoUsuario.insert(tabela_usuario, usuario.toMap());
    return usuario;
  }

  Future<User> getById(int id) async {
    Database bancoUsuario = await banco;
    List<Map> retorno = await bancoUsuario.query(tabela_usuario,
        columns: [
          UsuarioPropriedades.id,
          UsuarioPropriedades.nome,
          UsuarioPropriedades.email,
          UsuarioPropriedades.telefone,
          UsuarioPropriedades.imagem
        ],
        where: "${UsuarioPropriedades.id} = ?",
        whereArgs: [id]);
    if (retorno.isNotEmpty) {
      return User.fromMap(retorno.first);
    } else {
      return null!;
    }
  }

  Future<List<User>> getAll() async {
    Database bancoUsuario = await banco;
    List<Map> retorno =
        await bancoUsuario.rawQuery("SELECT * FROM $tabela_usuario");
    List<User> usuarios = [];
    for (Map usuario in retorno) {
      usuarios.add(User.fromMap(usuario));
    }
    return usuarios;
  }

  Future<User> login(String usuario, senha) async {
    Database bancoUsuario = await banco;
    List<Map> response = await bancoUsuario.query(tabela_usuario,
        where: "${UsuarioPropriedades.nome} = ?"
            "AND "
            "${UsuarioPropriedades.senha} = ?",
        whereArgs: [usuario, senha]);
    if (response.isNotEmpty) {
      return User.fromMap(response.first);
    }
    return User();
  }

  Future<int> remover(int id) async {
    Database bancoUsuario = await banco;
    List<Map> retorno = await bancoUsuario
        .rawQuery("DELETE * FROM $tabela_usuario WHERE id = $id");
    print(retorno);
    return 1;
  }
}

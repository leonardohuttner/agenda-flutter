import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/Contato.dart';

class ContatoHelper {
  static final ContatoHelper _instance = ContatoHelper._interno();
  factory ContatoHelper() => _instance;

  ContatoHelper._interno();

  Database? _banco;

  Future<Database> get banco async {
    if (_banco != null) {
      return _banco!;
    } else {
      _banco = await iniciarBanco();
      return _banco!;
    }
  }

  String tabela_contato = 'usuario';

  Future<Database> iniciarBanco() async {
    final caminhoBanco = await getDatabasesPath();

    final caminho = join(caminhoBanco, 'contato.db');

    const versao = 1;

    String sqlCriarBanco = "create table $tabela_contato ("
        "${ContatoPropriedades.id} integer primary key autoincrement, ${ContatoPropriedades.nome} text, ${ContatoPropriedades.telefone} text, ${ContatoPropriedades.imagem} text);";

    String destruirBanco = "drop table $tabela_contato;";

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

  Future<Contato> create(Contato contato) async {
    Database bancoContato = await banco;
    contato.id = await bancoContato.insert(tabela_contato, contato.toMap());
    return contato;
  }

  Future<Contato> getById(int id) async {
    Database bancoContato = await banco;
    List<Map> retorno = await bancoContato.query(tabela_contato,
        columns: [
          ContatoPropriedades.id,
          ContatoPropriedades.nome,
          ContatoPropriedades.telefone,
          ContatoPropriedades.imagem
        ],
        where: "${ContatoPropriedades.id} = ?",
        whereArgs: [id]);
    if (retorno.isNotEmpty) {
      return Contato.fromMap(retorno.first);
    } else {
      return null!;
    }
  }

  Future<List<Contato>> getAll() async {
    Database bancoContato = await banco;
    List<Map> retorno =
        await bancoContato.rawQuery("SELECT * FROM $tabela_contato");
    List<Contato> contatos = [];
    for (Map contato in retorno) {
      contatos.add(Contato.fromMap(contato));
    }
    return contatos;
  }

  Future<int> remover(int id) async {
    Database bancoContato = await banco;
    List<Map> retorno = await bancoContato
        .rawQuery("DELETE FROM $tabela_contato WHERE id = $id");
    print(retorno);
    return 1;
  }

  update(Contato contato) async {
    try {
      Database bancoContato = await banco;
      await bancoContato.update('usuario', contato.toMap(),
          where: "id = ?", whereArgs: [contato.id]);
      print('Contato alterado: ' + contato.nome);
    } catch (ex) {
      print(ex);
      return;
    }
  }

  delete(int id) async {
    try {
      Database bancoContato = await banco;
      await bancoContato.delete('contato', where: "id = ?", whereArgs: [id]);
      print('Contato deletado: ' + id.toString());
    } on Exception catch (_) {
      print("Erro ao deletar id: "[id]);
      throw Exception("Erro ao deletar id: "[id]);
    }
  }
}

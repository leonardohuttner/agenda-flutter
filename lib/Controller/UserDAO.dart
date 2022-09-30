import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agenda/model/User.dart';
import 'package:agenda/Controller/UserHelper.dart';
import 'package:path_provider/path_provider.dart';

class UserDAO {
  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/usuarios.json").create(recursive: true);
  }

  Future insert(User usuario) async {
    List<User> listaUsuarios = await lerUsuario();
    listaUsuarios.add(usuario);

    await gravarUsuarios(listaUsuarios);
  }

  Future<List<User>> lerUsuario() async {
    List<User> listaUsuariosArquivo = [];

    String listaComoString = '';

    try {
      final arquivo = await _getFile();
      listaComoString = await arquivo.readAsString();
    } catch (e) {
      // ignore: avoid_print
      print("Erro na leitura $e");
    }

    List mapUsuarios = [];
    if (listaComoString.isNotEmpty) {
      mapUsuarios = json.decode(listaComoString);
    }

    for (Map usuarioMap in mapUsuarios) {
      listaUsuariosArquivo.add(User.fromMap(usuarioMap));
    }
    return listaUsuariosArquivo;
  }

  Future gravarUsuarios(List<User> usuarios) async {
    List mapUsuarios = [];
    for (User usuario in usuarios) {
      mapUsuarios.add(usuario.toMap());
    }

    String listaComoString = json.encode(mapUsuarios);
    final arquivo = await _getFile();

    await arquivo.writeAsString(listaComoString);
  }

  Future removerJogador(int indice) async {
    List<User> listaUsuarios = await lerUsuario();

    listaUsuarios.removeAt(indice);

    await gravarUsuarios(listaUsuarios);
  }

  Future editar(int indice, User usuarioAtualizar) async {
    List<User> listaUsuarios = await lerUsuario();

    listaUsuarios[indice] = usuarioAtualizar;

    await gravarUsuarios(listaUsuarios);
  }
}

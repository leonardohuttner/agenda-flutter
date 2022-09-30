// import 'package:agenda/Controller/UserDAO.dart';
import 'package:agenda/model/User.dart';
import 'package:agenda/view/EditUser.dart';
import 'package:flutter/material.dart';
import 'package:agenda/Controller/UserHelper.dart';

class AdmUser extends StatefulWidget {
  const AdmUser({Key? key}) : super(key: key);

  @override
  State<AdmUser> createState() => _AdmUserState();
}

class _AdmUserState extends State<AdmUser> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // UserDAO serviceUser = UserDAO();
  UsuarioHelper serviceUserBD = UsuarioHelper();
  User usuario = User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barraSuperior(),
      body: corpo(),
    );
  }

  barraSuperior() {
    return AppBar(
      title: Text("Cadastrar novo Usuario"),
    );
  }

  corpo() {
    return Column(
      children: [cardFormulario(), listaUsuarios()],
    );
  }

  cardFormulario() {
    return Card(
      margin: EdgeInsets.all(15),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              campoDados(_usuarioController, "Usuário",
                  "Informe o nome de usuário", Icons.person_add, false),
              campoDados(_senhaController, "Senha", "Informe uma senha",
                  Icons.key, true),
              botaoCadastrar()
            ],
          )),
    );
  }

  botaoCadastrar() {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 5),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add),
        label: Text("Cadastrar"),
        onPressed: () {
          User usuario = User();

          usuario.nome = _usuarioController.text;
          usuario.senha = _senhaController.text;
          usuario.email = "";
          usuario.imagem = "";
          usuario.telefone = "";

          serviceUserBD.create(usuario);
          //serviceUser.insert(usuario);

          setState(() {
            _usuarioController.clear();
            _senhaController.clear();
          });
        },
      ),
    );
  }

  listaUsuarios() {
    return Expanded(
        child: Card(
      margin: const EdgeInsets.all(15),
      child: FutureBuilder<List<User>>(
          future: carregarListaUsuarios(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return montarListaUsuarios(snapshot.data!);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    ));
  }

  montarListaUsuarios(List<User> usuarios) {
    return ListView.builder(
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        return itemDaLista(usuarios[index], index);
      },
    );
  }

  itemDaLista(User usuario, int indice) {
    return ListTile(
        leading: Icon(Icons.person),
        title: Text(
          usuario.nome,
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Text(usuario.email),
        trailing: Wrap(
          spacing: 2,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.restore_from_trash, color: Colors.red),
              onPressed: () {
                setState(() {
                  serviceUserBD.remover(usuario.id);
                  print(indice);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit,
                  color: Color.fromARGB(255, 54, 244, 63)),
              onPressed: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => EditUser(
                                usuario: usuario,
                                index: indice,
                              )));
                });
              },
            ),
          ],
        ));
  }

  Future<List<User>> carregarListaUsuarios() async {
    List<User> lista = [];

    lista = await serviceUserBD.getAll();

    return lista;
  }

  campoDados(TextEditingController controller, String label, String hint,
      IconData icone, bool isSenha) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: TextFormField(
        style: TextStyle(color: Colors.green[900]),
        controller: controller,
        obscureText: isSenha,
        decoration: InputDecoration(
          icon: Icon(
            icone,
            color: Colors.grey,
          ),
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
        ),
        validator: (String? value) {
          return (value == null || value.isEmpty) ? 'Campo obrigatório' : null;
        },
      ),
    );
  }
}

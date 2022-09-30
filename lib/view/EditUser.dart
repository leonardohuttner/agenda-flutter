import 'package:agenda/Controller/UserDAO.dart';
import 'package:agenda/model/User.dart';
import 'package:flutter/material.dart';
import 'package:agenda/view/AdmUser.dart';

class EditUser extends StatefulWidget {
  final User usuario;
  final int index;
  EditUser({Key? key, required this.usuario, required this.index})
      : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  UserDAO serviceUser = UserDAO();

  @override
  void initState() {
    super.initState;
    final _usuarioTemporario = widget.usuario;
    _usuarioController.text = _usuarioTemporario.nome;
    _senhaController.text = _usuarioTemporario.senha;
    _emailController.text = _usuarioTemporario.email;
    _telefoneController.text = _usuarioTemporario.telefone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barraSuperior(),
      body: corpo(),
    );
  }

  barraSuperior() {
    return AppBar(
      title: Text("Editar Usuario"),
    );
  }

  corpo() {
    return SingleChildScrollView(
      child: Column(
        children: [cardFormulario()],
      ),
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
                  Icons.key, false),
              campoDados(_telefoneController, "Telefone", "Informe um telefone",
                  Icons.phone, false),
              campoDados(_emailController, "Email", "Informe um email",
                  Icons.mail, false),
              botaoAtualizar()
            ],
          )),
    );
  }

  botaoAtualizar() {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 5),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add),
        label: Text("Atualizar"),
        onPressed: () {
          User usuario = User();

          usuario.nome = _usuarioController.text;
          usuario.senha = _senhaController.text;
          usuario.telefone = _telefoneController.text;
          usuario.email = _emailController.text;

          serviceUser.editar(widget.index, usuario);
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => AdmUser()));
        },
      ),
    );
  }

  campoDados(TextEditingController controller, String label, String hint,
      IconData icone, bool isSenha) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: TextFormField(
        style: TextStyle(color: Colors.green[900]),
        controller: controller,
        obscureText: isSenha,
        // initialValue: defaultText,
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

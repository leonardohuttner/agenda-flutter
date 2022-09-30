import 'package:agenda/Controller/UserHelper.dart';
import 'package:agenda/model/Contato.dart';
import 'package:agenda/model/User.dart';
import 'package:flutter/material.dart';
import 'package:agenda/cadastro.dart';
import 'package:agenda/view/AdmUser.dart';
import 'package:agenda/view/ListaContato.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //UserDAO serviceUser = UserDAO();
  UsuarioHelper serviceUserBD = UsuarioHelper();
  GlobalKey<FormState> _chaveForm = GlobalKey<FormState>();
  TextEditingController _userController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  campoDeTexto(TextEditingController controller, String label) {
    return Container(
        padding: EdgeInsets.all(8),
        height: 70,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.purple, fontSize: 20),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.purple, fontSize: 20),
          ),
          validator: (texto) {
            if (texto!.isEmpty) {
              return "Campo obrigatório!";
            }
          },
        ));
  }

  Widget build(BuildContext context) {
    User usuario;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _chaveForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.all(50)),
              campoDeTexto(_userController, "Login"),
              const Divider(),
              campoDeTexto(_senhaController, "Senha"),
              const Divider(),
              ButtonTheme(
                height: 50.0,
                child: ElevatedButton(
                  child: const Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () async {
                    if (_chaveForm.currentState!.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ListaContatosPage()));
                      //   usuario = await serviceUserBD.login(
                      //       _userController.text, _senhaController.text);
                      //   print(usuario);
                      // } else {
                      //   print("Campo obrigatorio");
                    }
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 20.0,
                height: 10.0,
                child: ElevatedButton(
                  child: const Text(
                    "Cadastre-se",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => SignIn()))
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.yellow, // foreground
                  ),
                ),
              ),
              ButtonTheme(
                minWidth: 20.0,
                height: 10.0,
                child: ElevatedButton(
                  child: const Text(
                    "ADMINISTRADOR",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => AdmUser()))
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.yellow, // foreground
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:agenda/model/User.dart';
import 'package:flutter/material.dart';
import 'package:agenda/login.dart';
import 'package:agenda/Controller/UserHelper.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  UsuarioHelper serviceUser = UsuarioHelper();
  User usuario = User();
  GlobalKey<FormState> _chaveForm = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  campoDeTexto(
      TextEditingController controller, String label, TextInputType name,
      {bool pass = false}) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      style: const TextStyle(color: Colors.purple, fontSize: 20),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.purple, fontSize: 20),
      ),
      keyboardType: name,
      obscureText: pass,
      validator: (texto) {
        if (texto!.isEmpty) {
          return "Campo obrigatório!";
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _chaveForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.all(25)),
              campoDeTexto(_nomeController, "Nome", TextInputType.text),
              const Divider(),
              campoDeTexto(_senhaController, "Senha", TextInputType.text,
                  pass: true),
              const Divider(),
              campoDeTexto(
                  _telefoneController, "Telefone", TextInputType.number),
              const Divider(),
              campoDeTexto(
                  _emailController, "Email", TextInputType.emailAddress),
              const Divider(),
              ButtonTheme(
                height: 60.0,
                child: ElevatedButton(
                  child: const Text(
                    "Cadastrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => {
                    if (_chaveForm.currentState!.validate())
                      {
                        usuario.nome = _nomeController.text,
                        usuario.senha = _senhaController.text,
                        usuario.telefone = _telefoneController.text,
                        usuario.email = _emailController.text,
                        serviceUser.create(usuario).then((value) => {
                              if (true)
                                {
                                  Navigator.pop(context),
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => Login()))
                                }
                              else
                                {print('erro- if')}
                            })
                      }
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

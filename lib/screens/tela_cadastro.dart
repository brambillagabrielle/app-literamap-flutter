import '../firebase_functions.dart';
import 'package:flutter/material.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<StatefulWidget> createState() => _TelaCadastroState();
}

TextEditingController emailController = TextEditingController();
TextEditingController senhaController = TextEditingController();

class _TelaCadastroState extends State<TelaCadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar-se")),
      body: Form(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "E-mail",
                      hintText: "email@dominio.com",
                    ),
                  ),
                  TextFormField(
                    controller: senhaController,
                    decoration: const InputDecoration(
                      labelText: "Senha",
                      hintText: "********",
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        createUserWithEmailAndPassword(emailController.text,
                            senhaController.text, context);
                      },
                      child: const Text("Cadastrar"))
                ],
              ))),
    );
  }
}

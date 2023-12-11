import '../firebase/firebase_functions.dart';
import 'package:flutter/material.dart';

class TelaAutenticacao extends StatefulWidget {
  const TelaAutenticacao({super.key});

  @override
  State<StatefulWidget> createState() => _TelaAutenticacaoState();
}

TextEditingController emailController = TextEditingController();
TextEditingController senhaController = TextEditingController();

class _TelaAutenticacaoState extends State<TelaAutenticacao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Entrar")),
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
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Senha",
                        hintText: "********",
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          signInWithEmailAndPassword(emailController.text,
                              senhaController.text, context);
                        },
                        child: const Text("Entrar"))
                  ],
                ))));
  }
}

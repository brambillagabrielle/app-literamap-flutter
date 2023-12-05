import '../firebase_functions.dart';
import 'package:flutter/material.dart';

class TelaHome extends StatefulWidget {
  const TelaHome({super.key});

  @override
  State<StatefulWidget> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Home")),
        body: Form(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                        "Home Screen (menu com livros registrados, mapa pessoal e mapa global)"),
                    ElevatedButton(
                        onPressed: () {
                          signOut(context);
                        },
                        child: const Text("Sair"))
                  ],
                ))));
  }
}

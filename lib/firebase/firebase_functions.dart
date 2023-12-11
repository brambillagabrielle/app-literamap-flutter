import '../menu.dart';
import '../telas/tela_autenticacao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../telas/tela_inicial.dart';

createUserWithEmailAndPassword(
    String emailAddress, String password, BuildContext context) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    User? user = credential.user;
    if (user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TelaAutenticacao()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Registrado com sucesso"),
        backgroundColor: Colors.green,
      ));
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("A senha informada é muito fraca"),
        backgroundColor: Colors.red,
      ));
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("A conta com o e-mail informado já existe"),
        backgroundColor: Colors.red,
      ));
    }
  } catch (e) {
    print(e);
  }
}

signInWithEmailAndPassword(
    String emailAddress, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);

    User? user = credential.user;
    if (user != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Menu()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Autenticado com sucesso"),
        backgroundColor: Colors.green,
      ));
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Nenhum usuário encontrado com o e-mail informado"),
        backgroundColor: Colors.red,
      ));
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Senha informada está incorreta"),
        backgroundColor: Colors.red,
      ));
    }
  }
}

signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const TelaInicial()));
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text("Deslogado com sucesso"),
    backgroundColor: Colors.green,
  ));
}

import 'package:flutter/material.dart';

class TelaLivros extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TelaLivrosState();
  }
}

class TelaLivrosState extends State<TelaLivros> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Livros"),
    ));
  }
}

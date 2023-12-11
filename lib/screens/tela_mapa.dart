import 'package:flutter/material.dart';

class TelaMapa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TelaMapaState();
  }
}

class TelaMapaState extends State<TelaMapa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Mapa"),
    ));
  }
}

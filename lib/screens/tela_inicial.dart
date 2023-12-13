import 'auth/tela_cadastro.dart';
import 'auth/tela_autenticacao.dart';
import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LiteraMap")),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://firebasestorage.googleapis.com/v0/b/app-literamap.appspot.com/o/logo.png?alt=media&token=b20fa266-629c-4dc0-96e8-4e374d9ff5ea',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaAutenticacao(),
                  ),
                );
              },
              child: const Text("Entrar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaCadastro(),
                  ),
                );
              },
              child: const Text("Cadastrar-se"),
            ),
          ],
        ),
      ),
    );
  }
}

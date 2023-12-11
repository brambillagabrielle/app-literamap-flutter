import 'screens/tela_livros.dart';
import 'screens/tela_mapa.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu> {
  int paginaAtual = 0;
  PageController? pc;

  @override
  Widget build(Object context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [TelaLivros(), TelaMapa()],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Livros"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa")
        ],
        onTap: (pagina) {
          pc?.animateToPage(pagina,
              duration: Duration(microseconds: 400), curve: Curves.ease);
        },
      ),
    );
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }
}

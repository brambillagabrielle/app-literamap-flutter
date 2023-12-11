import 'screens/tela_inicial.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: const TelaInicial(),
    theme: ThemeData(
      colorScheme: const ColorScheme.light(primary: Color(0xFFed5f72)),
      focusColor: const Color(0xFFed5f72),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
          titleMedium: TextStyle(fontSize: 32),
          labelMedium: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 16)),
      appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1e3f48),
          centerTitle: true,
          titleTextStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFed5f72),
        // Adicione a propriedade style para personalizar o estilo do texto
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFe5dad8),
          selectedItemColor: Color(0xFFed5f72),
          unselectedItemColor: Color(0xFF1e3f48)),
    ),
  ));
}

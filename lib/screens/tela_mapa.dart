import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding_resolver/geocoding_resolver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<StatefulWidget> createState() {
    return TelaMapaState();
  }
}

class TelaMapaState extends State<TelaMapa> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final CollectionReference _livros =
      FirebaseFirestore.instance.collection("livros");

  GeoCoder geoCoder = GeoCoder();

  final Set<Marker> _marcadores = {};

  static CameraPosition _posicaoCamera = const CameraPosition(
    target: LatLng(-14.2400732, -53.1805017),
    zoom: 10,
  );

  final GoogleSignIn googleSignIn = GoogleSignIn();
  User? _currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa"),
      ),
      body: GoogleMap(
          initialCameraPosition: _posicaoCamera,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            User? user = await _getUser(context: context);
            _currentUser = user;

            if (_currentUser != null) {
              _getLivrosRegistrados();
            }
          },
          markers: _marcadores,
          onLongPress: _adicionarMarcadorLivro),
    );
  }

  _adicionarMarcadorLivro(LatLng latLng) async {
    final TextEditingController controladorTitulo = TextEditingController();
    final TextEditingController controladorAutor = TextEditingController();
    final TextEditingController controladorAno = TextEditingController();

    final formKey = GlobalKey<FormState>();

    Map<String, dynamic> livro = {};

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Adicionar novo livro'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        controller: controladorTitulo,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          icon: Icon(Icons.title_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o título';
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: controladorAutor,
                        decoration: const InputDecoration(
                          labelText: 'Autor',
                          icon: Icon(Icons.person_2_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o autor';
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: controladorAno,
                        decoration: const InputDecoration(
                          labelText: 'Ano',
                          icon: Icon(Icons.calendar_today_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o ano';
                          }
                          return null;
                        }),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  child: const Text("Adicionar"),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      String id = "";

                      if (_currentUser != null) {
                        livro['titulo'] = controladorTitulo.text;
                        livro['autor'] = controladorAutor.text;
                        livro['ano'] = controladorAno.text;
                        livro['usuario'] = _currentUser?.uid;
                        livro['latitude'] = latLng.latitude;
                        livro['longitude'] = latLng.longitude;
                        _livros.add(livro).then(
                            (documentSnapshot) => id = documentSnapshot.id);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Login é necessário para que o livro seja registrado"),
                          backgroundColor: Colors.red,
                        ));
                      }

                      Marker marcador = Marker(
                          markerId: MarkerId(
                              "marcador-${latLng.latitude}-${latLng.longitude}"),
                          position: latLng,
                          infoWindow: InfoWindow(
                              title:
                                  '${controladorTitulo.text} (${controladorAno.text})',
                              snippet: 'Autor: ${controladorAutor.text}'),
                          onTap: () {
                            if (_currentUser != null) {
                              _editarMarcadorLivro(id);
                            }
                          });

                      setState(() {
                        _marcadores.add(marcador);
                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Livro adicionado!"),
                        backgroundColor: Colors.green,
                      ));
                    }
                  })
            ],
          );
        });
  }

  _editarMarcadorLivro(String id) async {
    final TextEditingController controladorTitulo = TextEditingController();
    final TextEditingController controladorAutor = TextEditingController();
    final TextEditingController controladorAno = TextEditingController();
    LatLng latLng = const LatLng(0, 0);

    final docRef = _livros.doc(id);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      controladorTitulo.text = data['titulo'];
      controladorAutor.text = data['autor'];
      controladorAno.text = data['ano'];
      latLng = LatLng(data['latitude'], data['longitude']);
    });

    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Alterar livro'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        controller: controladorTitulo,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          icon: Icon(Icons.title_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o título';
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: controladorAutor,
                        decoration: const InputDecoration(
                          labelText: 'Autor',
                          icon: Icon(Icons.person_2_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o autor';
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: controladorAno,
                        decoration: const InputDecoration(
                          labelText: 'Ano',
                          icon: Icon(Icons.calendar_today_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o ano';
                          }
                          return null;
                        }),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  child: const Text("Salvar"),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      docRef.update({
                        'titulo': controladorTitulo.text,
                        'autor': controladorAutor.text,
                        'ano': controladorAno.text
                      });

                      Marker marcador = Marker(
                          markerId: MarkerId(
                              "marcador-${latLng.latitude}-${latLng.longitude}"),
                          position: latLng,
                          infoWindow: InfoWindow(
                              title:
                                  '${controladorTitulo.text} (${controladorAno.text})',
                              snippet: 'Autor: ${controladorAutor.text}'),
                          onTap: () {
                            _editarMarcadorLivro(id);
                          });

                      setState(() {
                        _marcadores.removeWhere((element) =>
                            element.markerId.toString() ==
                            "marcador-${latLng.latitude}-${latLng.longitude}");

                        _marcadores.add(marcador);
                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Registro do livro foi alterado!"),
                        backgroundColor: Colors.green,
                      ));
                    }
                  }),
              ElevatedButton(
                child: const Text("Excluir"),
                onPressed: () {
                  _livros.doc(id).delete();

                  Navigator.pop(context);

                  setState(() {
                    _marcadores.removeWhere((element) =>
                        element.markerId.toString() ==
                        "marcador-${latLng.latitude}-${latLng.longitude}");
                  });

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('O livro/marcador foi excluído!'),
                      backgroundColor: Colors.green));
                },
              )
            ],
          );
        });
  }

  _getLivrosRegistrados() async {
    _livros.get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        if (data['usuario'] == _currentUser?.uid) {
          String titulo = data['titulo'];
          String autor = data['autor'];
          String ano = data['ano'];
          LatLng latLng = LatLng(data['latitude'], data['longitude']);
          Marker marcador = Marker(
              markerId:
                  MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
              position: latLng,
              infoWindow:
                  InfoWindow(title: '$titulo ($ano)', snippet: 'Autor: $autor'),
              onTap: () {
                _editarMarcadorLivro(docSnapshot.id);
              });
          setState(() {
            _marcadores.add(marcador);
          });
        }
      }
    });
  }

  _movimentarCamera() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  Future<User?> _getUser({required BuildContext context}) async {
    User? user;
    if (_currentUser != null) return _currentUser;
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);
        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);
          user = userCredential.user;
        } catch (e) {
          print(e);
        }
      }
    }
    return user;
  }

  @override
  void initState() {
    super.initState();
  }
}

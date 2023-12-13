import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding_resolver/geocoding_resolver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class TelaMapa extends StatefulWidget {
  String? idLocal;
  TelaMapa({super.key, this.idLocal});

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

  bool editando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa"),
      ),
      body: GoogleMap(
          initialCameraPosition: _posicaoCamera,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _getLivrosRegistrados();
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
                          labelText: 'Ano de publicação',
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

                      livro['titulo'] = controladorTitulo.text;
                      livro['autor'] = controladorAutor.text;
                      livro['ano'] = controladorAno.text;
                      livro['latitude'] = latLng.latitude;
                      livro['longitude'] = latLng.longitude;
                      _livros
                          .add(livro)
                          .then((documentSnapshot) => id = documentSnapshot.id);

                      Marker marcador = Marker(
                          markerId: MarkerId(
                              "marcador-${latLng.latitude}-${latLng.longitude}"),
                          position: latLng,
                          infoWindow: InfoWindow(
                              title:
                                  '${controladorTitulo.text} (${controladorAno.text})',
                              snippet: 'Por: ${controladorAutor.text}}'),
                          onTap: () {
                            editando = true;
                            _editarMarcadorLivro(id);
                            editando = false;
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
                          labelText: 'Ano de publicação',
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
                              snippet: 'Por: ${controladorAutor.text}}'),
                          onTap: () {
                            editando = true;
                            _editarMarcadorLivro(id);
                            editando = false;
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

                  setState(() {
                    _marcadores.removeWhere((element) =>
                        element.markerId.toString() ==
                        "marcador-${latLng.latitude}-${latLng.longitude}");
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('O livro/marcador foi excluído!'),
                      backgroundColor: Colors.red));
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
        String titulo = data['titulo'];
        String autor = data['autor'];
        String ano = data['ano'];
        LatLng latLng = LatLng(data['latitude'], data['longitude']);
        Marker marcador = Marker(
            markerId:
                MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
            position: latLng,
            infoWindow:
                InfoWindow(title: '$titulo ($ano)', snippet: 'Por: $autor'),
            onTap: () {
              editando = true;
              _editarMarcadorLivro(docSnapshot.id);
              editando = false;
            });
        setState(() {
          _marcadores.add(marcador);
        });
      }
    });
  }

  _movimentarCamera() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _getLocalizacaoUsuario() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      permission = await Geolocator.checkPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      permission = await Geolocator.checkPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 10);
      _movimentarCamera();
    }
  } /* 

  _mostrarLocal(String? idLocal) async {
    DocumentSnapshot livro = await _livros.doc(idLocal).get();
    String titulo = livro.get("titulo");
    String autor = livro.get("autor");
    String ano = livro.get("ano");
    LatLng latLng = LatLng(livro.get('latitude'), livro.get('longitude'));
    setState(() {
      Marker marcador = Marker(
          markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
          position: latLng,
          infoWindow:
              InfoWindow(title: '$titulo ($ano)', snippet: 'Por: $autor'),
          onTap: () {
            editando = true;
            _adicionarMarcadorLivro(latLng);
            editando = false;
          });
      _marcadores.add(marcador);
      _posicaoCamera = CameraPosition(target: latLng, zoom: 10);
      _movimentarCamera();
    });
  } */

  @override
  void initState() {
    super.initState();
    _getLocalizacaoUsuario();
  }
}

import 'package:flutter/material.dart';
import 'package:ucne_guide/Modelos/maestros.dart';
import 'package:ucne_guide/Presentation/perfil_materia_screen.dart';

import '../Modelos/materias.dart';
import '../api/api_service.dart';

class PerfilMaestroScreen extends StatefulWidget {
  final int maestroId;

  const PerfilMaestroScreen({super.key, required this.maestroId});

  @override
  State<PerfilMaestroScreen> createState() => _PerfilMaestroScreenState();
}

class _PerfilMaestroScreenState extends State<PerfilMaestroScreen> {

  final Api_Service apiService = Api_Service();
  late Future futureMaestro;

  @override
  void initState(){
    super.initState();
    futureMaestro = apiService.getMaestro(widget.maestroId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Perfil de Maestro",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFB0263F),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Maestros>(
          future: apiService.getMaestro(widget.maestroId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available.'));
            } else {
              final maestro = snapshot.data!;  // Unwrap the data

              return Column(
                children: [
                  const SizedBox(height: 20),
                  Image(
                    image: AssetImage('assets/perfil.png'),
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  ProfileField(label: "Maestro", value: maestro.nombre),
                  FutureBuilder<String>(
                    future: apiService.getMateriaDeMaestro(maestro),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ProfileField(label: "Materia", value: snapshot.data ?? "Desconocido");
                      }
                    },
                  ),
                  FutureBuilder<String>(
                    future: apiService.getFacultadMaestro(maestro.materiaId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ProfileField(label: "Facultad", value: snapshot.data ?? "Desconocido");
                      }
                    },
                  ),
                  ProfileField(label: "Descripción", value: maestro.comentario),
                  FutureBuilder<List<Materias>>(
                    //crear un endpoint para esto
                    future: apiService.getMateriasMaestro(maestro.materiaId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No hay Materias disponibles"));
                      } else {
                        return TablaMaterias(materias: snapshot.data!);
                      }
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class TablaMaterias extends StatelessWidget {
  final List<Materias> materias;

  const TablaMaterias({super.key, required this.materias});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          clipBehavior: Clip.hardEdge,
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Materias",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              // Filas dinámicas con colores alternos
              ...materias.asMap().entries.map((entry) {
                int index = entry.key;
                Materias materia = entry.value;

                return TableRow(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.grey.shade200 : Colors.white,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            materia.nombre,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 64.0),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PerfilMateriaScreen(materiaId: materia.materiaId),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.blueAccent,
                              size: 28.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
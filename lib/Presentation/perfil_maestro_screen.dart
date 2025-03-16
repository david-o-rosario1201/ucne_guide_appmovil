import 'package:flutter/material.dart';
import 'package:ucne_guide/Modelos/maestros.dart';

import '../api/api_service.dart';
import 'drawer_menu.dart';

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
    return DrawerMenu(
      title: "Perfil de Maestro",
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
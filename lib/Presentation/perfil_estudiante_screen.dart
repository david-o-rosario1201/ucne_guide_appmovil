import 'package:flutter/material.dart';
import 'package:ucne_guide/Presentation/drawer_menu.dart';

class PerfilEstudianteScreen extends StatefulWidget {
  const PerfilEstudianteScreen({super.key});

  @override
  State<PerfilEstudianteScreen> createState() => _PerfilEstudianteScreenState();
}

class _PerfilEstudianteScreenState extends State<PerfilEstudianteScreen> {
  @override
  Widget build(BuildContext context) {
    return DrawerMenu(
      title: "Perfil de Estudiante",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image(
              image: AssetImage('assets/colega.png'),
              width: 100,
            ),
            const SizedBox(height: 20),
            const ProfileField(label: "Nombre", value: "Juan Pérez"),
            const ProfileField(label: "Decanato", value: "Facultad de Ingeniería"),
            const ProfileField(label: "Carrera", value: "Ingeniería en Sis. Computacionales"),
            const ProfileField(label: "Fecha", value: "27/08/2020"),
          ],
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
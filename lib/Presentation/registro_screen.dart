import 'package:flutter/material.dart';
import 'package:ucne_guide/Modelos/estudiantes.dart';
import 'package:ucne_guide/Modelos/facultad.dart';
import 'package:ucne_guide/Presentation/home_screen.dart';
import 'package:ucne_guide/Presentation/inicio_sesion_screen.dart';
import 'package:ucne_guide/api/api_service.dart';

import '../SharedPreferences/sharedPreferencesService.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {

  final Api_Service apiService = Api_Service();
  late Future<List<Facultad>> futureFacultades;
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  Facultad? selectedFacultad;

  void createEstudiante() async {
    final nombre = nombreController.text;
    final matricula = matriculaController.text;
    final facultad = selectedFacultad?.facultadId ?? 0;

    if (nombre.isEmpty || matricula.isEmpty || selectedFacultad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todos los campos son obligatorios')),
      );
      return;
    }

    // Verificar que la matrícula solo contenga números
    final RegExp soloNumeros = RegExp(r'^[0-9]+$');
    if (!soloNumeros.hasMatch(matricula)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La matrícula solo debe contener números')),
      );
      return;
    }

    String? nombreEstudianteBuscado = await apiService.getEstudiantePorNombre(nombre);
    String? matriculaEstudianteBuscado = await apiService.getEstudiantePorMatricula(matricula);

    if (nombreEstudianteBuscado == nombre) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ya existe un estudiante con ese nombre')),
      );
      return;
    }

    if (matriculaEstudianteBuscado == matricula) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ya existe un estudiante con esa matrícula')),
      );
      return;
    }

    final nuevoEstudiante = Estudiantes(
      estudianteid: 0,
      nombre: nombre,
      carreraid: facultad,
      matricula: matricula,
    );

    await apiService.createEstudiante(nuevoEstudiante);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Estudiante creado con éxito')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }


  @override
  void initState() {
    super.initState();
    futureFacultades = apiService.getFacultades();
  }

  //Guardar shared preferences
  Future<void> _saveData() async {
    await _prefsService.saveUsername(nombreController.text);
    await _prefsService.saveMatricula(matriculaController.text);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Registro de Estudiante",
                style: TextStyle(
                  color: Color(0xFFB0263F),
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Por favor ingresa los datos para registrarte",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              buildInputField("Nombre", nombreController),
              buildInputField("Mátricula", matriculaController),
              buildDropdownFacultades(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  createEstudiante();
                  _saveData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB0263F),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Registrar",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "¿Ya tienes una cuenta?",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => InicioSesionScreen()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Color(0xFFB0263F),
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: hint,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownFacultades() {
    return FutureBuilder<List<Facultad>>(
      future: futureFacultades,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text("Error al cargar facultades");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No hay facultades disponibles");
        }

        List<Facultad> facultades = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Facultad",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<Facultad>(
                  isExpanded: true,
                  hint: const Text("Elige una facultad", style: TextStyle(fontStyle: FontStyle.italic)),
                  value: selectedFacultad,
                  underline: const SizedBox(),
                  onChanged: (Facultad? newValue) {
                    setState(() {
                      selectedFacultad = newValue;
                    });
                  },
                  items: facultades.map((facultad) {
                    return DropdownMenuItem<Facultad>(
                      value: facultad,
                      child: Text(facultad.nombre),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

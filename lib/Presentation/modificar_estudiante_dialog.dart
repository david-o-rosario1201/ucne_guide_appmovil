import 'package:flutter/material.dart';
import 'package:ucne_guide/Presentation/perfil_estudiante_screen.dart';

import '../Modelos/estudiantes.dart';
import '../SharedPreferences/sharedPreferencesService.dart';
import '../api/api_service.dart';
import 'home_screen.dart';
import 'inicio_sesion_screen.dart';

class ModificarEstudianteDialog extends StatefulWidget {
  final Estudiantes estudiante;

  const ModificarEstudianteDialog({super.key, required this.estudiante});

  @override
  State<ModificarEstudianteDialog> createState() => _ModificarEstudianteDialogState();
}

class _ModificarEstudianteDialogState extends State<ModificarEstudianteDialog> {

  final Api_Service apiService = Api_Service();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openAnimatedDialog(context);
      nombreController.text = widget.estudiante.nombre;
      matriculaController.text = widget.estudiante.matricula;
    });
  }

  void createEstudiante() async {
    final nombre = nombreController.text;
    final matricula = matriculaController.text;

    if (nombre.isEmpty || matricula.isEmpty) {
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

    Estudiantes? nombreEstudianteBuscado = await apiService.getEstudiantePorNombre(nombre);
    String? matriculaEstudianteBuscado = await apiService.getEstudiantePorMatricula(matricula);

    if (nombreEstudianteBuscado.nombre == nombre && widget.estudiante.nombre != nombre) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ya existe un estudiante con ese nombre')),
      );
      return;
    }

    if (matriculaEstudianteBuscado == matricula && widget.estudiante.matricula != matricula) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ya existe un estudiante con esa matrícula')),
      );
      return;
    }

    final nuevoEstudiante = Estudiantes(
      estudianteid: widget.estudiante.estudianteid,
      nombre: nombre,
      carreraid: widget.estudiante.carreraid,
      matricula: matricula,
    );

    await apiService.createEstudiante(nuevoEstudiante);
  }

  Future<void> _deleteData() async {
    await _prefsService.clearAllData();
    await _prefsService.saveUsername(nombreController.text);
    await _prefsService.saveMatricula(matriculaController.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PerfilEstudianteScreen()),
    );
  }

  void _openAnimatedDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Stack(
          children: [
            // Fondo semitransparente
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation1),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation1),
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    title: Text(
                      "Modificar Datos del Estudiante",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        buildInputField("Nombre", nombreController),
                        buildInputField("Matrícula", matriculaController),

                        Text("Al pulsar el botón 'Aceptar' los datos serán actualizados"),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                createEstudiante();
                                _deleteData();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text("Aceptar"),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text("Cancelar"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.purple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
}

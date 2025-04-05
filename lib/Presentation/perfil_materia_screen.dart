import 'package:flutter/material.dart';
import 'package:ucne_guide/Modelos/comentarios.dart';
import 'package:ucne_guide/Modelos/maestros.dart';
import 'package:ucne_guide/Modelos/materias.dart';
import 'package:ucne_guide/Presentation/perfil_maestro_screen.dart';
import 'package:ucne_guide/api/api_service.dart';
import '../Modelos/estudiantes.dart';
import '../SharedPreferences/sharedPreferencesService.dart';

class PerfilMateriaScreen extends StatefulWidget {
  final int materiaId;

  const PerfilMateriaScreen({super.key, required this.materiaId});

  @override
  State<PerfilMateriaScreen> createState() => _PerfilMateriaScreenState();
}

class _PerfilMateriaScreenState extends State<PerfilMateriaScreen> {
  final Api_Service apiService = Api_Service();
  List<Comentarios> comentariosList = [];

  final SharedPreferencesService _prefsService = SharedPreferencesService();
  String? estudianteNombre = "";
  late Estudiantes estudiante;
  final TextEditingController controller = TextEditingController();

  @override
  void initState(){
    super.initState();
    _loadComentarios(); // Carga inicial de comentarios
    _loadData();
  }

  Future<void> _loadData() async {
    String username = await _prefsService.loadUsername();
    setState(() {
      estudianteNombre = username;
    });
    estudiante = await apiService.getEstudiantePorNombre(estudianteNombre ?? "");
  }

  Future<void> _loadComentarios() async {
    try {
      final comentarios = await apiService.getComentariosPorMateria(widget.materiaId);

      setState(() {
        comentariosList.clear();
        comentariosList.addAll(comentarios);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los comentarios')),
      );
    }
  }

  void createComentario() async {
    final contenido = controller.text;

    if (contenido.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debe escribir un comentario')),
      );
      return;
    }

    final nuevoComentario = Comentarios(
        comentarioid: 0,
        materiaid: widget.materiaId,
        estudianteid: estudiante.estudianteid ?? 0,
        contenido: contenido
    );

    //Actualiza la UI
    setState(() {
      comentariosList.add(nuevoComentario);
    });

    controller.clear();
    await apiService.createComentario(nuevoComentario);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comentario creado con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Perfil de Materia",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFB0263F),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<Materias>(
              future: apiService.getMateria(widget.materiaId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data available.'));
                } else {
                  final materia = snapshot.data!;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 80), // Espacio para la barra de comentarios
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Image(
                          image: AssetImage('assets/libros.png'),
                          width: 100,
                        ),
                        const SizedBox(height: 20),
                        ProfileField(label: "Materia", value: materia.nombre),
                        FutureBuilder<String>( // Mostrando Facultad
                          future: apiService.getFacultadDeMateria(materia),
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
                        ProfileField(label: "Código de Materia", value: materia.codigoMateria),
                        ProfileField(label: "Descripción", value: materia.descripcion),
                        FutureBuilder<List<Maestros>>(
                          future: apiService.getMaestrosMateria(materia.materiaId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text("Error: ${snapshot.error}"));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text("No hay docentes disponibles"));
                            } else {
                              return TablaMaestros(maestros: snapshot.data!);
                            }
                          },
                        ),
                        // Mostrar comentarios usando ListView.builder
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comentariosList.length,
                          itemBuilder: (context, index) {
                            final comentario = comentariosList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FutureBuilder<Estudiantes>(
                                    future: apiService.getEstudiante(comentario.estudianteid),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return const Text("Error");
                                      } else {
                                        final estudiante = snapshot.data!;
                                        return CircleAvatar(
                                          backgroundColor: Colors.blueAccent,
                                          child: Text(
                                            estudiante.nombre[0], // Inicial del nombre
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder<Estudiantes>(
                                          future: apiService.getEstudiante(comentario.estudianteid),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return const Text("Cargando...");
                                            } else if (snapshot.hasError) {
                                              return const Text("Error al cargar el estudiante");
                                            } else {
                                              return Text(
                                                snapshot.data!.nombre,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '"${comentario.contenido}"',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          /// Barra fija en la parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Agrega un comentario...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      createComentario();
                    },
                  )
                ],
              ),
            ),
          ),
        ],
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


class TablaMaestros extends StatelessWidget {
  final List<Maestros> maestros;

  const TablaMaestros({super.key, required this.maestros});

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
              // Encabezado
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
                      "Docente",
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
              ...maestros.asMap().entries.map((entry) {
                int index = entry.key;
                Maestros maestro = entry.value;

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
                            maestro.nombre,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 64.0),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PerfilMaestroScreen(maestroId: maestro.maestroId),
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
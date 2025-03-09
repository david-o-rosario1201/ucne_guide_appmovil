import 'package:flutter/material.dart';

class ConsultaAsignaturaScreen extends StatefulWidget {
  const ConsultaAsignaturaScreen({super.key});

  @override
  State<ConsultaAsignaturaScreen> createState() => _ConsultaAsignaturaScreenState();
}

class _ConsultaAsignaturaScreenState extends State<ConsultaAsignaturaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Consulta de Asignaturas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFB0263F),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Buscar asignatura",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Lista de asignaturas (simulada)
            Expanded(
              child: ListView(
                children: List.generate(8, (index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                          "Asignatura ${index + 1}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text("Facultad de Ingeniería"),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Ver",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

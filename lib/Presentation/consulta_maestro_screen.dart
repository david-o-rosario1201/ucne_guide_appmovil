import 'package:flutter/material.dart';
import 'package:ucne_guide/Presentation/drawer_menu.dart';

class ConsultaMaestroScreen extends StatefulWidget {
  const ConsultaMaestroScreen({super.key});

  @override
  State<ConsultaMaestroScreen> createState() => _ConsultaMaestroScreenState();
}

class _ConsultaMaestroScreenState extends State<ConsultaMaestroScreen> {
  @override
  Widget build(BuildContext context) {
    return DrawerMenu(
      title: "Consulta de Maestros",
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
                        hintText: "Buscar maestro",
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
                        "Juan Peréz ${index + 1}",
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

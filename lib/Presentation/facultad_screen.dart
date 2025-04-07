import 'package:flutter/material.dart';

import 'consulta_asignatura_screen.dart';
import 'drawer_menu.dart';

class FacultadScreen extends StatefulWidget {
  const FacultadScreen({super.key});

  @override
  State<FacultadScreen> createState() => _FacultadScreenState();
}

class _FacultadScreenState extends State<FacultadScreen> {



  @override
  Widget build(BuildContext context) {
    return DrawerMenu(
      title: "Facultades",
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _buildCard("Ingeniería", "assets/engineers.png",() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ConsultaAsignaturaScreen(selectOption: 1)),
                          );
                        }),
                        SizedBox(width: 30.0),
                        _buildCard("Educación","assets/homework.png", () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConsultaAsignaturaScreen(selectOption: 2)),
                      );
                        })
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: <Widget>[
                        _buildCard("Ciencias de la Salud", "assets/healthcare.png",() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ConsultaAsignaturaScreen(selectOption: 3)),
                          );
                        })
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}

Widget _buildCard(String text, String imagen, VoidCallback onTap) {
  return Expanded(
    child: Card(
      color: Colors.grey[300],
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.blueAccent.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                imagen,
                width: 60,
                height: 60,
              ),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
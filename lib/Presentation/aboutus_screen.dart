import 'package:flutter/material.dart';

class AboutusScreen extends StatefulWidget {
  const AboutusScreen({super.key});

  @override
  State<AboutusScreen> createState() => _AboutusScreenState();
}

class _AboutusScreenState extends State<AboutusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFB0263F),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen o logo
            Center(
              child: Image.asset(
                "assets/colegio.png",
                height: 120,
              ),
            ),
            const SizedBox(height: 20),

            // Título principal
            const Text(
              "¿Quiénes Somos?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB0263F),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Descripción
            const Text(
              "Nuestra aplicación está diseñada para ayudar a los estudiantes de la UCNE a tomar decisiones informadas sobre sus materias. "
                  "Aquí puedes explorar asignaturas, conocer su nivel de complejidad, consultar las metodologías de evaluación de los profesores y leer reseñas de otros estudiantes. "
                  "Queremos brindarte la mejor experiencia académica con información clara y útil antes de seleccionar tus materias.",
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),

            // Línea separadora
            Divider(color: Colors.grey.shade400),

            // Información de versión y derechos
            const SizedBox(height: 10),
            const Text(
              "Versión: 1.0.0",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 5),
            const Text(
              "© UCNE Guide Inc. 2025",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

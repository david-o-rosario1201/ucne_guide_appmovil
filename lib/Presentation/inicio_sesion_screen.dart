import 'package:flutter/material.dart';
import 'package:ucne_guide/Presentation/registro_screen.dart';

import '../SharedPreferences/sharedPreferencesService.dart';
import '../api/api_service.dart';
import 'home_screen.dart';

class InicioSesionScreen extends StatefulWidget {
  const InicioSesionScreen({super.key});

  @override
  State<InicioSesionScreen> createState() => _InicioSesionScreenState();
}

class _InicioSesionScreenState extends State<InicioSesionScreen> {

  final Api_Service apiService = Api_Service();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  void login() async{
    final nombre = nombreController.text;
    final matricula = matriculaController.text;

    if (nombre.isEmpty || matricula.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todos los campos son obligatorios')),
      );
      return;
    }

    bool userAndPasswordCorrect = await apiService.isUserAndPasswordCorrect(nombre,matricula);

    if (!userAndPasswordCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario y/o contraseña incorrectos')),
      );
      return;
    }
    else{
      _saveData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
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
                "Inicio de Sesión",
                style: TextStyle(
                  color: Color(0xFFB0263F),
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Por favor inicia sesión para continuar",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              buildInputField("Nombre", nombreController),
              buildInputField("Mátricula", matriculaController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB0263F),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Iniciar",
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
                        MaterialPageRoute(builder: (context) => RegistroScreen()),
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
}

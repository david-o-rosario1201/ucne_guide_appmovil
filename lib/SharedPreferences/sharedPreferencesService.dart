import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesService {
  Future<String> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? "No user saved";
  }

  Future<int> loadEstudianteId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('estudianteId') ?? 0;
  }

  Future<String> loadMatricula() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('matricula') ?? "No matricula saved";
  }



  Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<void> saveEstudianteId(int estudianteId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('estudianteId', estudianteId);
  }

  Future<void> saveMatricula(String matricula) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('matricula', matricula);
  }


  Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
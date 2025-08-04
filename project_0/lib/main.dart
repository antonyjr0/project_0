import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_0/database/game_hive_service.dart';
import 'package:project_0/screens/home.dart';

Future main() async {
  // Assicurati che Flutter sia inizializzato
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carica le variabili d'ambiente
  await dotenv.load(fileName: ".env");
  
  // Inizializza Hive PRIMA di avviare l'app
  await GameHiveService.init();
  
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Discovery App',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
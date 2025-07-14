import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/di/dependency_injection.dart';
import 'core/constants/app_constants.dart';
import 'presentation/pages/movie_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await DependencyInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MovieListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

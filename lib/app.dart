import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/home/controller/home_controller.dart';
import 'features/home/view/home_page.dart';
import 'features/modules/controller/module_controller.dart';
import 'features/videos/controller/video_controller.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ModuleController(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideoController(),
        )



      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        );
      },
    );
  }
}

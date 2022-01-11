import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import 'ui/main_screen.dart';
import 'package:provider/provider.dart';
import 'data/memory_repository.dart';

Future<void> main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 1 Use the "ChangeNotifierProvider" that has the type "MemoryRepository".
    return ChangeNotifierProvider<MemoryRepository>(
      // 2 Set "lazy" to false, which creates the repository right away instead
      // of waiting until you need it. This is useful when the repository has to
      // do some background work to start up.
      lazy: false,
      // 3 Create your repository.
      create: (_) => MemoryRepository(),
      // 4 Return "MaterialApp" as the child widget.
      child: MaterialApp(
        title: 'Recipes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

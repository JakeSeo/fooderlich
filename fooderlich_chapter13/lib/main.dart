import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'mock_service/mock_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // 1 "MultiProvider" uses the "providers" property to define multiple
      // providers.
      providers: [
        // 2 The first provider is your existing "ChangeNotifierProvider".
        ChangeNotifierProvider<MemoryRepository>(
          lazy: false,
          create: (_) => MemoryRepository(),
        ),
        // 3 You add a new provider, which will use the new mock service.
        Provider(
          // 4 Create the "MockService" and call "create()" to load the JSON
          // files (notice the ..cascade operator).
          create: (_) => MockService()..create(),
          lazy: false,
        ),
      ],
      // 5 The only child is a "MaterialApp", like before.
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

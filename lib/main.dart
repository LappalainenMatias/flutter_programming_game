import 'package:anki/widget/add_opponent.dart';
import 'package:anki/widget/joystick.dart';
import 'package:anki/widget/keyboard_movement.dart';
import 'package:anki/widget/statistics.dart';
import 'package:anki/widget/zoom_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:anki/game.dart';
import 'package:provider/provider.dart';
import 'game_loop.dart';
import 'package:flutter/services.dart';
import 'game_map_screen.dart';
import 'online/online.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  /// Used for running region creation web worker
  if (kIsWeb) {
    await JsIsolatedWorker().importScripts(['regionworker.js']);
  }

  runApp(const IsometricMapApp());
}

class IsometricMapApp extends StatelessWidget {
  const IsometricMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isometric map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(title: 'Isometric map'),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late final GameLoop gameLoop;
  late final Game game;
  late final Online online;

  @override
  void initState() {
    super.initState();
    game = Game(isMultiplayer: false);
    online = Online();
    gameLoop = GameLoop(this, game, online);
  }

  @override
  void dispose() {
    gameLoop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => game),
        ChangeNotifierProvider(create: (_) => gameLoop),
        ChangeNotifierProvider(create: (_) => online),
      ],
      child: const KeyBoardMovement(
        child: Material(
          color: Colors.black,
          child: Stack(
            children: [
              GameScreen(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Statistics(),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ZoomButtons(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: JoyStick(),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: AddOpponent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

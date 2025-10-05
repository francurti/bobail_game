import 'package:bobail_mobile/pages/main_menu.dart';
import 'package:bobail_mobile/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ProviderScope(child: const BobailApp()));
}

class BobailApp extends StatelessWidget {
  const BobailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bobail game',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: MainMenu(),
    );
  }
}

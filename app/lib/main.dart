import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:until/src/screens/feed.dart';
import 'package:until/src/screens/splashScreen.dart';
import 'package:until/src/service/event_provider.dart';
import 'package:until/src/service/prefs.dart';
import 'package:until/src/util/style.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Until',
      theme: appTheme,
      home: SplashScreen(),
      routes: {
        "/feed": (context) => Feed(),
      },
    );
  }
}

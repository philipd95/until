import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:until/src/service/event_provider.dart';
import 'package:until/src/service/prefs.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loadEvents().then((value) {
      ref.read(eventProvider.notifier).setEvents(value);
      Future.delayed(const Duration(seconds: 1)).whenComplete(
        () => Navigator.pushNamed(context, "/feed"),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

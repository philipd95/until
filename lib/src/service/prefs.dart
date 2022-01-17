import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:until/src/models/event.dart';

saveEvents(List<UntilEvent> events) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("events", jsonEncode(events.map((e) => e.toJson()).toList()));
}

Future<List<UntilEvent>> loadEvents() async {
  final prefs = await SharedPreferences.getInstance();

  String savedString = prefs.getString("events") ?? jsonEncode([]);

  List<dynamic> decoded = jsonDecode(savedString) as List;

  List<UntilEvent> events = (jsonDecode(savedString) as List)
      .map((e) => UntilEvent.fromJson(e))
      .toList();

  events.sort((a, b) => a.date.toString().compareTo(b.date.toString()));

  return events;
}

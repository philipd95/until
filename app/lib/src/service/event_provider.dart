import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:until/src/models/event.dart';
import 'package:until/src/service/prefs.dart';

final eventProvider =
    StateNotifierProvider<CurrentEvents, List<UntilEvent>>((ref) {
  return CurrentEvents();
});

class CurrentEvents extends StateNotifier<List<UntilEvent>> {
  CurrentEvents() : super([]);

  Future<void> setEvents(List<UntilEvent> events) async {
    state = events;
    await saveEvents(state);
  }

  Future<void> addEvent(UntilEvent event) async {
    state.add(event);
    await saveEvents(state);
  }

  Future<void> removeEvent(UntilEvent event) async {
    state.remove(event);
    await saveEvents(state);
  }
}

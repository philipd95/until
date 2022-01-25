import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:until/src/models/event.dart';
import 'package:until/src/service/event_provider.dart';
import 'package:until/src/util/until_colors.dart';
import 'package:until/src/util/util.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:until/src/widgets/event_container.dart';
import 'package:image_picker/image_picker.dart';

class Feed extends ConsumerStatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

String headlineText(BuildContext context) {
  DateTime now = DateTime.now();
  return "${weekday[now.weekday]} ${now.day} ${month[now.month]} ${now.year}";
}

class HomeState extends ConsumerState<Feed> {
  late TextEditingController _textController;
  late List<UntilEvent> events;
  late bool editing;
  final ImagePicker _imagePicker = ImagePicker();

  DateTime? selectedDate;

  String? imageString;

  @override
  void initState() {
    super.initState();
    events = ref.read(eventProvider);
    _textController = TextEditingController();
    editing = false;
  }

  void toggleEdit() {
    setState(() {
      editing = !editing;
    });
  }

  void removeEvent(UntilEvent event) {
    ref.read(eventProvider.notifier).removeEvent(event);
    setState(() {});
  }

  bool validEvent(String title, DateTime? date) {
    return title != "" && date != null;
  }

  DateTime tomorrow() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
  }

  Widget buildSubmitButton(String title, DateTime? date) {
    return validEvent(title, date)
        ? TextButton(
            style: TextButton.styleFrom(
              backgroundColor: UntilColors.salmon,
            ),
            onPressed: () {
              ref
                  .read(eventProvider.notifier)
                  .addEvent(
                      UntilEvent(title: _textController.text, date: date!))
                  .whenComplete(() => {
                        _textController.clear(),
                        Navigator.pop(context),
                        setState(() {})
                      });
            },
            child: Text(
              "add",
              style: TextStyle(color: UntilColors.white),
            ),
          )
        : const SizedBox.shrink();
  }

  closeDialog() {
    _textController.clear();
    Navigator.pop(context);
    setState(() {
      selectedDate = null;
      imageString = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    events = ref.read(eventProvider);
    events.sort((a, b) => a.date.toString().compareTo(b.date.toString()));

    ThemeData appTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appTheme.backgroundColor,
        title: Text(headlineText(context), style: appTheme.textTheme.headline6),
        actions: [
          events.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    splashRadius: 20,
                    splashColor: UntilColors.yellow,
                    onPressed: () => toggleEdit(),
                    icon: Icon(editing ? Icons.edit_off : Icons.edit),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showEventDialog();
        },
        child: const Icon(
          Icons.add,
        ),
        backgroundColor: UntilColors.salmon,
        splashColor: UntilColors.blue,
      ),
      body: ListView(
        children: [
          ...events
              .map((e) => EventContainer(
                    event: e,
                    editing: editing,
                    deleteCallback: removeEvent,
                  ))
              .toList(),
        ],
      ),
    );
  }

  void showEventDialog() {
    Size deviceSize = MediaQuery.of(context).size;
    ThemeData appTheme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            backgroundColor: UntilColors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _textController,
                  autofocus: true,
                  decoration: InputDecoration(
                    label: const Text("Title: "),
                    border: InputBorder.none,
                    fillColor: UntilColors.blue,
                  ),
                ),
                SizedBox(
                  height: 300,
                  width: deviceSize.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SfDateRangePicker(
                      todayHighlightColor: UntilColors.blue,
                      backgroundColor: Colors.black12,
                      selectionColor: UntilColors.salmon,
                      enablePastDates: false,
                      showNavigationArrow: true,
                      minDate: tomorrow(),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        setState(() {
                          selectedDate = args.value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: imageString == null
                      ? TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: UntilColors.blue),
                          onPressed: () async {
                            final XFile? xFile = await _imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (xFile != null) {
                              final path = xFile.path;
                              final bytes = await File(path).readAsBytes();
                              setState(() {
                                imageString = base64Encode(bytes);
                              });
                            }
                          },
                          child: const Text("add image"),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("image added 🏞"),
                        ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => closeDialog(),
                child: const Text("cancel"),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: UntilColors.salmon,
                ),
                onPressed: () {
                  if (validEvent(_textController.text, selectedDate)) {
                    ref
                        .read(eventProvider.notifier)
                        .addEvent(
                          UntilEvent(
                            title: _textController.text,
                            date: selectedDate!,
                            img: imageString,
                          ),
                        )
                        .whenComplete(
                          () => closeDialog(),
                        );
                  }
                },
                child: Text(
                  "add",
                  style: TextStyle(color: UntilColors.white),
                ),
              )
            ],
          );
        });
      },
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:until/src/models/event.dart';
import 'package:until/src/util/until_colors.dart';

class EventContainer extends StatelessWidget {
  final UntilEvent event;
  final bool editing;
  final Function(UntilEvent) deleteCallback;
  const EventContainer({
    Key? key,
    required this.event,
    required this.editing,
    required this.deleteCallback,
  }) : super(key: key);

  String until() {
    String s = "";
    DateTime now = DateTime.now();
    int days = event.date.difference(now).inDays;
    if (days > 1) {
      s = "$days days";
    } else {
      int hours = event.date.difference(now).inHours;
      if (hours >= 0) {
        s = "$hours hours";
      } else {
        s = "today";
      }
    }
    return s;
  }

  String date() {
    return "${event.date.day}.${event.date.month}.${event.date.year}";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    Size deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: event.img != null ? UntilColors.white : UntilColors.yellow,
        elevation: 8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 120,
                width: deviceSize.width - 16,
                decoration: event.img != null
                    ? BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(
                            base64Decode(event.img!),
                          ),
                        ),
                      )
                    : const BoxDecoration(),
                child: Stack(
                  children: [
                    editing
                        ? Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () => deleteCallback(event),
                              splashColor: UntilColors.salmon,
                              splashRadius: 20,
                              icon: Icon(
                                Icons.delete,
                                color: UntilColors.salmon,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: UntilColors.white,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          event.title,
                          style: appTheme.textTheme.headline5,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              date(),
                              style: appTheme.textTheme.headline6,
                            ),
                            Text(
                              until(),
                              style: appTheme.textTheme.headline1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

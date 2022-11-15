import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Entry.dart';

class EntryScreen extends StatefulWidget {
  late final Entry _tempEntry;

  EntryScreen({super.key, required Entry entry}) {
    // Initialize temp entry
    _tempEntry = entry.clone();
  }

  @override
  State<EntryScreen> createState() => _EntryScreen();
}

class _EntryScreen extends State<EntryScreen> {
  void _selectDate() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: widget._tempEntry.created_at,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDate) {
              setState(() => widget._tempEntry.created_at = newDate);
            },
          )
        ),
      )
    );

  }

  Widget _bottomToolBar() {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFBCBBC1), width: 0)
          )
        ),
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.calendar),
                    Text(
                      ' ${DateFormat('yMMMMEEEEd').format(widget._tempEntry.created_at)}'
                    )
                  ],
                ),
                onPressed: () => _selectDate(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('Save'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const CupertinoTextField(
                placeholder: 'Title',
                style: TextStyle(fontSize: 30),
              ),
              Divider(
                height: 20,
                thickness: 1,
                color: Colors.grey[700],
              ),
              Row(
                children: [
                  const Text(
                    'Reykjavik,\nIceland',
                    style: TextStyle(
                      color: Colors.grey
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: const [
                      Icon(CupertinoIcons.cloud, color: Colors.grey,),
                      Text(
                        '23 °C',
                        style: TextStyle(
                          color: Colors.grey
                        ),
                      )
                    ]
                  ),
                ],
              ),
              const Expanded(
                child: CupertinoTextField(
                  placeholder: 'Body',
                  minLines: null,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  padding: EdgeInsets.symmetric(vertical: 10)
                )
              ),
              _bottomToolBar()
            ],
          ),
        ),
      )
    );
  }
}
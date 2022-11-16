import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:paper_rails/utilities/location.dart';
import 'package:paper_rails/utilities/weather_evaluator.dart';
import '../models/Entry.dart';

class EntryScreen extends StatefulWidget {
  late final Entry _tempEntry;

  EntryScreen({super.key, Entry? entry}) {
    // Initialize temp entry
    if (entry == null) {
      _tempEntry = Entry(null);
    } else {
      _tempEntry = entry.clone();
    }
  }

  @override
  State<EntryScreen> createState() => _EntryScreen();
}

class _EntryScreen extends State<EntryScreen> with Locator, WeatherEvaluator {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    // Add 
    _setEntryInfo();

    // Add listeners 
    super.initState();
    _titleController = TextEditingController(text: widget._tempEntry.title)
    ..addListener(() {
      widget._tempEntry.title = _titleController.text;
    });
    _bodyController = TextEditingController(text: widget._tempEntry.body)
    ..addListener(() {
      widget._tempEntry.body = _bodyController.text;
    });
  }

  void _setEntryInfo() async {
    try {
      final position = await determinePosition();
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      final weather = await determineWeather(position.latitude, position.longitude);

      setState(() {
        widget._tempEntry.placemark = placemarks.first;
        widget._tempEntry.entryWeatherInfo = EntryWeatherInfo(
          weather.temperature?.celsius?.toInt(),
          weather.weatherConditionCode
        );
      });
    } catch(error) {
      print(error);
    }
  }

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
            initialDateTime: widget._tempEntry.createdAt,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDate) {
              setState(() => widget._tempEntry.createdAt = newDate);
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
                      ' ${DateFormat('yMMMMEEEEd').format(widget._tempEntry.createdAt)}'
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

  Widget _entryDetailsRow() {
    final placemark = widget._tempEntry.placemark;
    final temperature = widget._tempEntry.entryWeatherInfo?.celsius;
    final weather = widget._tempEntry.entryWeatherInfo?.weatherConditionCode;

    return Row(
      children: [
        Text(
          placemark == null ?
            '---\n' :
            '${placemark.street}\n'
            '${placemark.locality}'
          ,
          style: const TextStyle(
            color: Colors.grey
          ),
        ),
        const Spacer(),
        Column(
          children: [
            _conditionCodeToWidget(weather),
            Text(
              temperature == null ?
                '---' :
                '$temperature °C'
              ,
              style: const TextStyle(
                color: Colors.grey
              ),
            )
          ]
        ),
      ],
    );
  }

  Widget _conditionCodeToWidget(int? code) {
    if (code == null) {
      return const Text(
        'No data available',
        style: TextStyle(color: Colors.grey)
      );
    }
    if (200 <= code && code < 300) {
      return const Icon(
        CupertinoIcons.cloud_bolt_fill,
        color: Colors.grey,
      );
    } else if (300 <= code && code < 500) {
      return const Icon(
        CupertinoIcons.cloud_drizzle_fill,
        color: Colors.grey,
      );
    } else if (500 <= code && code < 600) {
      return const Icon(
        CupertinoIcons.cloud_heavyrain_fill,
        color: Colors.grey,
      );
    } else if (600 <= code && code < 700) {
      return const Icon(
        CupertinoIcons.snow,
        color: Colors.grey,
      );
    } else if (700 <= code && code < 800) {
      return const Icon(
        CupertinoIcons.cloud_fog_fill,
        color: Colors.grey,
      );
    } else if (code == 800) {
      return const Icon(
        CupertinoIcons.sun_max_fill,
        color: Colors.grey,
      );
    } else if (801 <= code && code < 900) {
      return const Icon(
        CupertinoIcons.cloud_fill,
        color: Colors.grey,
      );
    } else {
      return const Text(
        'No data available',
        style: TextStyle(color: Colors.grey)
      );
    }
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
              _entryDetailsRow(),
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
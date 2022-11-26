import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:paper_rails/db/entry_db.dart';
import 'package:paper_rails/utilities/location.dart';
import 'package:paper_rails/utilities/weather_evaluator.dart';
import '../models/entry.dart';

class EntryScreen extends StatefulWidget {
  final Entry _tempEntry;

  const EntryScreen({super.key, required entry}): _tempEntry = entry;

  @override
  State<EntryScreen> createState() => _EntryScreen();
}

class _EntryScreen extends State<EntryScreen> with Locator, WeatherEvaluator {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final Future<EntryCollection> _entryCollection;
  bool _isDoneSettingEntryInfo = false;

  bool get _isNewEntry => widget._tempEntry.id == null;

  @override
  void initState() {
    super.initState();

    // Set info only on new entries
    if (_isNewEntry) {
      _setEntryInfo();
    }

    // Set collection
    _entryCollection = EntryCollection.collection;

    // Add listeners 
    _titleController = TextEditingController(text: widget._tempEntry.title)
    ..addListener(() {
      widget._tempEntry.title = _titleController.text;
    });

    _bodyController = TextEditingController(text: widget._tempEntry.body)
    ..addListener(() {
      widget._tempEntry.body = _bodyController.text;
    });
  }

  void _showDialog(Widget child) {
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
          child: child,
        ),
      )
    );
  }

  void _setEntryInfo() async {
    try {
      final position = await determinePosition();
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      final placemark = placemarks.first;
      widget._tempEntry.placeInfo = PlaceInfo(
        placemark.street,
        placemark.locality,
        placemark.country
      );

      final weather = await determineWeather(position.latitude, position.longitude);
      widget._tempEntry.weatherInfo = WeatherInfo(
        weather.temperature?.celsius?.toInt(),
        weather.weatherConditionCode
      );
    } catch(error) {
      print(error);
    }

    setState(() => _isDoneSettingEntryInfo = true);
  }

  void _create() async {
    final collection = await _entryCollection;
    collection.create(widget._tempEntry);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _save() async {
    final collection = await _entryCollection;
    collection.update(widget._tempEntry);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _selectDate() {
    _showDialog(
      CupertinoDatePicker(
        initialDateTime: widget._tempEntry.createdAt,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (DateTime newDate) {
          setState(() {
            var newDateTime = DateTime(
              newDate.year,
              newDate.month,
              newDate.day,
              widget._tempEntry.createdAt.hour,
              widget._tempEntry.createdAt.minute,
              widget._tempEntry.createdAt.second,
              widget._tempEntry.createdAt.millisecond,
              widget._tempEntry.createdAt.microsecond,
            );
            widget._tempEntry.createdAt = newDateTime;
          });
        },
      )
    );
  }

  void _selectTime() {

    _showDialog(
      CupertinoDatePicker(
        initialDateTime: widget._tempEntry.createdAt,
        mode: CupertinoDatePickerMode.time,
        // This is called when the user changes the time.
        onDateTimeChanged: (DateTime newTime) {
          setState(() => widget._tempEntry.createdAt = newTime);
        },
      ),
    );
  }

  Widget _buildTitle() {
    return CupertinoTextField(
      placeholder: 'Title',
      style: const TextStyle(fontSize: 30),
      controller: _titleController,
    );
  }

  Widget _entryDetailsRow() {
    final placeInfo = widget._tempEntry.placeInfo;
    final temperature = widget._tempEntry.weatherInfo?.celsius;
    final weather = widget._tempEntry.weatherInfo?.weatherConditionCode;

    if (_isNewEntry && !_isDoneSettingEntryInfo) {
      return const CupertinoActivityIndicator(
        radius: 10,
      );
    }

    return Column(
      children: [
        Row(
          children: [
            const Icon(CupertinoIcons.location_solid,
              color: Colors.grey,
            ),
            Text(
              placeInfo == null ?
                '  ---' :
                '  ${placeInfo.street ?? '---'}, ${placeInfo.locality ?? '---'}'
              ,
              style: const TextStyle(
                color: Colors.grey
              ),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            Icon(
              conditionCodeToWidget(weather),
              color: Colors.grey,
            ),
            Text(
              temperature == null ?
                '  ---' :
                '  $temperature °C'
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

  Widget _buildBody() {
    return Expanded(
      child: CupertinoTextField(
        placeholder: 'Body',
        minLines: null,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        padding: const EdgeInsets.symmetric(vertical: 10),
        controller: _bodyController,
      )
    );
  }

  Widget _bottomToolBar() {
    final date = widget._tempEntry.createdAt;

    final timeString = DateFormat(DateFormat.HOUR_MINUTE).format(date);
    final dateString = DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY).format(date);

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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.calendar),
                    Text(
                      ' $dateString'
                    )
                  ],
                ),
                onPressed: () => _selectDate(),
              ),
              const Spacer(),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.time),
                    Text(
                      ' $timeString'
                    )
                  ],
                ),
                onPressed: () => _selectTime(),
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
          trailing: _isNewEntry ?
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _isNewEntry && !_isDoneSettingEntryInfo ?
                null :
                _create,
              child: const Text('Create'),
            ) :
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _save,
              child: const Text('Save'),
            )
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTitle(),
              Divider(
                height: 20,
                thickness: 1,
                color: Colors.grey[700],
              ),
              _entryDetailsRow(),
              const SizedBox(
                height: 10,
              ),
              _buildBody(),
              _bottomToolBar()
            ],
          ),
        ),
      )
    );
  }
}
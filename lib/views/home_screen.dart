import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:paper_rails/db/entry_db.dart';
import 'package:paper_rails/models/entry.dart';
import 'package:paper_rails/utilities/weather_evaluator.dart';
import 'package:paper_rails/views/entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with WeatherEvaluator {
  late final Future<EntryCollection> _entryCollection;

  late final List<List<Entry>> _entriesByMonthAndYear = [];

  @override
  void initState() {
    super.initState();

    // Set collection
    _entryCollection = EntryCollection.collection;

    _initEntries();
  }

  void _initEntries() async {
    final collection = await EntryCollection.collection;
    final entries = await collection.getAll();

    _entriesByMonthAndYear.clear();

    Entry? prevEntry;
    for (var currEntry in entries) {
      final currMonth = currEntry.createdAt.month;
      final currYear = currEntry.createdAt.year;

      final prevMonth = prevEntry?.createdAt.month;
      final prevYear = prevEntry?.createdAt.year;

      // Entry does not correspond to same month or year as previous entry
      if (currMonth != prevMonth || currYear != prevYear) {
        _entriesByMonthAndYear.add([currEntry]);
      } else {
        _entriesByMonthAndYear.last.add(currEntry);
      }

      prevEntry = currEntry;
    }

    setState(() {
    });
  }

  Widget _entryCardDate(DateTime datetime) {
    final weekDay = DateFormat(DateFormat.ABBR_WEEKDAY).format(datetime);
    final monthAndDay = DateFormat(DateFormat.ABBR_MONTH_DAY).format(datetime);

    return Container(
      height: 60,
      width: 60,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(weekDay, style: const TextStyle(fontWeight: FontWeight.w900),),
          Text(monthAndDay)
        ],
      ),
    );
  }

  Widget _entryCard(BuildContext context, Entry entry) {
    final datetime = entry.createdAt;
    final placeString = entry.placeInfo?.country != null && entry.placeInfo?.locality != null? '• ${entry.placeInfo!.locality}, ${entry.placeInfo!.country}' :
      entry.placeInfo?.country != null ? '• ${entry.placeInfo!.locality}' :
      entry.placeInfo?.locality != null ? '• ${entry.placeInfo!.country}' :
      '';

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            onPressed: (BuildContext context) => _onDelete(entry.id!),
            label: 'Delete',
            icon: CupertinoIcons.trash_fill,
          )
        ],
      ),
      child: CupertinoListTile(
        leading: _entryCardDate(datetime),
        title: Row(
          children: [
            Flexible(
              child: Text(
                entry.title ?? '',
                overflow: TextOverflow.ellipsis
              )
            )
          ]
        ),
        // subtitle: const Text(
        //   '2:44PM • 3100 Sea Breeze • Cloudy',
        //   style: TextStyle(color: Colors.grey),
        // ),
        subtitle: Row(
          children: [
            Icon(
              conditionCodeToWidget(entry.weatherInfo?.weatherConditionCode),
            ),
            const SizedBox(width: 20,),
            Flexible(
              child: Text(
                '${DateFormat(DateFormat.HOUR_MINUTE).format(entry.createdAt)} $placeString',
                style: const TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
        onTap: () => _editEntry(context, entry)
      ),
    );
  }

  Widget _bottomToolBar(BuildContext context) {
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
              const Spacer(),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text('Add'),
                onPressed: () => _addEntry(context),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _editEntry(BuildContext context, Entry entry) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (BuildContext builder) {
        return EntryScreen(entry: entry);
      })
    );

      _initEntries();
  }

  void _addEntry(BuildContext context) async  {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (BuildContext context) {
        var entry = Entry()
          ..createdAt = DateTime.now();
        return EntryScreen(entry: entry);
      })
    );

    _initEntries();
  }

  void _onDelete(int id) async {
    final collection = await _entryCollection;
    await collection.delete(id);

    _initEntries();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Journal'),
          ),
          SliverFillRemaining(
            child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _entriesByMonthAndYear.length,
                      itemBuilder: (context, index) {
                        final monthAndYearSection = _entriesByMonthAndYear[index];
                        final firstEntry = monthAndYearSection.first;
                        final month = DateFormat(DateFormat.MONTH).format(firstEntry.createdAt);
                        final year = DateFormat(DateFormat.YEAR).format(firstEntry.createdAt);

                        return CupertinoFormSection.insetGrouped(
                          header: Text('$month $year'),
                          children: monthAndYearSection.map((entry) {
                            return _entryCard(context, entry);
                          }).toList()
                        );
                      }
                    )
                  ),
                  _bottomToolBar(context)
                ],
              ),
          )
        ],
      ),
    );
  }
}

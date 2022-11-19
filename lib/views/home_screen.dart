import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:paper_rails/db/entry_db.dart';
import 'package:paper_rails/models/entry.dart';
import 'package:paper_rails/views/entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late final Future<EntryCollection> _entryCollection;

  late List<Entry> _entries = [];

  @override
  void initState() {
    super.initState();

    // Set collection
    _entryCollection = EntryCollection.collection;

    _initEntries();
  }

  void _initEntries() async {
    final collection = await EntryCollection.collection;
    _entries = await collection.getAll();
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
            Icon(CupertinoIcons.cloud),
            const SizedBox(width: 20,),
            Text(
              '${DateFormat(DateFormat.HOUR_MINUTE).format(entry.createdAt)} • ${entry.placeInfo!.locality}, ${entry.placeInfo!.country}',
              style: const TextStyle(color: Colors.grey),
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

    final collection = await EntryCollection.collection;
    _entries = await collection.getAll();

    setState(() {
    });
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

    final collection = await EntryCollection.collection;
    _entries = await collection.getAll();

    setState(() {});
  }

  void _onDelete(int id) async {
    final collection = await _entryCollection;
    await collection.delete(id);

    _entries = await collection.getAll();

    setState(() {});
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
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        return _entryCard(context, _entries[index]);
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

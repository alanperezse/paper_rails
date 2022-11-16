import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paper_rails/models/Entry.dart';
import 'package:paper_rails/views/entry_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget _entryCardDate() {
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
          Text('FRI', style: const TextStyle(fontWeight: FontWeight.w900),),
          Text('09/30')
        ],
      ),
    );
  }

  CupertinoListTile _entryCard(context) {
    return CupertinoListTile(
      leading: _entryCardDate(),
      trailing: Icon(
        CupertinoIcons.forward
      ),
      title: Row(children:[ Flexible(child: Text('Entry 1', overflow: TextOverflow.ellipsis))]),
      subtitle: const Text(
        '2:44PM • 3100 Sea Breeze • Cloudy',
        style: TextStyle(color: Colors.grey),
      ),
      onTap: () => _editEntry(context)
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

  void _editEntry(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (BuildContext builder) {
        var datetime = DateTime(2022, 11, 30);
        var entry = Entry(
          null,
          null,
          datetime
        );
        return EntryScreen(entry: entry);
      })
    );
  }

  void _addEntry(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (BuildContext context) {
        var datetime = DateTime(2022, 11, 30);
        var entry = Entry(
          null,
          null,
          datetime,
        );
        return EntryScreen(entry: entry);
      })
    );
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
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        return _entryCard(context);
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
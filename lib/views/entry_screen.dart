import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({Key? key}): super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreen();
}

class _EntryScreen extends State<EntryScreen> {
  Widget _bottomToolBar() {
    return Container(
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
                children: const [
                  Icon(CupertinoIcons.calendar),
                  Text(' Friday 30, 2022')
                ],
              ),
              onPressed: () {},
            ),
          ],
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
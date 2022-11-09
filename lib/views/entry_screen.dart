import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({Key? key}): super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreen();
}

class _EntryScreen extends State<EntryScreen> {
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
              Expanded(
                child: Column(
                  children: [
                    const CupertinoTextField(
                      placeholder: 'Title',
                      padding: EdgeInsets.symmetric(vertical: 20),
                      style: TextStyle(fontSize: 30),
                    ),
                    Row(
                      children: const [
                        Text(
                          'Reykjavik,\nIceland',
                          style: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Cloudy',
                          style: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    CupertinoTextField(
                        placeholder: 'Body',
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 8,
                      ),
                  ],
                )
              ),
              Container(
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
                            Icon(CupertinoIcons.calendar),
                            Text(' Friday 30, 2022')
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
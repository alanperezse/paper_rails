import 'package:flutter/cupertino.dart';

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
          middle: const Text('Entry'),
          trailing: Icon(CupertinoIcons.ellipsis),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Reykjavik, Iceland'),
                    Row(
                      children: [
                        Text('Reykjavik, Iceland'),
                        Spacer(),
                        Text('Cloudy'),
                      ],
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
                            Text(' 12/12/2022')
                          ],
                        ),
                        onPressed: () {},
                      ),
                      Spacer(),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.time),
                            Text(' 12:00PM')
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
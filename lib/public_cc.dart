
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
class publicCC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListCard(),
            ListCard(),
            ListCard(),
            ListCard(),
            ListCard(),
            ListCard(),
            ListCard(),
            ListCard(),
            ListCard(),
          ]
        ),
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  const ListCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('Tapped!');
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('【更新】112學年度各大學招生資訊(非學校集體報名者)',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 0,bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('教務處',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
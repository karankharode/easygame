import 'package:easygame/LuckyDrawPage/controller/services/ballBorderService.dart';
import 'package:easygame/LuckyDrawPage/models/pastDraws.dart';
import 'package:easygame/LuckyDrawPage/widgets/smallLuckyDrawBalls.dart';
import 'package:easygame/common/widgets/loaderForStreamBuilder.dart';
import 'package:easygame/common/widgets/topCoinsWidget.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

List<PastDraws> pastDraws = [];

class PastDraw extends StatefulWidget {
  const PastDraw({Key key}) : super(key: key);

  @override
  _PastDrawState createState() => _PastDrawState();
}

class _PastDrawState extends State<PastDraw> {
  double height, width;

  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    databaseReference = FirebaseDatabase.instance.reference();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    int drawNo = 1;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Image.asset(
            'assets/branding/logo.png',
            fit: BoxFit.scaleDown,
            width: 180,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorPrimary,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            Column(children: [
              Container(
                height: 75,
                color: colorPrimary,
              ),
              Container(
                  height: height - 65 - 80,
                  color: bgColor,
                  child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 58, bottom: 20, left: 12, right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                            child: Text(
                              'Past Draw',
                              style: headingStyle,
                            ),
                          ),
                          StreamBuilder(
                            stream: databaseReference.child('LuckyDraw').child('PastDraws').onValue,
                            initialData:
                                databaseReference.child('LuckyDraw').child('PastDraws').onValue,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                case ConnectionState.none:
                                  // return a loader
                                  return loader(height);
                                case ConnectionState.active:
                                  if (snapshot.hasData) {
                                    pastDraws.clear();
                                    var data = snapshot.data.snapshot.value;

                                    data.forEach((key, value) {
                                      String time = '';
                                      try {
                                        time =
                                            Jiffy(value['Info']['time'], 'yyyy-MM-dd hh:mm:ss aa')
                                                .format('hh:mm aa')
                                                .toString();
                                      } catch (e) {
                                        try {
                                          time = Jiffy(value['Info']['time'], 'yyyy-MM-dd hh:mm aa')
                                              .format('hh:mm aa')
                                              .toString();
                                        } catch (e) {
                                          try {
                                            time = value['Info']['time']
                                                .toString()
                                                .trim()
                                                .split(' ')
                                                .removeAt(1)
                                                .toString()
                                                .toString();
                                          } catch (e) {
                                            time = '';
                                          }
                                        }
                                      }
                                      pastDraws.add(PastDraws(
                                        value['Info']['string'],
                                        value['Info']['winningCriteria'],
                                        time,
                                        value['Winners']['first'],
                                        value['Winners']['second'],
                                        value['Winners']['third'],
                                        key.toString(),
                                        value['Info']['time']
                                            .toString()
                                            .split(' ')
                                            .first
                                            .toString(),
                                      ));
                                    });
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                                      child: DataTable(
                                        columnSpacing: 30,
                                        horizontalMargin: 10,
                                        columns: [
                                          DataColumn(
                                              label: Text('Draw No.', style: columnNameStyle)),
                                          DataColumn(label: Text('Date', style: columnNameStyle)),
                                          DataColumn(label: Text('Time', style: columnNameStyle)),
                                          DataColumn(
                                              label: Text('Winning No.', style: columnNameStyle)),
                                          DataColumn(
                                              label:
                                                  Text('Jackpot Winner', style: columnNameStyle)),
                                          DataColumn(
                                              label:
                                                  Text('5 numbers winner', style: columnNameStyle)),
                                          DataColumn(
                                              label:
                                                  Text('4 numbers winner', style: columnNameStyle)),
                                        ],
                                        rows: [
                                          ...pastDraws.map(
                                            (e) => DataRow(cells: [
                                              DataCell(
                                                Center(child: Text((drawNo++).toString() + ' )')),
                                              ),
                                              DataCell(Text(e.date)),
                                              DataCell(Text(e.time)),
                                              DataCell(Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  ...e.drawString.characters.toList().map(
                                                        (f) => Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 2.0),
                                                          child: SmallLuckyDrawBall(
                                                              number: f.toString(),
                                                              borderColor: getBalBorderColor(e
                                                                  .drawString.characters
                                                                  .toList()
                                                                  .indexOf(f))),
                                                        ),
                                                      )
                                                ],
                                              )),
                                              DataCell(Text(e.first.toString())),
                                              DataCell(Text(e.second)),
                                              DataCell(Text(e.third)),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    // return not found or loader
                                    return loader(height);
                                  }
                                  break;
                                default:
                                  return loader(height);
                                // return a loader
                              }
                            },
                          ),
                        ],
                      )))
            ]),
            topCoinsWidget()
          ],
        ),
      ),
    );
  }
}

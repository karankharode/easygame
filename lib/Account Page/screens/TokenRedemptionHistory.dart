import 'package:easygame/Account%20Page/controller/tableBuilderMethods.dart';
import 'package:easygame/TokenRedemption/models/Token.dart';
import 'package:easygame/common/widgets/notFoundWidget.dart';
import 'package:easygame/common/widgets/topCoinsWidget.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

List<RedeemedToken> redeemedTokenList = [];

class TokenRedemptionHistory extends StatefulWidget {
  const TokenRedemptionHistory({Key key}) : super(key: key);

  @override
  _TokenRedemptionHistoryState createState() => _TokenRedemptionHistoryState();
}

class _TokenRedemptionHistoryState extends State<TokenRedemptionHistory> {
  double height, width;

  int drawNo = 1;

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
                              'Token Redemption History',
                              style: headingStyle,
                            ),
                          ),
                          StreamBuilder(
                              stream: databaseReference
                                  .child('Users')
                                  .child(FirebaseAuth.instance.currentUser.uid.toString())
                                  .child('TokenRedemptionHistory')
                                  .onValue,
                              initialData: databaseReference
                                  .child('Users')
                                  .child(FirebaseAuth.instance.currentUser.uid.toString())
                                  .child('TokenRedemptionHistory')
                                  .onValue,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                  case ConnectionState.none:
                                    return Center(child: CircularProgressIndicator());
                                    break;
                                  case ConnectionState.active:
                                    if (snapshot.hasData || snapshot.data.snapshot.value != null) {
                                      var data = snapshot.data.snapshot.value;
                                      if (data != null) {
                                        redeemedTokenList.clear();
                                        data.forEach((key, value) {
                                          redeemedTokenList.add(RedeemedToken(
                                            name: value['name'],
                                            tokenId: key.toString(),
                                            image: value['image'],
                                            descriptioin: value['description'],
                                            qty: value['quantity'],
                                            value: value['value'],
                                            status: value['status'],
                                            date: value['date'] ?? '',
                                            time: value['time'] ?? Jiffy().format('hh:mm aa'),
                                          ));
                                        });
                                      } else {
                                        redeemedTokenList.clear();
                                      }
                                      return redeemedTokenList.length != 0
                                          ? SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                                              child: DataTable(
                                                columnSpacing: 35,
                                                columns: [
                                                  DataColumn(
                                                      label: Text('No.', style: columnNameStyle)),
                                                  DataColumn(
                                                      label: Text('Date', style: columnNameStyle)),
                                                  DataColumn(
                                                      label: Text('Time', style: columnNameStyle)),
                                                  DataColumn(
                                                      label: Text('Items', style: columnNameStyle)),
                                                  DataColumn(
                                                      label: Text('Qty', style: columnNameStyle)),
                                                  DataColumn(
                                                      label: Text('Description',
                                                          style: columnNameStyle)),
                                                  DataColumn(
                                                      label: Text('      Status',
                                                          style: columnNameStyle)),
                                                ],
                                                rows: [
                                                  ...redeemedTokenList.map(
                                                    (e) => DataRow(cells: [
                                                      DataCell(
                                                        Text((drawNo++).toString() + ' )'),
                                                      ),
                                                      DataCell(Text(e.date)),
                                                      DataCell(Text(
                                                          e.time ?? Jiffy().format('hh:mm aa'))),
                                                      DataCell(Center(
                                                        child: Image.network(
                                                          e.image,
                                                          height: 22,
                                                        ),
                                                      )),
                                                      DataCell(Text(e.qty.toString())),
                                                      DataCell(Text(e.descriptioin)),
                                                      DataCell(getStatus(e.status)),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : notFoundWidget(
                                              height: height, text: 'No History yet !');
                                    } else {
                                      return Container();
                                    }
                                    break;
                                  default:
                                    return CircularProgressIndicator();
                                }
                              }),
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

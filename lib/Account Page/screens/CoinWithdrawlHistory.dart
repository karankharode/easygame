import 'package:easygame/Account%20Page/models/coinTokenHistory.dart';
import 'package:easygame/Account%20Page/widgets/notFoundWidget.dart';
import 'package:easygame/common/widgets/topCoinsWidget.dart';
import 'package:easygame/constants/colors.dart';
import 'package:easygame/constants/styles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CoinWithdrawlHistory extends StatefulWidget {
  final int coinToken;
  final DatabaseReference databaseReference;
  const CoinWithdrawlHistory({
    Key key,
    @required this.databaseReference,
    @required this.coinToken,
  }) : super(key: key);

  @override
  _CoinWithdrawlHistoryState createState() =>
      _CoinWithdrawlHistoryState(databaseReference, coinToken);
}

class _CoinWithdrawlHistoryState extends State<CoinWithdrawlHistory> {
  final DatabaseReference databaseReference;
  final int coinToken;
  _CoinWithdrawlHistoryState(
    this.databaseReference,
    this.coinToken,
  );
  double height, width;
  int drawNo = 1;
  List<CoinTokenHistory> historyList = [];

  String getType(int val) {
    switch (val) {
      case 1:
        return 'Credit';
      case -1:
        return 'Debit';
      default:
        return 'Debit';
    }
  }

  String getCoinOrToken(int val) {
    switch (val) {
      case 1:
        return 'Coin';
      case 2:
        return 'Token';
      default:
        return 'Token';
    }
  }

  @override
  void initState() {
    super.initState();
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              '${getCoinOrToken(coinToken)}  History',
                              style: headingStyle,
                            ),
                          ),
                          StreamBuilder(
                              stream: databaseReference.onValue,
                              initialData: databaseReference.onValue,
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
                                        historyList.clear();
                                        data.forEach((key, value) {
                                          historyList.add(CoinTokenHistory(
                                              date: value['date'],
                                              time: value['time'],
                                              qty: value['qty'].toString(),
                                              type: value['type'],
                                              balance: value['balance'].toString()));
                                        });
                                      } else {
                                        historyList.clear();
                                      }
                                      return historyList.length != 0
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
                                                      label: Text('Qty', style: columnNameStyle)),
                                                  DataColumn(
                                                      label: Text('Type', style: columnNameStyle)),
                                                  DataColumn(
                                                      label:
                                                          Text('Balance', style: columnNameStyle)),
                                                ],
                                                rows: [
                                                  ...historyList.map(
                                                    (e) => DataRow(cells: [
                                                      DataCell(
                                                        Text((drawNo++).toString() + ' )'),
                                                      ),
                                                      DataCell(Text(e.date)),
                                                      DataCell(Text(e.time)),
                                                      DataCell(
                                                        Text(
                                                          e.qty.toString(),
                                                          style: TextStyle(
                                                              color: e.type == 1
                                                                  ? Colors.green
                                                                  : Colors.red),
                                                        ),
                                                      ),
                                                      DataCell(Text(getType(e.type))),
                                                      DataCell(Text(e.balance.toString())),
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

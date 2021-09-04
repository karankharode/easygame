import 'package:easygame/constants/colors.dart';
import 'package:flutter/material.dart';

typedef void CountButtonClickCallBack(int count);

class CountButtonView extends StatefulWidget {
  final int initialCount;
  final CountButtonClickCallBack onChange;

  CountButtonView({this.initialCount, this.onChange});

  @override
  _CountButtonViewState createState() => _CountButtonViewState();
}

class _CountButtonViewState extends State<CountButtonView> {
  int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialCount;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateCount(int addValue) {
    if (count + addValue >= 0) {
      setState(() {
        count += addValue;
      });
      if (widget.onChange != null) {
        widget.onChange(count);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: SizedBox(
        height: 25,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xddFFFFFF),
              border: Border.all(color: colorPrimary, width: 1.0),
              borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    updateCount(-1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2.0, left: 3),
                    child: Container(child: Center(child: Icon(Icons.remove, color: colorPrimary))),
                  )),
              Expanded(
                child: Text("|", style: TextStyle(color: colorPrimary)),
              ),
              Text(
                ' $count ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: colorPrimary,
                    decoration: TextDecoration.none),
              ),
              Expanded(child: Text("|", style: TextStyle(color: colorPrimary))),
              GestureDetector(
                  onTap: () {
                    updateCount(1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2.0, right: 3),
                    child: Container(child: Center(child: Icon(Icons.add, color: colorPrimary))),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

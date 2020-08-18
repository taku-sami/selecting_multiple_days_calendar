import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final PageController pageController = PageController(initialPage: 12);
  List<DateTime> selectedDateList = [];
  List<Widget> calendarList = [];
  DateTime now = DateTime.now();
  int monthDuration = 0;

  final double itemHeight = 45.0;

  @override
  Widget build(BuildContext context) {
    buildCalendarList(now);

    return Scaffold(
        appBar: AppBar(
          title: Text('Selecting multiple days'),
          backgroundColor: Colors.grey,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PageView(
            onPageChanged: (pageId) {},
            controller: pageController,
            children: calendarList,
          ),
        ));
  }

  void buildCalendarList(DateTime now) {
    int numberOfMonth = 40;

    for (int i = 0; i < numberOfMonth; i++) {
      print(i);
      calendarList.add(buildCalendar(DateTime(now.year, now.month + i - 12, 1), i));
    }
  }

  Widget buildCalendar(DateTime month, int number) {
    List<Widget> _list = [];

    _list.add(
      Container(
        height: 100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.arrow_left,
                size: 50.0,
              ),
              onTap: () {
                monthDuration--;
                setState(() {});
              },
            ),
            Text(
              DateFormat('yyyy年M月').format(DateTime(now.year, now.month + number - 12, 1)),
              style: TextStyle(fontSize: 22.0),
            ),
            GestureDetector(
              child: Icon(
                Icons.arrow_right,
                size: 50.0,
              ),
              onTap: () {
                monthDuration++;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );

    List<String> _dayOfTheWeek = ['日', '月', '火', '水', '木', '金', '土'];
    List<Widget> _weekList = [];
    for (int i = 0; i < 7; i++) {
      _weekList.add(Expanded(
        child: Container(
          child: Text(
            _dayOfTheWeek[i],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ));
    }
    _list.add(
      Row(
        children: _weekList,
      ),
    );

    DateTime _now = DateTime(month.year, month.month + monthDuration, 1);
    int monthLastNumber = DateTime(_now.year, _now.month + 1, 1).add(Duration(days: -1)).day;
    List<Widget> _listCache = [];
    for (int i = 1; i <= monthLastNumber; i++) {
      _listCache.add(Expanded(
        child: buildCalendarItem(i, DateTime(_now.year, _now.month, i)),
      ));

      if (DateTime(_now.year, _now.month, i).weekday == 6 || i == monthLastNumber) {
        int repeatNumber = 7 - _listCache.length;
        for (int j = 0; j < repeatNumber; j++) {
          if (DateTime(_now.year, _now.month, i).day <= 7) {
            _listCache.insert(
                0,
                Expanded(
                  child: Container(height: itemHeight),
                ));
          } else {
            _listCache.add(Expanded(
              child: Container(
                height: itemHeight,
              ),
            ));
          }
        }

        _list.add(Row(
          children: _listCache,
        ));
        _listCache = [];
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: _list,
      ),
    );
  }

  Widget buildCalendarItem(int i, DateTime selectedDate) {
    if (selectedDateList.contains(selectedDate)) {
      return InkWell(
        child: CircleAvatar(
          radius: 18,
          backgroundColor: (selectedDateList.contains(selectedDate)) ? Colors.redAccent : Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            height: itemHeight,
            child: Text(
              '$i',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  color: (selectedDateList.contains(selectedDate)) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        onTap: () {
          selectedDateList.remove(selectedDate);
          setState(() {});
        },
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        height: itemHeight,
        child: Text(
          '$i',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      onTap: () {
        selectedDateList.add(selectedDate);
        setState(() {});
        selectedDateList.sort((a, b) {
          return a.compareTo(b);
        });
        for (var date in selectedDateList) {
          print('${DateFormat('yyyy年M月d日').format(date)}が選択されました');
        }
        print(selectedDateList.length.toString());
      },
    );
  }
}

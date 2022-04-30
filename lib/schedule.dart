import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter with ChangeNotifier {
  String _count = '';
  final List _days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  final List _times = ['MRNG', 'AFTN', 'EVEN'];
  final List _stringList = [];

  String get count => _count;

  void setString(String cnt) {
    _count += cnt;
    notifyListeners();
  }

  void setTime(time, day) {
    int index = _days.indexOf(day);
    String arry = _stringList[index];
    if (arry.isNotEmpty) {
      _stringList[index] +=
          time + (_stringList[index].length == 17 ? "," : " ");
      notifyListeners();
    }
  }

  void setDay(day) {
    _stringList.add("");
    int index = _stringList.indexWhere((element) => element == "");
    String arry = _stringList[index];
    if (arry.isEmpty) {
      _stringList[index] += day + " ";
      notifyListeners();
    }
  }
}

class Schedule extends StatelessWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Set Your weekly hours',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          for (final day in context.read<Counter>()._days)
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 130,
                  child: CheckboxListTile(
                    dense: false,
                    title: Text(day),
                    value: false,
                    onChanged: (bool? value) {
                      context.read<Counter>().setDay(day);
                    },
                  ),
                ),
                for (final time in context.read<Counter>()._times)
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: FilterChip(
                      label: Text(time),
                      selected: false,
                      onSelected: (bool value) {
                        context.read<Counter>().setTime(time, day);
                      },
                    ),
                  ),
              ],
            ),
          const Count()
        ],
      ),
    );
  }
}

class Count extends StatelessWidget {
  const Count({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.watch<Counter>()._stringList.join(','),
      key: const Key('counterState'),
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

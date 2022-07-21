import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/db_controller.dart';
import '../controllers/http_controller.dart';
import '../models/visit.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final DBController _dbController = DBController.instance;
  final HttpController _httpController = HttpController.instance;
  final DateFormat formatterDate = DateFormat('dd-MM-yyyy');
  final DateFormat formatterWeekDay = DateFormat('E');
  late Future<List<Visit>> _futureVisits;

  @override
  void initState() {
    _futureVisits = _httpController.getVisits(_dbController.getSportsman()!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return FutureBuilder<List<Visit>>(
        future: _futureVisits,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(
                    color: Colors.deepOrangeAccent, strokeWidth: 5),
              );
            default:
              if (snapshot.hasError) {
                throw snapshot.error!;
              }
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return listView(snapshot.data!);
              } else {
                return emptyMess();
              }
          }
        });
  }

  ListView listView(List<Visit> visits) {
    return ListView.builder(
        itemCount: visits.length,
        itemBuilder: (context, index) {
          return Card(
            color: Theme.of(context).primaryColor.withOpacity(0.75),
            child: ListTile(
              leading: Text(
                formatterWeekDay.format(visits[index].date),
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              title: Text(formatterDate.format(visits[index].date)),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          );
        });
  }

  Center emptyMess() {
    return const Center(
        child: Text(
      'History is empty',
      style: TextStyle(fontSize: 23.0),
    ));
  }
}

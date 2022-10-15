import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../pages/training_list/training_edit.dart';
import '../../pages/training_list/widgets/add_button.dart';
import '../../services/db/training_db_service.dart';
import '../../models/training.dart';

class TrainingList extends StatefulWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  State<TrainingList> createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList> {
  final TrainingDBService _dbService = TrainingDBService();
  late List<Training> _trainings;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    _trainings = _dbService.getAll();

    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training List'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 5),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/training_list.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
            opacity: 0.6,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildList(context),
              AddButton(
                  text: 'Add training',
                  onTap: () => creationDialog(),
                  highlightColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context) {
    if (_trainings.isEmpty) {
      return Container();
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _trainings.length,
        itemBuilder: (_, index) {
          return Card(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            elevation: 2.0,
            child: ListTile(
              title: Text('${_trainings[index].name}',
                  style: const TextStyle(fontSize: 19)),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deletionDialog(index),
              ),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TrainingEdit(training: _trainings[index])));
                setState(() {
                  _trainings = _dbService.getAll();
                });
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          );
        });
  }

  Future creationDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Training'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Name',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2)),
              ),
              controller: nameController,
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            actions: [
              TextButton(
                child: const Text('Add',
                    style: TextStyle(color: mainColor, fontSize: 18)),
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrainingEdit(
                              training: Training(
                                  name: nameController.text.trim(),
                                  exercises: List.empty(growable: true)))));
                  nameController.clear();
                  setState(() {
                    _trainings = _dbService.getAll();
                  });
                },
              )
            ],
          ));

  deletionDialog(int index) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmation'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)),
          content: const Text('Are you sure?'),
          backgroundColor: Theme.of(context).backgroundColor,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No',
                  style: TextStyle(color: mainColor, fontSize: 18)),
            ),
            TextButton(
              onPressed: () async {
                _dbService.delete(_trainings[index]);
                setState(() {
                  _trainings = _dbService.getAll();
                });
                Navigator.pop(context);
              },
              child: const Text('Yes',
                  style: TextStyle(color: mainColor, fontSize: 18)),
            ),
          ],
        ),
      );
}

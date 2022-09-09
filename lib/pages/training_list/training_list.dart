import 'package:flutter/material.dart';
import 'package:sportmen_in_gym/pages/training_list/training_edit.dart';

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
    _trainings = _dbService.getAll();

    nameController = TextEditingController();

    super.initState();
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
        child: Column(
          children: [
            buildList(context),
            InkWell(
              child: Card(
                color: Theme.of(context).primaryColor.withOpacity(0.75),
                elevation: 4.0,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add),
                      Text('Add training', style: TextStyle(fontSize: 19)),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onTap: () {
                openDialog();
              },
              splashColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList(BuildContext context) {
    if (_trainings.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _trainings.length,
          itemBuilder: (_, index) {
            return Card(
              color: Theme.of(context).primaryColor.withOpacity(0.75),
              elevation: 4.0,
              child: ListTile(
                title: Text('${_trainings[index].name}',
                    style: const TextStyle(fontSize: 19)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
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
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            );
          });
    } else {
      return Container();
    }
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Training'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
              controller: nameController,
            ),
            actions: [
              TextButton(
                child: const Text('Continue'),
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrainingEdit(
                              training: Training(
                                  name: nameController.text.trim(),
                                  exercises: List.empty()))));
                  nameController.clear();
                  setState(() {
                    _trainings = _dbService.getAll();
                  });
                },
              )
            ],
          ));
}
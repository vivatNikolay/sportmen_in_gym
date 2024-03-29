import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../../helpers/constants.dart';
import '../../../../models/exercise.dart';
import '../../../../services/exercise_fire.dart';
import '../../../widgets/floating_add_button.dart';
import 'widgets/training_card.dart';
import 'exercise_edit.dart';

final ExerciseFire _exerciseFire = ExerciseFire();

class TrainingEdit extends StatelessWidget {
  final String trainingId;
  final String trainingName;

  const TrainingEdit(this.trainingId, this.trainingName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(trainingListImage),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(trainingName),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingAddButton(
          text: 'addExercise'.i18n(),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ExerciseEdit(trainingId: trainingId))),
        ),
        body: StreamBuilder(
            stream: _exerciseFire.streamByTrainingId(trainingId),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('exerciseDidNotLoad'.i18n()));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Exercise> exercises = List.from(snapshot.data!.docs)
                .map((i) => Exercise.fromDocument(i))
                .toList();
            return SingleChildScrollView(
                child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exercises.length,
                    itemBuilder: (_, index) {
                      return TrainingCard(
                        title: exercises[index].name,
                        subtitle:
                            '${exercises[index].reps} / ${exercises[index].sets}',
                        onDelete: () => _deleteExercise(exercises[index].id!),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ExerciseEdit(
                                    trainingId: trainingId,
                                    exercise: exercises[index]))),
                      );
                    }),
            );
          }
        ),
      ),
    );
  }

  Future<void> _deleteExercise(String id) async {
    await _exerciseFire.delete(id);
  }
}

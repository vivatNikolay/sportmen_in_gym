import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../helpers/constants.dart';
import '../../models/exercise.dart';
import '../widgets/my_text_field.dart';

class ExerciseEdit extends StatefulWidget {
  final ValueNotifier<Exercise> exercise;

  const ExerciseEdit({required this.exercise, Key? key}) : super(key: key);

  @override
  State<ExerciseEdit> createState() => _ExerciseEditState();
}

class _ExerciseEditState extends State<ExerciseEdit> {
  late ValueNotifier<Exercise> exercise;
  final TextEditingController _exerciseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    exercise = widget.exercise;
    _exerciseController.text = exercise.value.name;
    _exerciseController.addListener(_controllerListener);
  }

  void _controllerListener() {
    if (_exerciseController.text.isNotEmpty) {
      setState(() {
        exercise.value.name = _exerciseController.text;
      });
    }
  }

  @override
  void dispose() {
    _exerciseController.removeListener(_controllerListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Упражнение'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              MyTextField(
                autofocus: _exerciseController.text.isEmpty,
                controller: _exerciseController,
                validation: ValueNotifier(true),
                fieldName: 'Название',
              ),
              const SizedBox(height: 15),
              const Text('Кол-во сетов:', style: TextStyle(fontSize: 15)),
              SfSlider(
                min: 0,
                max: 10,
                interval: 5,
                showLabels: true,
                enableTooltip: true,
                activeColor: mainColor,
                value: exercise.value.sets.toDouble(),
                onChanged: (value) {
                  setState(() {
                    exercise.value.sets = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 15),
              const Text('Кол-во повторений:', style: TextStyle(fontSize: 15)),
              SfSlider(
                min: 0,
                max: 30,
                interval: 10,
                showLabels: true,
                enableTooltip: true,
                activeColor: mainColor,
                value: exercise.value.reps.toDouble(),
                onChanged: (value) {
                  setState(() {
                    exercise.value.reps = value.toInt();
                  });
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

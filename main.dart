import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

//Different units for weight input
enum WeightOptions { pounds, kilograms }

class bmiOutput extends StatefulWidget {
  bmiOutput({required double this.bmi});
  double bmi;

  @override
  State<bmiOutput> createState() => _bmiOutputState(bmi: bmi);
}

class _bmiOutputState extends State<bmiOutput> {
  _bmiOutputState({required double this.bmi});
  double bmi;

  void updateBMI(double newVal) {
    setState(() {
      bmi = newVal;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(home: Text('Your BMI is: $bmi'));
  }
}

//State to return user input for weight
class _WeightSelectorState extends State<WeightSelector> {
  _WeightSelectorState({required this.onUnitChanged}) {}
  WeightOptions? _unit = WeightOptions.pounds;
  final ValueChanged<WeightOptions?> onUnitChanged;

  WeightOptions? getSelection() {
    return _unit;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: SizedBox(
                height: 50,
                child: ListTile(
                  title: const Text('lb',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                  leading: Radio<WeightOptions>(
                    value: WeightOptions.pounds,
                    groupValue: _unit,
                    onChanged: (WeightOptions? value) {
                      onUnitChanged(value);
                      setState(() {
                        _unit = value;
                      });
                    },
                  ),
                ))),
        Expanded(
            child: SizedBox(
                height: 50,
                child: ListTile(
                  title: const Text('kg',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                  leading: Radio<WeightOptions>(
                    value: WeightOptions.kilograms,
                    groupValue: _unit,
                    onChanged: (WeightOptions? value) {
                      onUnitChanged(value);
                      setState(() {
                        _unit = value;
                      });
                    },
                  ),
                ))),
      ],
    );
  }
}

class WeightSelector extends StatefulWidget {
  WeightSelector({
    super.key,
    required this.onUnitChanged,
  });
  WeightOptions? _unit;
  final ValueChanged<WeightOptions?> onUnitChanged;


  @override
  State<WeightSelector> createState() => _WeightSelectorState(
        onUnitChanged: (value) => onUnitChanged(value),
      );
}

//Different units for height input
enum HeightOptions { inches, centimeters }

//State to return user input for height
class _HeightSelectorState extends State<HeightSelector> {
  _HeightSelectorState({required this.onUnitChanged}) {}
  final ValueChanged<HeightOptions?> onUnitChanged;
  HeightOptions? _unit = HeightOptions.inches;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: SizedBox(
                height: 50,
                child: ListTile(
                  title: const Text('in',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                  leading: Radio<HeightOptions>(
                    value: HeightOptions.inches,
                    groupValue: _unit,
                    onChanged: (HeightOptions? value) {
                      onUnitChanged(value);
                      setState(() {
                        _unit = value;
                      });
                    },
                  ),
                ))),
        Expanded(
            child: SizedBox(
                height: 50,
                child: ListTile(
                  title: const Text('cm',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                  leading: Radio<HeightOptions>(
                    value: HeightOptions.centimeters,
                    groupValue: _unit,
                    onChanged: (HeightOptions? value) {
                      onUnitChanged(value);
                      setState(() {
                        _unit = value;
                      });
                    },
                  ),
                ))),
      ],
    );
  }
}

class HeightSelector extends StatefulWidget {
  const HeightSelector({super.key, required this.onUnitChanged});
  final ValueChanged<HeightOptions?> onUnitChanged;

  @override
  State<HeightSelector> createState() =>
      _HeightSelectorState(onUnitChanged: (value) => onUnitChanged(value));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  State<MyApp> createState() => _myAppState();
  // This widget is the root of your application.
}

class _myAppState extends State<MyApp> {
  double currentBmi = 0.0;
  void updateBMI(double newVal) {
    setState(() {
      currentBmi = newVal;
    });
  }

  TextEditingController heightTextController = TextEditingController();
  TextEditingController weightTextController = TextEditingController();
  Widget build(BuildContext context) {
    bmiOutput bmi = bmiOutput(bmi: 0.0);
    String calculatedBMI = '';
    double? inputHeight;
    double? inputWeight;
    WeightOptions? activeWeightUnit = WeightOptions.pounds;
    WeightSelector weightSelector =
        WeightSelector(onUnitChanged: (e) => activeWeightUnit = e);
    HeightOptions? activeHeightUnit = HeightOptions.inches;
    HeightSelector heightSelector =
        HeightSelector(onUnitChanged: (e) => activeHeightUnit = e);

    //Method to calculate BMI based on user input
    double? calcBMI() {
      // displayError = (inputHeight == null || inputWeight == null) ? true : false
      bool displayError = false;
      if (inputHeight == null || inputWeight == null) {
        displayError = true;
        return null;
      }
      double standardWeight;
      double standardHeight;
      if (activeWeightUnit == WeightOptions.pounds) {
        standardWeight = inputWeight! * .45;
      } else {
        standardWeight = inputWeight!;
      }

      if (activeHeightUnit == HeightOptions.inches) {
        standardHeight = inputHeight! * .0254;
      } else {
        standardHeight = inputHeight! / 100;
      }

      return standardWeight / (standardHeight * standardHeight);
    }
    //Anonymous function to determine bmi category
    var det = (double currentBmi) {
      if (currentBmi < 18.5) {
        return ("underweight");
      } else if (currentBmi >= 18.5 && currentBmi < 24.9) {
        return ("healthy");
      } else if (currentBmi >= 25 && currentBmi < 29.9) {
        return ("overweight");
      } else if (currentBmi >= 30 && currentBmi < 39.9) {
        return ("obese");
      } else {
        return ("extremely obese");
      }
    };
    return MaterialApp(home: Builder(builder: (context) {
      return Scaffold(
          backgroundColor: Color.fromARGB(255, 2, 12, 149),
          appBar: AppBar(
              centerTitle: true,
              title: Text('BMI Calculator',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              backgroundColor: Color.fromARGB(255, 2, 9, 96)),
          body: Center(
            child: SizedBox(
                width: 600,
                child: Column(children: [
                  SizedBox(height: 40),
                  Text('Enter your height:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255))),
                  heightSelector,
                  TextField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Color.fromARGB(255, 255, 255, 255),
                      onChanged: (value) {
                        inputHeight = double.tryParse(value);
                      },
                      controller: heightTextController),
                  SizedBox(height: 10),
                  Text('Enter your weight:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      )),
                  weightSelector,
                  TextField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Color.fromARGB(255, 255, 255, 255),
                      onChanged: (value) {
                        inputWeight = double.tryParse(value);
                      },
                      controller: weightTextController),
                  SizedBox(height: 30),
                  ElevatedButton(
                    child: Text('Submit',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    onPressed: () {
                      if (calcBMI() == null) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text(
                                style: TextStyle(color: Colors.red), 'Error!'),
                            content: const Text('Invalid input entered.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        updateBMI(calcBMI()!);
                      }
                      weightTextController.clearComposing();
                      heightTextController.clearComposing();
                      weightTextController.clear();
                      heightTextController.clear();
                    },
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Color.fromARGB(255, 139, 226, 229),
                    thickness: 2.5,
                    endIndent: 0.0,
                  ),
                  SizedBox(height: 20),
                  Text('Your BMI is: ${currentBmi.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                    'Categories:',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'Underweight: < 18.5',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'Healthy Range: 18.5 - 24.9',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'Overweight: 25-29.9',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'Obese: 30 - 39.9',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontStyle: FontStyle.italic),
                  ),
                  Text('Extremely Obese: > 40',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontStyle: FontStyle.italic)),
                  Text('You are currently ${det(currentBmi)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 20),
                  Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          child: Text('Copy to Clipboard',
                              style: TextStyle(
                                fontSize: 15,
                              )),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text:
                                    'My BMI is  ${currentBmi.toStringAsFixed(2)}'));
                          },
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green)))
                ])),
          ));
    }));
  }
}

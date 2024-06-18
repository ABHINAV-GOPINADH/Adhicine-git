import 'package:adhicine/components/medicine.dart';
import 'package:adhicine/services/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> AddMedicine(BuildContext context) async {
  final AuthService _auth = AuthService();
  String userId = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController name = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController total = TextEditingController(text: '1');
  Color selectedColor = Colors.pink;
  int selectCompartment = 1;
  String selectedType = 'tablet';
  String? times = "Three Times";

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      String startDate = "Today";
      String endDate = "Today";

      return StatefulBuilder(
        builder: (context, setState) {
          int totalValue = int.parse(total.text);

          return AlertDialog(
            title: Center(child: Text('Add Medicine')),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                        labelText: 'Search medicine here!',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Compartment"),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10.0,
                      children: List<Widget>.generate(6, (int index) {
                        return ChoiceChip(
                          label: Text('${index + 1}'),
                          selected: selectCompartment == index + 1,
                          onSelected: (bool selected) {
                            setState(() {
                              selectCompartment = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 10),
                    Text("Colors"),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        Colors.pink,
                        Colors.purple,
                        Colors.red,
                        Colors.green,
                        Colors.orange,
                        Colors.blue,
                      ].map((Color color) {
                        return ChoiceChip(
                          backgroundColor: color,
                          label: Text(''),
                          selected: selectedColor == color,
                          onSelected: (bool Selected) {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    Text("Types"),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        'Tablet',
                        'Capsule',
                        'Cream',
                        'Liquid',
                      ].map((String type) {
                        return ChoiceChip(
                          label: Text(type),
                          selected: selectedType == type,
                          onSelected: (bool Selected) {
                            setState(() {
                              selectedType = type;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    Text("Quantity"),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: quantity,
                            decoration:
                            InputDecoration(hintText: 'Take 1/2 pill'),
                          ),
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Total Count"),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: totalValue.toDouble(),
                            min: 1,
                            max: 100,
                            divisions: 99,
                            onChanged: (value) {
                              setState(() {
                                totalValue = value.toInt();
                                total.text = totalValue.toString();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 50,
                          child: TextField(
                            controller: total,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: '01'),
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  totalValue = 1;
                                } else {
                                  totalValue = int.tryParse(value) ?? 1;
                                }
                                total.text = totalValue.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Set Date"),
                    SizedBox(height: 10),
                    Text('New Update'),
                    SizedBox(height: 10),
                    Text("Frequency of Days"),
                    DropdownButtonFormField<String>(
                      value: times,
                      items: [
                        'One Time',
                        'Two Time',
                        'Three Times',
                        'Four Times'
                      ].map((String time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (String? newTimes) {
                        setState(() {
                          times = newTimes;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Create Medicine object
                  Medicine newMedicine = Medicine(
                      name: name.text,
                      compartment: selectCompartment,
                      color: selectedColor,
                      type: selectedType,
                      quantity: quantity.text,
                      totalCount: totalValue,
                      frequency: times!);
                  // Save to Firestore
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(userId)
                      .collection('medicine')
                      .add(newMedicine.toMap());
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:quiz_app/screens/begin_start.dart';


import '../constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _quizCode;

  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');
      //mech testi testi kan code s7i7 w tzid players 
  Future<bool> checkQuizCodeExists(int quizCode, String playerName) async {
    final result =
        await quizzesCollection.where('quiz_code', isEqualTo: quizCode).get();

    if (result.docs.isNotEmpty) {
      final quizDoc = result.docs.first;
      await quizDoc.reference.update({
        'number_players': FieldValue.increment(1),
        'players': FieldValue.arrayUnion([
          {'name': playerName, 'score': 0}
        ])
      });

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 228, 235),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 32.0),
              
            Image(
              image: AssetImage('assets/images/login.png'),
              height: 200,
              width: 200,
            ),
             SizedBox(height: 32.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nom',
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {// test bach nom maykonich fara5
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;//return value 
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Code du quiz',
                  icon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {//houni test eli valeur mech fara5
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le code du quiz';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Le code de quiz ne doit contenir que des chiffres';
                  }
                  return null;
                },
                onSaved: (value) {
                  _quizCode = int.tryParse(value!);//bach ta3mil convertion chaine-int
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  primary:Color.fromARGB(255, 179, 91, 81),
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final quizExists =
                        await checkQuizCodeExists(_quizCode!, _name!);//appel ll fonction

                    if (quizExists) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BeginStartScreen(_name!, _quizCode!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Le code de quiz n\'existe pas.'),
                        ),
                      );
                    }
                  }
                },
                child: Text('Start le quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

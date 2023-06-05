import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BeginStartScreen extends StatefulWidget {
  final String name;
  final int quiz_code;

  BeginStartScreen(this.name, this.quiz_code, {Key? key}) : super(key: key);

  static const routeName = '/beginStartScreen';

  @override
  State<BeginStartScreen> createState() => _BeginStartScreenState();
}

class _BeginStartScreenState extends State<BeginStartScreen> {
  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');

  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
        backgroundColor:Color.fromARGB(255, 179, 91, 81),
      ),
      ////QuerySnapshot représente un instantané des données d'une requête sur une collection de documents Firestore.
      body: StreamBuilder<QuerySnapshot>(
        //stream tmadhile flux donnee 
        stream: quizzesCollection
            .where('quiz_code', isEqualTo: widget.quiz_code)
            .snapshots(),
            //kol matsir mise a jour fi donne builder est appelle
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Une erreur est survenue'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final quizDoc = snapshot.data!.docs.first;

          final questionSelected = quizDoc['questions'].firstWhere(//mech testi tchouf fi base kan true ou non
              (question) => question['question_selected'] == true,
              orElse: () => null);

          if (questionSelected == null && quizDoc['quiz_finished'] == false) {
            return Center(//kan mech true to5rij page load 
              child: CircularProgressIndicator(),
            );
          }

          if (questionSelected == null && quizDoc['quiz_finished'] == true) {
            //kanha true mech traja3 liste de joueurs 
            final playersList =
                List<Map<String, dynamic>>.from(quizDoc['players']);//liste.form tconverti mawjoude fi base ll liste selon langage dart 
            final user = playersList
                .firstWhere((player) => player['name'] == widget.name);
            ////classement
            return Center(
              child: Column(
                
             
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Image(
              image: AssetImage('assets/images/classement2.png'),
              height: 200,
              width: 200,
            ),
             SizedBox(height: 16.0),
                
                  SizedBox(height: 20),
                  Text('Votre Score:',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  Text('${user['score']}', style: TextStyle(fontSize: 48.0)),
                  SizedBox(height: 20),
                  Text('Votre Classment:',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  Text('${_getRank(playersList, widget.name)}',
                      style: TextStyle(fontSize: 48.0)),
                ],
              ),
            );
          }

          final optionA = questionSelected['option_a'];
          final optionB = questionSelected['option_b'];
          final optionC = questionSelected['option_c'];
          final correctAnswer = questionSelected['answer'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               SizedBox(height: 16),  
              Image(
                  image: AssetImage('assets/images/yes2.png'),
                  height: 200,
                  width: 200,
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  questionSelected['question'],
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 121, 210, 255),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(50, 20),
                    fixedSize: Size(200, 50),
                    //padding: EdgeInsets.symmetric(horizontal: 24.0),
                  ),
                  onPressed: () {
                    
                    print(optionA);
                    print(correctAnswer);
                    if (optionA == correctAnswer) {
                      _incrementScore();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 28),
                      Text(
                        optionA,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 121, 210, 255),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(50, 20),
                    fixedSize: Size(200, 50),
                    //padding: EdgeInsets.symmetric(horizontal: 24.0),
                  ),
                  onPressed: () {
                   
                    print(optionB);
                    print(correctAnswer);
                    if (optionB == correctAnswer) {
                      _incrementScore();//m3a kol button nhoto score
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 28),
                      Text(
                        optionB,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 121, 210, 255),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(50, 20),
                    fixedSize: Size(200, 50),
                    //padding: EdgeInsets.symmetric(horizontal: 24.0),
                  ),
                  onPressed: () {
                    
                    print(optionC);
                    print(correctAnswer);
                    if (optionC == correctAnswer) {
                      _incrementScore();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 28),
                      Text(
                        optionC,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Score: $score'),
            ],
          );
        },
      ),
    );
  }
  // fonction eli mech ti7sbilna rang 
  int _getRank(List<Map<String, dynamic>> players, String playerName) {
    players.sort((a, b) => b['score'].compareTo(a['score']));//ta3mil tri mta3 plaers selon score avec sort

    int rank = 1;
    for (int i = 0; i < players.length; i++) {//tparcouri liste de players selon nom
      final player = players[i];
      if (player['name'] == playerName) {//tcompari nom b eli fi liste w traja3 rang
        return rank;
      }
      if (i + 1 < players.length && players[i + 1]['score'] < player['score']) {
        rank = i + 2;
      }
    }
    return rank;
  }
  /////////////fonction pour calcule le score 
  Future<void> _incrementScore() async {
    setState(() {//score dima tzid b 10
      score += 10;
    });

    final result = await quizzesCollection //bach ya5rin quiz
        .where('quiz_code', isEqualTo: widget.quiz_code)
        .get();

    if (result.docs.isNotEmpty) {
      final quizDoc = result.docs.first;//mech ta5o donee mta3 quiz 
      final playersList = List<Map<String, dynamic>>.from(quizDoc['players']);//mech ya5rij liste de players 

      final playerIndex = playersList.indexWhere(//mech lawij 3la players X
        (player) => player['name'] == widget.name,
      );

      if (playerIndex != -1) {
        final player = playersList[playerIndex];
        playersList[playerIndex] = {//houni mech lawij 3la players ki yal9ah yupdate score
          'name': player['name'],
          'score': player['score'] + 10,
        };
      }

      await quizDoc.reference.update({
        'players': playersList,
      });
    }
  }
}

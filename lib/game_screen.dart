import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hangmangame/utils.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  AudioCache audioCache = AudioCache(prefix: "sounds/");
  String word = wordList[Random().nextInt(wordList.length)];
  List gustalphabets = [];
  int points = 0;
  int status = 0;
  List images = [
    "images/hangman0.png",
    "images/hangman1.png",
    "images/hangman2.png",
    "images/hangman3.png",
    "images/hangman4.png",
    "images/hangman5.png",
    "images/hangman6.png",
  ];

  opendialog(String title) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 180,
              decoration: BoxDecoration(color: Colors.purpleAccent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: retroStyle(25, Colors.white, FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Your points:  $points",
                    style: retroStyle(20, Colors.white, FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          status = 0;
                          gustalphabets.clear();
                          points = 0;
                          word = wordList[Random().nextInt(wordList.length)];
                        });
                      },
                      child: Center(
                        child: Text(
                          "Play again!",
                          style: retroStyle(20, Colors.black, FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  String handleText() {
    String displayword = "";
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (gustalphabets.contains(char)) {
        displayword += char + " ";
      } else {
        displayword += "? ";
      }
    }
    return displayword;
  }

  checkletter(String alphabet) {
    if (word.contains(alphabet)) {
      setState(() {
        gustalphabets.add(alphabet);
        points += 5;
      });
    } else if (status != 6) {
      setState(() {
        status += 1;
        points -= 5;
      });
    } else {
      opendialog("You lost!!");
    }
    bool iswon = true;
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (!gustalphabets.contains(char)) {
        setState(() {
          iswon = false;
        });
        break;
      }
    }
    if (iswon) {
      opendialog("Hurray You Won");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black45,
        title: Text(
          "HangMan",
          style: retroStyle(
            30,
            Colors.white,
            FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
              iconSize: 40,
              onPressed: () {},
              icon: Icon(
                Icons.volume_up_sharp,
                color: Colors.purpleAccent,
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 3.5,
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                height: 30,
                child: Center(
                  child: Text(
                    "$points Points",
                    style: retroStyle(
                      15,
                      Colors.black,
                      FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Image(
                width: 155,
                height: 155,
                image: AssetImage(images[status]),
                color: Colors.white,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "${7 - status} lives left",
                style: retroStyle(
                  18,
                  Colors.grey,
                  FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                handleText(),
                style: retroStyle(
                  35,
                  Colors.white,
                  FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 10),
                childAspectRatio: 1.3,
                children: lettters.map((alphabet) {
                  return InkWell(
                    onTap: () => checkletter(alphabet),
                    child: Center(
                      child: Text(
                        alphabet,
                        style: retroStyle(
                          20,
                          Colors.white,
                          FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

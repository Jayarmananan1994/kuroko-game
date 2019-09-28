import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';

void main() {
  runApp(DragDropGame());
}

class DragDropGame extends StatefulWidget {
  @override
  _DragDropGameState createState() => _DragDropGameState();
}

class _DragDropGameState extends State<DragDropGame> {
  Map<String, bool> scoreMap = {};
  int random = 3;
  

  Map playerList = {
    'assets/Kise_mugshot.png': '海常高校',
    'assets/Midorima_mugshot.png': '秀徳高校',
    'assets/Aomine_mugshot.png': '桐皇学園高校',
    'assets/Murasakibara_mugshot.png': '陽泉高校',
    'assets/Akashi_mugshot.png': '洛山高校',
    'assets/Kurokoa.png': '誠凛高校'
  };
 

  AudioCache audioCache = new AudioCache();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match the color',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Score : ${scoreMap.length}'),
          backgroundColor: Colors.pinkAccent,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          backgroundColor: Colors.purple,
          onPressed: () {
            setState(() {
              scoreMap.clear();
              random++;
            });
          },
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: playerList.keys.map((emoji) {
                return Draggable<String>(
                  data: emoji,
                  child: Emoji(
                      emojiStr: (scoreMap[emoji] == true) ? 'assets/tick.png' : emoji),
                  feedback: Emoji(emojiStr: emoji),
                  childWhenDragging: Container(
                    height: 50,
                  ),
                );
              }).toList(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: playerList.keys
                  .map((emoji) => _buildDragTarget(emoji))
                  .toList()
                    ..shuffle(Random(random)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String> candidateData,
          List rejectedData) {
        print('creating target for--' + playerList[emoji].toString());
        if (scoreMap[emoji] == true) {
          return Container(
            child: Text('Correct !'),
            alignment: Alignment.center,
            color: Colors.white,
            height: 70,
            width: 200,
          );
        } else {
          return Container(
           child: Text(playerList[emoji]),
            alignment: Alignment.center,
            color: Colors.white,
            height: 70,
            width: 200,
          );
        }
      },
      onWillAccept: (data) {
        print(' will accept data' + data);
        return data == emoji;
      },
      onAccept: (data) {
        setState(() {
          scoreMap[data] = true;
          if (scoreMap.length == 6) {
            audioCache.play('kuroko.mp3');
          } else {
            audioCache.play('successful.mp3');
          }
        });

        print(scoreMap.length);
      },
      onLeave: (data) {},
    );
  }
}

class Emoji extends StatelessWidget {
  final String emojiStr;

  Emoji({Key key, this.emojiStr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 120.0,
        width: 120.0,
        decoration: new BoxDecoration(
          image: DecorationImage(
            image: new AssetImage(emojiStr),
            fit: BoxFit.fill,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

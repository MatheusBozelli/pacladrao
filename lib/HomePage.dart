import 'dart:async';
// import 'dart:ffi';
import 'dart:math';
import 'package:responsive_styles/responsive_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pacladrao/ghost.dart';
import 'package:pacladrao/ghost3.dart';
import 'package:pacladrao/ghost2.dart';
import 'package:pacladrao/path.dart';
import 'package:pacladrao/pixel.dart';
import 'package:pacladrao/player.dart';
import 'package:pacladrao/player_1.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pacladrao/player_1.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;
  int player = numberInRow * 14 + 1;
  int ghost = numberInRow * 2 - 2;
  int ghost2 = numberInRow * 9 - 1;
  int ghost3 = numberInRow * 11 - 2;
  bool preGame = true;
  bool mouthClosed = false;
  var controller;
  int score = 0;
  bool paused = false;
  AudioPlayer advancedPlayer = new AudioPlayer();
  AudioPlayer advancedPlayer2 = new AudioPlayer();
  AudioCache audioInGame = new AudioCache(prefix: 'assets/');
  AudioCache audioMunch = new AudioCache(prefix: 'assets/');
  AudioCache audioDeath = new AudioCache(prefix: 'assets/');
  AudioCache audioPaused = new AudioCache(prefix: 'assets/');
  List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    166,
    167,
    168,
    169,
    170,
    171,
    172,
    173,
    174,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    78,
    79,
    80,
    100,
    101,
    102,
    84,
    85,
    86,
    106,
    107,
    108,
    24,
    35,
    46,
    57,
    30,
    41,
    52,
    63,
    81,
    70,
    59,
    61,
    72,
    83,
    26,
    28,
    37,
    38,
    39,
    123,
    134,
    145,
    129,
    140,
    151,
    103,
    114,
    125,
    105,
    116,
    127,
    147,
    148,
    149,
  ];

  List<int> food = [];
  String direction = "right";
  String ghostLast = "left";
  String ghostLast2 = "left";
  String ghostLast3 = "down";

  void startGame() {
    if (preGame) {
      advancedPlayer = new AudioPlayer();
      preGame = false;
      getFood();

      Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (paused) {
        } else {
          advancedPlayer.resume();
        }
        if (player == ghost || player == ghost2 || player == ghost3) {
          advancedPlayer.stop();
          setState(() {
            player = -1;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Center(child: Text("Perdeu PlayBoy!!")),
                  content: Text("Sua grana : $score"),
                  actions: [
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          player = numberInRow * 14 + 1;
                          ghost = numberInRow * 2 - 2;
                          ghost2 = numberInRow * 9 - 1;
                          ghost3 = numberInRow * 11 - 2;
                          paused = false;
                          preGame = false;
                          mouthClosed = false;
                          direction = "right";
                          food.clear();
                          getFood();
                          score = 0;
                          Navigator.pop(context);
                        });
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: const Text('Restart'),
                      ),
                    )
                  ],
                );
              });
        }
      });
      Timer.periodic(const Duration(milliseconds: 190), (timer) {
        if (!paused) {
          moveGhost();
          moveGhost2();
          moveGhost3();
        }
      });
      Timer.periodic(const Duration(milliseconds: 170), (timer) {
        setState(() {
          mouthClosed = !mouthClosed;
        });
        if (food.contains(player)) {
          setState(() {
            food.remove(player);
          });
          score++;
        }
        
        switch (direction) {
          case "left":
            if (!paused) moveLeft();
            break;
          case "right":
            if (!paused) moveRight();
            break;
          case "up":
            if (!paused) moveUp();
            break;
          case "down":
            if (!paused) moveDown();
            break;
        }
      });
    }
  }

  void restart() {
    startGame();
  }

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveLeft() {
    if (!barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveRight() {
    if (!barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveUp() {
    if (!barriers.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }

  void moveDown() {
    if (!barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }

  void moveGhost() {
    switch (ghostLast) {
      case "left":
        if (!barriers.contains(ghost - 1)) {
          setState(() {
            ghost--;
          });
        } else {
          if (!barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          } else if (!barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          }
        }
        break;
      case "right":
        if (!barriers.contains(ghost + 1)) {
          setState(() {
            ghost++;
          });
        } else {
          if (!barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          } else if (!barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          } else if (!barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          }
        }
        break;
      case "up":
        if (!barriers.contains(ghost - numberInRow)) {
          setState(() {
            ghost -= numberInRow;
            ghostLast = "up";
          });
        } else {
          if (!barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          } else if (!barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          }
        }
        break;
      case "down":
        if (!barriers.contains(ghost + numberInRow)) {
          setState(() {
            ghost += numberInRow;
            ghostLast = "down";
          });
        } else {
          if (!barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          } else if (!barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost2() {
    switch (ghostLast2) {
      case "left":
        if (!barriers.contains(ghost2 - 1)) {
          setState(() {
            ghost2--;
          });
        } else {
          if (!barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
      case "right":
        if (!barriers.contains(ghost2 + 1)) {
          setState(() {
            ghost2++;
          });
        } else {
          if (!barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          } else if (!barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          }
        }
        break;
      case "up":
        if (!barriers.contains(ghost2 - numberInRow)) {
          setState(() {
            ghost2 -= numberInRow;
            ghostLast2 = "up";
          });
        } else {
          if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          }
        }
        break;
      case "down":
        if (!barriers.contains(ghost2 + numberInRow)) {
          setState(() {
            ghost2 += numberInRow;
            ghostLast2 = "down";
          });
        } else {
          if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost3() {
    switch (ghostLast) {
      case "left":
        if (!barriers.contains(ghost3 - 1)) {
          setState(() {
            ghost3--;
          });
        } else {
          if (!barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          } else if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
      case "right":
        if (!barriers.contains(ghost3 + 1)) {
          setState(() {
            ghost3++;
          });
        } else {
          if (!barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          } else if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "up":
        if (!barriers.contains(ghost3 - numberInRow)) {
          setState(() {
            ghost3 -= numberInRow;
            ghostLast3 = "up";
          });
        } else {
          if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "down":
        if (!barriers.contains(ghost3 + numberInRow)) {
          setState(() {
            ghost3 += numberInRow;
            ghostLast3 = "down";
          });
        } else {
          if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: responsive.value({
      //   Breakpoints.xs: Colors.red.shade200,
      //   Breakpoints.sm: Colors.yellow.shade200,
      //   Breakpoints.md: Colors.green.shade200,
      //   Breakpoints.lg: Colors.blue.shade200,
      //   Breakpoints.xl: Colors.purple.shade200,
      // }),
      body: Column(
        children: [
          Expanded(
            flex: (MediaQuery.of(context).size.height.toInt() * 0.0139).toInt(),
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  direction = "down";
                } else if (details.delta.dy < 0) {
                  direction = "up";
                }
                // print(direction);
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  direction = "right";
                } else if (details.delta.dx < 0) {
                  direction = "left";
                }
                // print(direction);
              },
              child: Container(
                width: responsive.value({
                  Breakpoints.xs: MediaQuery.of(context).size.width,
                  Breakpoints.sm: 300,
                  Breakpoints.md: 300,
                  Breakpoints.lg: 400,
                  Breakpoints.xl: 400,
                }),
                child: GridView.builder(
                  padding: (MediaQuery.of(context).size.height.toInt() * 0.0139)
                              .toInt() >
                          10
                      ? const EdgeInsets.only(top: 80)
                      : const EdgeInsets.only(top: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: numberInRow),
                  itemBuilder: (BuildContext context, int index) {
                    if (mouthClosed && player == index) {
                      switch (direction) {
                        case "left":
                          return MyPlayerOne();
                        case "right":
                          return Transform.scale(
                            scaleX: -1,
                            child: MyPlayerOne(),
                          );
                        case "up":
                          return Transform.rotate(
                            angle: pi /2,
                            child: MyPlayerOne(),
                          );
                        case "down":
                          return Transform.rotate(
                            angle: 3 * pi / 2,
                            child: MyPlayerOne(),
                          );
                        default:
                          return MyPlayerOne();
                      }
                    } else if (player == index) {
                      switch (direction) {
                        case "left":
                          return MyPlayer();
                        case "right":
                          return Transform.scale(
                            scaleX: -1,
                            child: MyPlayer(),
                          );
                        case "up":
                          return Transform.rotate(
                            angle: pi / 2,
                            child: MyPlayer(),
                          );
                        case "down":
                          return Transform.rotate(
                            angle: 3 * pi / 2,
                            child: MyPlayer(),
                          );
                        default:
                          return MyPlayer();
                      }
                    } else if (ghost == index) {
                      return MyGhost();
                    } else if (ghost2 == index) {
                      return MyGhost2();
                    } else if (ghost3 == index) {
                      return MyGhost3();
                    } else if (barriers.contains(index)) {
                      return MyPixel(
                        innerColor: Colors.blue[900],
                        outerColor: Colors.blue[800],
                        // child: Text(index.toString()),
                      );
                    } else if (preGame || food.contains(index)) {
                      return MyPath(
                        innerColor: Colors.yellow,
                        outerColor: Colors.white,
                        // child: Text(index.toString()),
                      );
                    } else {
                      return MyPath(
                        innerColor: Colors.white,
                        outerColor: Colors.white,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    " Grana : $score",
                    // // (MediaQuery.of(context).size.height.toInt() * 0.0139)
                    //     .toInt()
                    //     .toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 23),
                  ),
                  GestureDetector(
                    onTap: startGame,
                    child: const Text("ROUBAR",
                        style: TextStyle(color: Colors.black, fontSize: 23)),
                  ),
                  if (!paused)
                    GestureDetector(
                      child: const Icon(
                        Icons.pause,
                        color: Colors.black,
                      ),
                      onTap: () => {
                        if (!paused)
                          {
                            paused = true,
                            advancedPlayer.pause(),
                          }
                        else
                          {
                            paused = false,
                            advancedPlayer2.stop(),
                          },
                        const Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                        )
                      },
                    ),
                  if (paused)
                    GestureDetector(
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                      ),
                      onTap: () => {
                        if (paused)
                          {paused = false, advancedPlayer2.stop()}
                        else
                          {
                            paused = true,
                            advancedPlayer.pause(),
                          },
                      },
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

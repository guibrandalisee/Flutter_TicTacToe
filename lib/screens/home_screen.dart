import 'dart:math';

import 'package:flutter/material.dart';

enum state { none, x, o }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<state> positions = List.generate(9, (index) => state.none);
  final Random random = Random();
  int counter = 0;

  void restart() {
    setState(() {
      counter = 0;
      // playerWins = false;
      gameOver = false;
      // playerLooses = false;
      positions.fillRange(0, 9, state.none);
    });
  }

  bool gameOver = false;

  void runAi() async {
    await Future.delayed(Duration(milliseconds: 200));

    int? winning;
    int? blocking;
    int? normal;

    for (var i = 0; i < 9; i++) {
      var val = positions[i];
      if (val != state.none) {
        continue;
      }
      var future = [...positions]..[i] = state.o;

      if (isWinning(state.o, future)) {
        winning = i;
      }
      future[i] = state.x;
      if (isWinning(state.x, future)) {
        blocking = i;
      }
    }
    while (normal == null && counter < 9) {
      int aux = random.nextInt(8);
      if (positions[aux] == state.none) {
        normal = aux;
      }
    }

    var move = winning ?? blocking ?? normal;

    if (move != null) {
      setState(() {
        counter += 1;
        if (winning != null) {
          gameOver = true;
        }
        positions[move] = state.o;
      });
    }
  }

  bool isWinning(state who, List<state> tiles) {
    return (tiles[0] == who && tiles[1] == who && tiles[2] == who) ||
        (tiles[0] == who && tiles[1] == who && tiles[2] == who) ||
        (tiles[3] == who && tiles[4] == who && tiles[5] == who) ||
        (tiles[6] == who && tiles[7] == who && tiles[8] == who) ||
        (tiles[0] == who && tiles[4] == who && tiles[8] == who) ||
        (tiles[2] == who && tiles[4] == who && tiles[6] == who) ||
        (tiles[0] == who && tiles[3] == who && tiles[6] == who) ||
        (tiles[1] == who && tiles[4] == who && tiles[7] == who) ||
        (tiles[2] == who && tiles[5] == who && tiles[8] == who);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: const Color(0xff121212),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xff252525),
              ),
              height: 980,
              width: 520,
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Tic-Tac-Toe",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        height: 400,
                        width: 400,
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, childAspectRatio: 1),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              String text = '';
                              switch (positions[index]) {
                                case state.x:
                                  text = 'X';
                                  break;
                                case state.o:
                                  text = 'O';
                                  break;
                                default:
                                  text = '';
                              }
                              List<int> borderSides = List.filled(4, 0);
                              switch (index) {
                                case 0:
                                  borderSides = [1, 0, 1, 0];
                                  break;
                                case 1:
                                  borderSides = [1, 1, 1, 0];
                                  break;
                                case 2:
                                  borderSides = [1, 1, 0, 0];
                                  break;
                                case 3:
                                  borderSides = [1, 0, 1, 1];
                                  break;
                                case 4:
                                  borderSides = [1, 1, 1, 1];
                                  break;
                                case 5:
                                  borderSides = [1, 1, 0, 1];
                                  break;
                                case 6:
                                  borderSides = [0, 0, 1, 1];
                                  break;
                                case 7:
                                  borderSides = [0, 1, 1, 1];
                                  break;
                                case 8:
                                  borderSides = [0, 1, 0, 1];
                                  break;
                                default:
                              }
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (!gameOver &&
                                        positions[index] == state.none) {
                                      positions[index] = state.x;
                                      counter += 1;
                                      if (!isWinning(state.x, positions)) {
                                        runAi();
                                      } else {
                                        gameOver = true;
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff121212),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: borderSides[0] == 1
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      left: BorderSide(
                                        color: borderSides[1] == 1
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      right: BorderSide(
                                        color: borderSides[2] == 1
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      top: BorderSide(
                                        color: borderSides[3] == 1
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 38),
                                    ),
                                  ),
                                  height: 40,
                                  width: 40,
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                          height: 48,
                          width: 240,
                          child: Text(
                            isWinning(state.x, positions)
                                ? 'You Won!'
                                : isWinning(state.o, positions)
                                    ? 'You Lost!'
                                    : counter > 8
                                        ? 'Draw!'
                                        : '',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 32),
                            textAlign: TextAlign.center,
                          )),
                      const SizedBox(
                        height: 128,
                      ),
                      SizedBox(
                        width: 260,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: restart,
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff121212))),
                          child: const Text(
                            "Restart",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

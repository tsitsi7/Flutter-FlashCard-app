import 'dart:async';
import 'package:flashcards_quiz/views/results_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String topicType;
  final List<dynamic> optionsList;
  const QuizScreen({
    Key? key,
    required this.optionsList,
    required this.topicType,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int questionTimerSeconds = 20;
  Timer? _timer;
  int _questionNumber = 1;
  PageController _controller = PageController();
  int score = 0;
  bool isLocked = false;

  void startTimerOnQuestions() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (questionTimerSeconds > 0) {
            questionTimerSeconds--;
          } else {
            _timer?.cancel();
            navigateToNewScreen();
          }
        });
      }
    });
  }

  void stopTime() {
    _timer?.cancel();
  }

  void navigateToNewScreen() {
    if (_questionNumber < widget.optionsList.length) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      setState(() {
        _questionNumber++;
        isLocked = false;
      });
      _resetQuestionLocks();
      startTimerOnQuestions();
    } else {
      _timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            score: score,
            totalQuestions: widget.optionsList.length,
            whichTopic: widget.topicType,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _resetQuestionLocks();
    startTimerOnQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('this is the options');
    print(widget.topicType);
    print(widget.optionsList[0]);
    const Color bgColor3 = Color(0xFF5170FD);
    const Color bgColor = Color(0xFF4993FA);

    return WillPopScope(
      onWillPop: () {
        Navigator.popUntil(context, (route) => route.isFirst);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: bgColor3,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "${widget.topicType} quiz",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14, bottom: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          CupertinoIcons.clear,
                          color: Colors.white,
                          weight: 10,
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            minHeight: 20,
                            value: 1 - (questionTimerSeconds / 20),
                            backgroundColor: Colors.blue.shade100,
                            color: Colors.blueGrey,
                            valueColor: const AlwaysStoppedAnimation(bgColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.24),
                        blurRadius: 20.0,
                        offset: const Offset(0.0, 10.0),
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Question $_questionNumber/${widget.optionsList.length}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade500),
                          ),
                          Expanded(
                            child: PageView.builder(
                              controller: _controller,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.optionsList.length,
                              onPageChanged: (value) {
                                setState(() {
                                  _questionNumber = value + 1;
                                  isLocked = false;
                                  // _resetQuestionLocks();
                                });
                              },
                              itemBuilder: (context, index) {
                                final myquestions =
                                    widget.optionsList[index]['question'];
                                return Column(
                                  children: [
                                    Text(
                                      myquestions,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontSize: 18,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: widget
                                            .optionsList[_questionNumber - 1]
                                                ['optionsList']
                                            .length,
                                        itemBuilder: (context, index) {
                                          var color = Colors.grey.shade200;
                                          var selectedOption;
                                          var questionOption =
                                              widget.optionsList[
                                                      _questionNumber - 1]
                                                  ['optionsList'][index];
                                          final letters = String.fromCharCode(
                                              'A'.codeUnitAt(0) + index);
                                          return InkWell(
                                            onTap: () {
                                              if (!isLocked) {
                                                // stopTime();
                                                setState(() {
                                                  isLocked = true;
                                                  selectedOption =
                                                      questionOption;
                                                });
                                                // Handle option selection
                                                var correctAnswer =
                                                    widget.optionsList[
                                                            _questionNumber - 1]
                                                        ['correctAnswer'];
                                                if (selectedOption ==
                                                    correctAnswer) {
                                                  // isLocked = false;
                                                  score++;
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            Color(0xFF4993FA),
                                                        title: Text(
                                                            'You got it right!'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Color(
                                                                          0xFF4993FA)),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              navigateToNewScreen();
                                                            },
                                                            child: Text('Next'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            Colors.red,
                                                        title: Text(
                                                            'Wrong answer'),
                                                        content: Text(
                                                            'The correct answer for $myquestions: $correctAnswer'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Color(
                                                                          0xFFDE1F42)),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              navigateToNewScreen();
                                                            },
                                                            child: Text('Next'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              }
                                            },
                                            child: Container(
                                              height: 45,
                                              padding: const EdgeInsets.all(10),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                border:
                                                    Border.all(color: color),
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "$letters ${questionOption}",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          // isLocked
                          //     ? buildElevatedButton()
                          //     : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetQuestionLocks() {
    for (var question in widget.optionsList) {
      isLocked = false;
    }
    questionTimerSeconds = 20;
  }

  ElevatedButton buildElevatedButton() {
    //  const Color bgColor3 = Color(0xFF5170FD);
    const Color cardColor = Color(0xFF4993FA);

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(cardColor),
        fixedSize: MaterialStateProperty.all(
          Size(MediaQuery.sizeOf(context).width * 0.80, 40),
        ),
        elevation: MaterialStateProperty.all(4),
      ),
      onPressed: () {
        if (_questionNumber < widget.optionsList.length) {
          _controller.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
          setState(() {
            _questionNumber++;
            isLocked = false;
          });
          _resetQuestionLocks();
          startTimerOnQuestions();
        } else {
          _timer?.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsScreen(
                score: score,
                totalQuestions: widget.optionsList.length,
                whichTopic: widget.topicType,
              ),
            ),
          );
        }
      },
      child: Text(
        _questionNumber < widget.optionsList.length
            ? 'Next Question'
            : 'Result',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

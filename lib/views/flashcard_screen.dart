import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flashcards_quiz/views/quiz_screen.dart';
import 'package:flashcards_quiz/widgets/flash_card_widget.dart';
import 'package:flashcards_quiz/widgets/linear_progress_indicator_widget.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'dart:math';

class NewCard extends StatefulWidget {
  final String topicName;
  final String typeOfTopic;
  final List<dynamic> flashCards;
  const NewCard(
      {Key? key,
      required this.topicName,
      required this.flashCards,
      required this.typeOfTopic});

  @override
  State<NewCard> createState() => _NewCardState();
}

class _NewCardState extends State<NewCard> {
  final AppinioSwiperController controller = AppinioSwiperController();

  @override
  Widget build(BuildContext context) {
    const Color bgColor3 = Color(0xFF5170FD);
    const Color cardColor = Color(0xFF4993FA);

    return Scaffold(
      backgroundColor: bgColor3,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    MyProgressIndicator(
                      questionlenght: [widget.flashCards.length],
                      optionsList:
                          widget.flashCards.map((card) => card.answer).toList(),
                      topicType: widget.topicName,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppinioSwiper(
                    loop: true,
                    backgroundCardsCount: 2,
                    swipeOptions: const AppinioSwipeOptions.all(),
                    unlimitedUnswipe: true,
                    controller: controller,
                    unswipe: _unswipe,
                    onSwipe: _swipe,
                    onEnd: _onEnd,
                    cardsCount: widget.flashCards.length,
                    cardsBuilder: (BuildContext context, int index) {
                      var card = widget.flashCards[index];
                      return FlipCardsWidget(
                        bgColor: cardColor,
                        cardsLenght: widget.flashCards.length,
                        currentIndex: index + 1,
                        answer: card.answer,
                        question: card.question,
                        currentTopic: widget.topicName,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(cardColor),
                        fixedSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width * 0.4, 30),
                        ),
                        elevation: MaterialStateProperty.all(4),
                      ),
                      onPressed: () => controller.unswipe(),
                      child: const Text(
                        "Reorder Cards",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(cardColor),
                        fixedSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width * 0.4, 30),
                        ),
                        elevation: MaterialStateProperty.all(4),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              questionlenght: [widget.flashCards.length],
                              optionsList: widget.flashCards
                                  .map((card) => card.answer)
                                  .toList(),
                              topicType: widget.topicName,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Start Quiz",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _swipe(int index, AppinioSwiperDirection direction) {
    print("the card was swiped to the: ${direction.name}");
    print(index);
  }

  void _unswipe(bool unswiped) {
    if (unswiped) {
      print("SUCCESS: card was unswiped");
    } else {
      print("FAIL: no card left to unswipe");
    }
  }

  void _onEnd() {
    print("end reached!");
  }
}

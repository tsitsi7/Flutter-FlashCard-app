import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flashcards_quiz/models/flutter_topics_model.dart';
import 'package:flashcards_quiz/views/flashcard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flashcards_quiz/models/flashcard.dart';
import 'package:flashcards_quiz/views/edit_flashcard_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<FlashCard> flashCards = [];
  void _navigateToEditScreen(FlashCard flashCard) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFlashcardScreen(flashCard: flashCard),
      ),
    ).then((_) {
      // Refresh the flashcards after editing
      loadFlashCardsLocally();
    });
  }

  void _deleteFlashcard(FlashCard flashCard) async {
    setState(() {
      flashCards.removeWhere((card) => card == flashCard);
    });

    final prefs = await SharedPreferences.getInstance();
    List<String> flashCardsJson = prefs.getStringList('flashCards') ?? [];

    final flashCardJson =
        jsonEncode(flashCard.toJson()); // Convert flashcard to JSON string

    // Remove the flashcard from the list of flashcards in SharedPreferences
    flashCardsJson.removeWhere((jsonString) => jsonString == flashCardJson);

    await prefs.setStringList('flashCards', flashCardsJson);
  }

  @override
  void initState() {
    super.initState();
    loadFlashCardsLocally();
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = groupFlashCardsByTopic(flashCards);
    const Color bgColor = Color(0xFF4993FA);
    const Color bgColor3 = Color(0xFF5170FD);
    return MaterialApp(
        home: Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor3,
      appBar: AppBar(
        title: Text('Flash Card Quiz'),
        backgroundColor: bgColor3,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu), // Hamburger icon
          onPressed: () {
            showMenu(
              context: context,
              color: Colors.white,
              position: RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
              items: [
                PopupMenuItem(
                  child: Text('Logout'),
                  onTap: () {
                    // Perform logout action here
                    Navigator.pushReplacementNamed(context, '/login_screen');
                  },
                ),
              ],
            );
            // _scaffoldKey.currentState?.openDrawer();
            // Handle your drawer navigation or any other action
          },
        ),
      ),
      // drawer: Drawer(
      //   child: Material(
      //     elevation: 8.0,
      //     child: ListView(
      //       padding: EdgeInsets.zero,
      //       children: <Widget>[
      //         DrawerHeader(
      //           decoration: BoxDecoration(
      //             color: Colors.blue,
      //           ),
      //           child: Text(
      //             'Menu',
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 24,
      //             ),
      //           ),
      //         ),
      //         ListTile(
      //           title: Text('Logout'),
      //           onTap: () {
      //             Navigator.pushReplacementNamed(context, '/login');
      //             // Perform logout action here
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    // add a logout button here that directs to the login page
                    decoration: BoxDecoration(
                      color: bgColor3,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.24),
                          blurRadius: 20.0,
                          offset: const Offset(0.0, 10.0),
                          spreadRadius: -10,
                          blurStyle: BlurStyle.outer,
                        )
                      ],
                    ),
                    child: Image.asset("assets/parrot-new.png"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: groupedData.length,
                    itemBuilder: (context, index) {
                      final topic = groupedData.keys.elementAt(index);
                      final topicFlashCards = groupedData[topic]!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewCard(
                                typeOfTopic: topicFlashCards
                                    .map((card) => card.question)
                                    .join(", "),
                                flashCards: topicFlashCards,
                                topicName: topic,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: bgColor,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Implement edit functionality
                                      // You can pass the current flashcard data to another page for editing
                                      _navigateToEditScreen(
                                          topicFlashCards[index]);
                                    },
                                    icon: Icon(Icons.edit, color: Colors.white),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _deleteFlashcard(topicFlashCards[index]);
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage()));

                                      // Close the dialog
                                      // Implement delete functionality
                                      // You can show a confirmation dialog before deleting the flashcard
                                    },
                                    icon:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                ],
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      topic,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                _showAddCardDialog(context);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  // Method to load flashcards from local storage
  Future<void> loadFlashCardsLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final flashCardsJson = prefs.getStringList('flashCards') ?? [];
    setState(() {
      flashCards = flashCardsJson
          .map((jsonString) => FlashCard.fromJson(jsonDecode(jsonString)))
          .toList();
    });
  }

  // Method to save flashcards locally
  Future<void> saveFlashCardLocally(FlashCard card) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> flashCardsJson = prefs.getStringList('flashCards') ?? [];
    // Convert options list to JSON array
    List<String> optionsJson =
        card.options.map((option) => jsonEncode(option)).toList();
    // Create a map for the flashcard data
    Map<String, dynamic> cardData = {
      'topic': card.topic,
      'question': card.question,
      'answer': card.answer,
      'options': optionsJson,
    };
    flashCardsJson.add(jsonEncode(card.toJson()));
    await prefs.setStringList('flashCards', flashCardsJson);
  }

  // Method to group flashcards by topic
  Map<String, List<FlashCard>> groupFlashCardsByTopic(
      List<FlashCard> flashCards) {
    final groupedData = <String, List<FlashCard>>{};
    for (var flashCard in flashCards) {
      if (!groupedData.containsKey(flashCard.topic)) {
        groupedData[flashCard.topic] = [];
      }
      groupedData[flashCard.topic]!.add(flashCard);
    }
    return groupedData;
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  void _showAddCardDialog(BuildContext context) {
    String topicValue = '';
    String questionValue = '';
    String answerValue = ''; // Declare the answer variable here
    List<String> optionsValue = [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Flash Card"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Topic",
                  ),
                  onChanged: (value) {
                    // Update topic value
                    topicValue = value;
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Question",
                  ),
                  onChanged: (value) {
                    // Update question value
                    setState(() {
                      questionValue = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Answer",
                  ),
                  onChanged: (value) {
                    // Update answer value
                    setState(() {
                      answerValue = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Options (separated by comma)",
                  ),
                  onChanged: (value) {
                    // Update options value
                    setState(() {
                      optionsValue =
                          value.split(',').map((e) => e.trim()).toList();
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Save the card information
                final newCard = FlashCard(
                  topic: capitalizeFirstLetter(topicValue),
                  question: questionValue,
                  answer: answerValue,
                  options: optionsValue,
                );
                await saveFlashCardLocally(newCard);
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

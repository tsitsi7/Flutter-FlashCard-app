import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color cardColor = Color(0xFF4993FA);

class FlutterTopics {
  final int id;
  final String topicName;
  final IconData topicIcon;
  final Color topicColor;
  final List<dynamic> topicQuestions;

  FlutterTopics({
    required this.id,
    required this.topicColor,
    required this.topicIcon,
    required this.topicName,
    required this.topicQuestions,
  });

  // Factory constructor to deserialize JSON data
  factory FlutterTopics.fromJson(Map<String, dynamic> json) {
    return FlutterTopics(
      id: json['id'],
      topicName: json['topicName'],
      topicIcon: IconData(json['topicIcon'], fontFamily: 'MaterialIcons'),
      topicColor: Color(json['topicColor']),
      topicQuestions: json['topicQuestions'],
    );
  }

  // Method to serialize to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicName': topicName,
      'topicIcon': topicIcon.codePoint,
      'topicColor': topicColor.value,
      'topicQuestions': topicQuestions,
    };
  }
}

final List<FlutterTopics> flutterTopicsList = [];

Future<void> addFlutterTopic(FlutterTopics newTopic) async {
  flutterTopicsList.add(newTopic);
  await _saveFlutterTopicsList();
}

Future<void> _saveFlutterTopicsList() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> topicsJson =
      flutterTopicsList.map((topic) => jsonEncode(topic.toJson())).toList();
  await prefs.setStringList('flutterTopicsList', topicsJson);
}

Future<void> loadFlutterTopicsList() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? topicsJson = prefs.getStringList('flutterTopicsList');
  if (topicsJson != null) {
    flutterTopicsList.clear();
    flutterTopicsList.addAll(
        topicsJson.map((json) => FlutterTopics.fromJson(jsonDecode(json))));
  }
}

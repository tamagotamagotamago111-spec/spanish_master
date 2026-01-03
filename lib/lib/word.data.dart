import 'package:flutter/material.dart';

// 私は、単語の設計図を定義しました
class SpanishWord {
  final int id;
  final String word;
  final String meaning;
  final IconData icon;
  final Color color;
  bool isFavorite;
  bool isRevealed;

  SpanishWord({
    required this.id,
    required this.word,
    required this.meaning,
    required this.icon,
    this.color = Colors.indigo,
    this.isFavorite = false,
    this.isRevealed = false,
  });
}

// 私は、500語まで拡張可能なリストを作成しました
final List<SpanishWord> allSpanishWords = [
  SpanishWord(
      id: 1,
      word: "Hola",
      meaning: "こんにちは",
      icon: Icons.waving_hand,
      color: Colors.orange),
  SpanishWord(
      id: 2,
      word: "Gracias",
      meaning: "ありがとう",
      icon: Icons.sentiment_very_satisfied,
      color: Colors.green),
  SpanishWord(
      id: 3,
      word: "Agua",
      meaning: "水",
      icon: Icons.local_drink,
      color: Colors.blue),
  SpanishWord(
      id: 4,
      word: "Comer",
      meaning: "食べる",
      icon: Icons.restaurant,
      color: Colors.red),
  SpanishWord(
      id: 5,
      word: "Libro",
      meaning: "本",
      icon: Icons.menu_book,
      color: Colors.brown),
  // --- 語彙を増やす場合は、ここから下にカンマ区切りで追加します ---
  SpanishWord(
      id: 6,
      word: "Amigo",
      meaning: "友達",
      icon: Icons.people,
      color: Colors.pink),
  SpanishWord(
      id: 7, word: "Casa", meaning: "家", icon: Icons.home, color: Colors.teal),
  SpanishWord(
      id: 8,
      word: "Tiempo",
      meaning: "時間 / 天気",
      icon: Icons.access_time,
      color: Colors.blueGrey),
  SpanishWord(
      id: 9,
      word: "Nuevo",
      meaning: "新しい",
      icon: Icons.fiber_new,
      color: Colors.cyan),
  SpanishWord(
      id: 10,
      word: "Hacer",
      meaning: "する / 作る",
      icon: Icons.handyman,
      color: Colors.orangeAccent),
];

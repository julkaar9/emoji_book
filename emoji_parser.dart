import 'package:characters/characters.dart';
import 'package:collection/collection.dart';

import 'datacounter.dart';
import 'emoji_list.dart';

List<dynamic> parseEmojis(String text) {
  if (text.isEmpty) return [List<String>.empty(), text];
  List<String> result = <String>[];
  String cleanText = '';
  for (final character in text.characters) {
    if (character.codeUnitAt(0) > 127 &&
        binarySearch(Emoji.emoji, character) != -1) {
      result.add(character);
    } else {
      cleanText += character;
    }
  }
  return [result, cleanText];
}

void countEmojisUserly() {
  DataCounter<String, String> emojiTableUserly = {};
  emojiTableUserly.initKeyA(["userA", "userB"]);
  var chats = <Map<String, String>>[
    {
      "user": "userA",
      "text": "👨‍👩‍👦‍👦 🤽‍♀️ sdsd s🐵🐵 🐵🐵🐵 🙂‍↕️ 🙂‍↔️"
    },
    {"user": "userB", "text": "👨‍👩‍👦‍👦 🤽‍♀️ sdsd s🐵 🙂‍↔️"}
  ];

  for (var chat in chats) {
    var user = chat["user"]!;
    var text = chat["text"]!;
    var parsedText = parseEmojis(text);
    List<String> emojiList = parsedText[0];

    for (String emoji in emojiList) {
      emojiTableUserly[user]![emoji] =
          (emojiTableUserly[user]![emoji] ?? 0) + 1;
    }
  }
  print(emojiTableUserly);
}

void main(List<String> args) {
  print(parseEmojis("👨‍👩‍👦‍👦 🤽‍♀️ sdsd s🐵🐵 🐵🐵🐵 🙂‍↕️ 🙂‍↔️"));
  countEmojisUserly();
}

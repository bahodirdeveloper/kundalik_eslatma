import 'dart:convert';

class Note {
  final int id;
  final String title;
  final String content;
  final DateTime modifiedTime;
  final String? mediaFilePath;
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
    this.mediaFilePath,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'modifiedTime': modifiedTime.toIso8601String(),
      'mediaFilePath': mediaFilePath,
    };
  }
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      modifiedTime: DateTime.parse(json['modifiedTime']),
      mediaFilePath: json['mediaFilePath'],
    );
  }
}
List<Note> sampleNotes = [
  Note(
    id: 0,
    title: 'Rejalarni boshqarish📑',
    content: 'Bugun, men ertalab rejalarimni tuzib oldim.',
    modifiedTime: DateTime(2024, 1, 1, 10, 15),
  ),
  Note(
    id: 1,
    title: 'O\'zgarishlar haqida',
    content:
    'Har kuni o\'zgarishlar qilishga harakat qilaman. Bu mening rivojlanishimga yordam beradi.',
    modifiedTime: DateTime(2024, 1, 3, 14, 0),
  ),
  Note(
    id: 2,
    title: 'Yangi odamlar bilan uchrashuv',
    content:
    'Bugun yangi odamlar bilan tanishdim. Ularga g\'oyalarimni aytib berdim va yaxshi suhbatlar bo\'ldi.',
    modifiedTime: DateTime(2024, 1, 4, 9, 45),
  ),
];

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'colors.dart';
import 'note.dart';
import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  // Tasodifiy rang olish funksiyasi
  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }
  bool sorted = false; // Tartib holati
  // Yozuvlarni oxirgi o'zgartirilgan vaqt bo'yicha tartiblash
  List<Note> sortNotesByModifiedTime(List<Note> notes) {
    if (sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }
    sorted = !sorted;
    return notes;
  }
  List<Note> filteredNotes = []; // Filtrlangan yozuvlar
  @override
  void initState() {
    super.initState();
    filteredNotes = sampleNotes; // Yozuvlarni boshlang'ich qiymatga o'rnatish
  }
  // Qidiruv natijalarini filtrlash
  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredNotes = sampleNotes
          .where((note) =>
      note.content.toLowerCase().contains(searchText.toLowerCase()) ||
          note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }
  // Yozuvni o'chirish
  void deleteNote(int index) {
    setState(() {
      Note note = filteredNotes[index];
      sampleNotes.remove(note);
      filteredNotes.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Qaydnomalar",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        filteredNotes = sortNotesByModifiedTime(filteredNotes);
                      });
                    },
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.sort, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: onSearchTextChanged,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              decoration: InputDecoration(
                hintText: "Qidirish ...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                fillColor: Colors.grey.shade800,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 30),
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  return AnimatedCard(
                    index: index,
                    color: getRandomColor(),
                    note: filteredNotes[index],
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EditScreen(note: filteredNotes[index]),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          int originalIndex =
                          sampleNotes.indexOf(filteredNotes[index]);
                          sampleNotes[originalIndex] = Note(
                            id: sampleNotes[originalIndex].id,
                            title: result[0],
                            content: result[1],
                            modifiedTime: DateTime.now(),
                            mediaFilePath: result[2], // Media fayl yo'li
                          );
                          filteredNotes[index] = sampleNotes[originalIndex];
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditScreen(),
            ),
          );
          if (result != null) {
            setState(() {
              sampleNotes.add(Note(
                id: sampleNotes.length,
                title: result[0],
                content: result[1],
                modifiedTime: DateTime.now(),
                mediaFilePath: result[2], // Media fayl yo'li
              ));
              filteredNotes = sampleNotes;
            });
          }
        },
        backgroundColor: Colors.grey.shade800,
        child: const Icon(
          Icons.add,
          size: 38,
        ),
      ),
    );
  }
}
class AnimatedCard extends StatelessWidget {
  final int index;
  final Color color;
  final Note note;
  final Function() onTap;
  const AnimatedCard({
    Key? key,
    required this.index,
    required this.color,
    required this.note,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat("dd/MM/yyyy HH:mm").format(note.modifiedTime),
              style: TextStyle(color: Colors.grey.shade800),
            ),
            if (note.mediaFilePath != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Media fayl: ${note.mediaFilePath!.split('/').last}",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

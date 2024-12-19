import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'note.dart';

class EditScreen extends StatefulWidget {
  final Note? note;

  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}
class _EditScreenState extends State<EditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _image;
  String? mediaFilePath;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      // Agar mavjud yozuvni tahrir qilish uchun kelsa
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      mediaFilePath = widget.note!.mediaFilePath;
    }
  }
  // Fayl tanlash funksiyasi
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        mediaFilePath = _image!.path;  // Fayl yo'lini saqlaymiz
      });
    }
  }
  // Yozuvni saqlash funksiyasi
  void _saveNote() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iltimos, barcha maydonlarni to\'ldiring!')),
      );
      return;
    }
    // Yangilangan yoki yangi yozuvni qaytarish
    Navigator.pop(
      context,
      [
        _titleController.text,
        _contentController.text,
        mediaFilePath, // Media fayl yo'li
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('Yozuvni Tahrirlash'),
        backgroundColor: Colors.grey.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Yozuv nomi',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                fillColor: Colors.grey,
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              style: const TextStyle(color: Colors.white),
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Yozuv mazmuni',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                fillColor: Colors.grey,
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade800),
                  child: const Text('Media fayl tanlash'),
                ),
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Fayl: ${_image!.path.split('/').last}',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Saqlash'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
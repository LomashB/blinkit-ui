import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Note {
  final int id;
  final String title;
  bool completed;

  Note({
    required this.id,
    required this.title,
    this.completed = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with SingleTickerProviderStateMixin {
  List<Note> notes = [];
  bool isLoading = true;
  final TextEditingController _titleController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    fetchNotes();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  void showToast(String message, bool isSuccess) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> fetchNotes() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos?_limit=10'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          notes = data.map((json) => Note.fromJson(json)).toList();
          isLoading = false;
        });
        showToast('Notes fetched successfully!', true);
        _animationController.forward();
      } else {
        showToast('Failed to fetch notes', false);
      }
    } catch (e) {
      print('Error fetching notes: $e');
      setState(() => isLoading = false);
      showToast('Error: Could not connect to server', false);
    }
  }

  Future<void> addNote(String title) async {
    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        body: json.encode({
          'title': title,
          'completed': false,
          'userId': 1,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final newNote = Note.fromJson(json.decode(response.body));
        setState(() {
          notes.insert(0, newNote);
        });
        showToast('Note added successfully!', true);
      } else {
        showToast('Failed to add note', false);
      }
    } catch (e) {
      print('Error adding note: $e');
      showToast('Error: Could not add note', false);
    }
  }

  Future<void> toggleNoteStatus(Note note) async {
    try {
      final response = await http.patch(
        Uri.parse('https://jsonplaceholder.typicode.com/todos/${note.id}'),
        body: json.encode({'completed': !note.completed}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          note.completed = !note.completed;
        });
        showToast(
          note.completed ? 'Task completed!' : 'Task uncompleted',
          true,
        );
      } else {
        showToast('Failed to update note status', false);
      }
    } catch (e) {
      print('Error updating note: $e');
      showToast('Error: Could not update note', false);
    }
  }

  Future<void> deleteNote(Note note) async {
    try {
      final response = await http.delete(
        Uri.parse('https://jsonplaceholder.typicode.com/todos/${note.id}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          notes.remove(note);
        });
        showToast('Note deleted successfully!', true);
      } else {
        showToast('Failed to delete note', false);
      }
    } catch (e) {
      print('Error deleting note: $e');
      showToast('Error: Could not delete note', false);
    }
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Add New Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
            fontSize: 24,
          ),
        ),
        content: TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Enter note title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.teal),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.teal, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            prefixIcon: Icon(Icons.note_add, color: Colors.teal),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                addNote(_titleController.text);
                _titleController.clear();
                Navigator.pop(context);
              } else {
                showToast('Please enter a note title', false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text('Add', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 28),
            onPressed: fetchNotes,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.withOpacity(0.2), Colors.white],
          ),
        ),
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
        )
            : notes.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.note_add,
                size: 80,
                color: Colors.teal.withOpacity(0.5),
              ),
              SizedBox(height: 20),
              Text(
                'No notes yet',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Tap + to add a new note',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        )
            : AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return ListView.builder(
              itemCount: notes.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final note = notes[index];
                return FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        index / notes.length,
                        (index + 1) / notes.length,
                        curve: Curves.easeOut,
                      ),
                    )),
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        leading: IconButton(
                          icon: Icon(
                            note.completed
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: note.completed ? Colors.teal : Colors.grey,
                            size: 32,
                          ),
                          onPressed: () => toggleNoteStatus(note),
                        ),
                        title: Text(
                          note.title,
                          style: TextStyle(
                            decoration: note.completed
                                ? TextDecoration.lineThrough
                                : null,
                            fontSize: 18,
                            color: note.completed
                                ? Colors.grey
                                : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 28,
                          ),
                          onPressed: () => deleteNote(note),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: Icon(Icons.add, size: 28),
        backgroundColor: Colors.teal,
        elevation: 6,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}


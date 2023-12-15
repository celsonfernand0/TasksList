import 'package:flutter/material.dart';
import 'package:tasks/data/helper/helper_database.dart';
import 'package:tasks/models/task.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {

  @override
  Widget build(BuildContext context) {
    var titlecontroler = TextEditingController();
    var descriptioncontroler = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  titlecontroler.value.text.isEmpty;
                  descriptioncontroler.value.text.isEmpty;
                });
              },
              icon: const Icon(Icons.delete),
            )
          ],
          leading: IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.deepPurple.shade500,
          title: TextField(
            maxLines: 1,
            controller: titlecontroler,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
                hintMaxLines: 1,
                border: InputBorder.none,
                hintText: "Título",
                hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold)),
          )),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          textAlign: TextAlign.center,
          maxLines: 150,
          maxLength: 150,
          controller: descriptioncontroler,
          style: const TextStyle(
              color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Descrição",
            hintStyle: TextStyle(
              fontSize: 25,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade500,
        child: const Icon(Icons.save_rounded),
        onPressed: () async {
          var db = DatabaseHelper();
          final newtask = Task(
            title: titlecontroler.text,
            description: descriptioncontroler.text,
          );
          await db.insertItem(newtask);
          Navigator.pop(context);
        },
      ),
    );
  }
}

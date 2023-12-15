import 'package:flutter/material.dart';

class TaskCart extends StatelessWidget {
  final String title;
  final String description;
  const TaskCart({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: Column(children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.deepPurple.shade500,
              child: Center(child: Text(title)),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Center(child: Text(description)),
            ),
          ),
        
        ]),
      ),
    );
  }
}

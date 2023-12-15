import 'package:flutter/material.dart';
import 'package:tasks/data/helper/helper_database.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/view/components/taskcard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper();

  List<Task> tasks = [];
  @override
  void initState() {
    super.initState();

    dbHelper.getItems().then((lista) {
      setState(() {
        tasks = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var titlecontroler = TextEditingController();
    var descriptioncontroler = TextEditingController();
    var inputtitle = TextField(
      maxLines: 1,
      controller: titlecontroler,
      style: const TextStyle(
          color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
      decoration: const InputDecoration(
          hintMaxLines: 1,
          border: InputBorder.none,
          hintText: "Título",
          hintStyle: TextStyle(
              fontSize: 20,
              color: Colors.white70,
              fontWeight: FontWeight.bold)),
    );
    var inputdescription = TextField(
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
    );
    final GlobalKey<AnimatedListState> _listKey =
        GlobalKey<AnimatedListState>();
    void _removeItem(int index) {
      setState(() {
        dbHelper.deleteItem(tasks[index].id!);
        _listKey.currentState!.removeItem(
          index,
          (context, animation) => const SizedBox.shrink(),
        );
        tasks.removeAt(index);
      });
    }

    void cleartext() {
      titlecontroler.text.isEmpty;
      descriptioncontroler.text.isEmpty;
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade200,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade500,
        title: const ListTile(
          title: Text(
            "Lista de tarefas",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "Minha lista de tarefas",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'Não há tarefas disponíveis.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : AnimatedList(
              key: _listKey,
              initialItemCount: tasks.length,
              itemBuilder: (context, index, animation) {
                var item = tasks[index];
                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: GestureDetector(
                      onDoubleTap: () {
                        _removeItem(index);
                      },
                      child: TaskCart(
                        title: item.title,
                        description: item.description,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade500,
        child: const Icon(Icons.add),
        onPressed: () {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return Dialog(
                  child: SizedBox(
                height: 400,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(0)),
                  clipBehavior: Clip.hardEdge,
                  child: Column(children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.deepPurple.shade500,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                          child: inputtitle,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.white,
                        child: Center(child: inputdescription),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.deepPurple.shade200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // IconButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       titlecontroler.value.text.isEmpty;
                              //       descriptioncontroler.value.text.isEmpty;
                              //     });
                              //   },
                              //   icon: const Icon(Icons.delete, color: Colors.white),
                              // ),
                              // IconButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       titlecontroler.value.text.isEmpty;
                              //       descriptioncontroler.value.text.isEmpty;
                              //     });
                              //   },
                              //   icon: const Icon(Icons.delete, color: Colors.white),
                              // )
                              TextButton.icon(
                                onPressed: cleartext,
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Limpar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ))
                  ]),
                ),
              ));
            },
          );
        },
      ),
    );
  }
}

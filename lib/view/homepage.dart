import 'package:flutter/material.dart';
import 'package:tasks/data/helper/helper_database.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/view/components/taskcard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _refreshTasks(); // Carrega a lista de tarefas ao iniciar a tela
  }

  // Função para atualizar a lista de tarefas
  Future<void> _refreshTasks() async {
    var updatedTasks = await dbHelper.getItems();
    setState(() {
      tasks = updatedTasks;
    });
  }

  void _removeItem(int index) {
    setState(() {
      dbHelper.deleteItem(tasks[index].id!);
      tasks.removeAt(index);
    });
  }

  Future<void> _addTaskAndRefreshList(String title, String description) async {
    var newTask = Task(title: title, description: description);
    await dbHelper.insertItem(newTask);
    await _refreshTasks(); // Atualiza a lista de tarefas após adicionar uma nova
  }

  Future<void> showCreateTask(BuildContext context) async {
    var titleController = TextEditingController();
    var descriptionController = TextEditingController();

    var inputTitle = TextField(
      maxLines: 1,
      controller: titleController,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: const InputDecoration(
        hintMaxLines: 1,
        border: InputBorder.none,
        hintText: "Título",
        hintStyle: TextStyle(
          fontSize: 20,
          color: Colors.white70,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    var inputDescription = TextField(
      textAlign: TextAlign.center,
      maxLines: 5,
      keyboardType: TextInputType.name,
      maxLength: 150,
      controller: descriptionController,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
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

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20), // Ajuste o raio conforme desejado
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.deepPurple.shade500,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                    child: inputTitle,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  color: Colors.white,
                  child: Center(child: inputDescription),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.deepPurple.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            titleController.clear();
                            descriptionController.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Limpar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty
                            ? () async {
                                await _addTaskAndRefreshList(
                                  titleController.text,
                                  descriptionController.text,
                                );
                                Navigator.pop(context);
                              }
                            : null, // Desabilita o botão se os campos estiverem vazios
                        icon: const Icon(
                          Icons.save_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Salvar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var item = tasks[index];
                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: GestureDetector(
                    onDoubleTap: () => _removeItem(index),
                    child: TaskCart(
                      title: item.title,
                      description: item.description,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade500,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => showCreateTask(context),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Task {
  final String name;
  final String description;

  Task({
    required this.name,
    required this.description,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Testee extends StatefulWidget {
  @override
  _TesteeState createState() => _TesteeState();
}

class _TesteeState extends State<Testee> {
  final String apiUrl = 'https://10.0.2.2:7190/api/Tarefa';

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((taskJson) => Task.fromJson(taskJson)).toList();
      } else {
        throw Exception('Falha ao carregar dados da API. Código de status: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      if (e.message.contains('Connection timed out')) {
        throw Exception('Tempo de conexão expirado. Certifique-se de que o servidor está em execução.');
      } else {
        throw Exception('Erro ao realizar a solicitação: $e');
      }
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: FutureBuilder<List<Task>>(
        future: fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          } else {
            // Renderize os dados na interface do usuário.
            List<Task> tasks = snapshot.data ?? [];
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index].name),
                  subtitle: Text(tasks[index].description),
                );
              },
            );
          }
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<String> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      tasks = pref.getStringList('tasks') ??
          []; //Uygulama başladığında görevleri yüklemek için
    });
  }

  Future<void> _addNewTask(String task) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    tasks.add(task);
    await pref.setStringList('tasks', tasks); //Görevleri kaydediyor
    setState(() {}); //Ekranı güncelliyor
  }

  Future<void> _deleteTask(int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    tasks.removeAt(index);
    await pref.setStringList('tasks', tasks);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController taskController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yapılacaklar'),
        backgroundColor: const Color.fromARGB(255, 103, 207, 213),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: 'Yeni görev ekle',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  _addNewTask(taskController.text);
                  taskController.clear();
                }
              },
              child: const Text('Ekle'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(tasks[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

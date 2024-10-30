import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Entergrade extends StatefulWidget {
  const Entergrade({Key? key}) : super(key: key);

  @override
  _EntergradeState createState() => _EntergradeState();
}

class _EntergradeState extends State<Entergrade> {
  List<String> courseNames = ["Bilgisayar Mimarisi", "Mobil Programlama"];
  List<String> enteredGrades = [];
  String? selectedCourse;
  TextEditingController midtermController = TextEditingController();
  TextEditingController finalController = TextEditingController();
  TextEditingController resitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      enteredGrades = pref.getStringList('enteredGrades') ?? [];
    });
  }

  Future<void> _addNewCourse() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (selectedCourse != null) {
      StringBuffer courseDetail = StringBuffer("Ders: $selectedCourse");

      if (midtermController.text.isNotEmpty) {
        courseDetail.write(", Vize: ${midtermController.text}");
      }

      if (finalController.text.isNotEmpty) {
        courseDetail.write(", Final: ${finalController.text}");
      }

      // Bütünleme notu varsa ekle
      if (resitController.text.isNotEmpty) {
        courseDetail.write(", Bütünleme: ${resitController.text}");
      }

      enteredGrades.add(courseDetail.toString());
      await pref.setStringList('enteredGrades', enteredGrades);
      setState(() {
        // Ders notları listesini güncelle
      });

      midtermController.clear();
      finalController.clear();
      resitController.clear();
      selectedCourse = null;
    }
  }

  Future<void> _deleteCourse(int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    enteredGrades.removeAt(index);
    await pref.setStringList('enteredGrades', enteredGrades);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notları Gir'),
        backgroundColor: const Color.fromARGB(255, 103, 207, 213),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Ders Seçiniz",
                border: OutlineInputBorder(),
              ),
              value: selectedCourse,
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                });
              },
              items: courseNames.map((course) {
                return DropdownMenuItem(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: midtermController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Vize Notu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: finalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Final Notu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: resitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Bütünleme Notu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addNewCourse,
              child: const Text('Gir'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: enteredGrades.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(enteredGrades[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteCourse(index),
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

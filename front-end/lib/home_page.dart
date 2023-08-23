import 'package:flutter/material.dart';

class Animal
{
  final int id;
  String name="";
  String type="";

  Animal({
    required this.id,
    required this.name,
    required this.type
  });
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Animal> animals=[
    Animal(id:1,name:"A",type:"Cow"),
    Animal(id:2,name:"B",type:"Chicken"),
    Animal(id:3,name:"C",type:"Cow")
  ];

  void _addAnimal(int id, String name, String type) {
    setState(() {
      animals.add(Animal(id: id, name: name, type: type));
    });
  }

  void _deleteAnimal(int index) {
    setState(() {
      animals.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Username Here"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: animals.length,
        itemBuilder: (BuildContext context,int index){
          return Card(
              child: ListTile(
                onTap: (){

                },
                title: Text('Name: ${animals[index].name}'),
                subtitle: Text('Type: ${animals[index].type}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteAnimal(index),
                ),
              )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddAnimalDialog(
                onAdd: _addAnimal,
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class AddAnimalDialog extends StatefulWidget {

  final void Function(int, String, String) onAdd;

  AddAnimalDialog({required this.onAdd});

  //const AddAnimalDialog({Key? key}) : super(key: key);

  @override
  State<AddAnimalDialog> createState() => _AddAnimalDialogState();
}

class _AddAnimalDialogState extends State<AddAnimalDialog> {

  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController idController;
  String selectedType = 'Cow';

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    nameController = TextEditingController();
    typeController = TextEditingController();
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Animal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: idController,
            decoration: InputDecoration(labelText: 'ID'),
            keyboardType: TextInputType.number, // Set numeric keyboard
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          DropdownButton<String>(
            value: selectedType,
            onChanged: (String? newValue) {
              setState(() {
                selectedType = newValue!;
              });
            },
            items: <String>['Cow', 'Chicken'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onAdd(int.parse(idController.text), nameController.text, selectedType);
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

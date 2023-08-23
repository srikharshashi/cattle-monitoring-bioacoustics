import 'package:cattleplus/logic/addcatlle_cubit/addcattle_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCattle extends StatefulWidget {
  const AddCattle({super.key, required this.email});

  final String email;

  @override
  State<AddCattle> createState() => _AddCattleState();
}

class _AddCattleState extends State<AddCattle> {
  final _formKey = GlobalKey<FormState>();
  String selectedAnimal = 'hen';
  TextEditingController nameController = TextEditingController();
  TextEditingController deviceIdC = TextEditingController();

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Cattle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Name:',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter friendly name for the cattle"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8.0, top: 15.0),
                child: Text(
                  'DeviceID:',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
              TextFormField(
                controller: deviceIdC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter DeviceID"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8.0, top: 15.0),
                child: Text(
                  'Select an animal:',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0),
                child: DropdownButton<String>(
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.black),
                  value: selectedAnimal,
                  onChanged: (newValue) {
                    setState(() {
                      selectedAnimal = newValue!;
                    });
                  },
                  items: <String>['hen', 'cow']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: BlocConsumer<AddcattleCubit, AddcattleState>(
                listener: (context, state) {
                  if (state is AddCattleError) {
                    showToast("There was an ereor");
                  } else if (state is AddCattleSuccess) {
                    showToast("Added Successfully");
                  }
                },
                builder: (context, state) {
                  if (state is AddCattleLoad) {
                    return SpinKitRotatingCircle(
                      color: Colors.black,
                      size: 50.0,
                    );
                  } else {
                    return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AddcattleCubit>().addCattle(
                                widget.email,
                                nameController.text,
                                selectedAnimal);
                          }
                        },
                        child: Text("Add Cattle"));
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}

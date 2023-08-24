import 'package:cattleplus/logic/addcatlle_cubit/addcattle_cubit.dart';
import 'package:cattleplus/logic/localize_cubit/localize_cubit.dart';
import 'package:cattleplus/logic/localize_cubit/strings.dart';
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
    return BlocBuilder<LocalizeCubit, LocalizeState>(
      builder: (context, localstate) {
        return Scaffold(
          appBar: AppBar(
            title: Text(Strings.map["add_cattle"]![localstate.index]),
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
                      Strings.map["Name"]![localstate.index],
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: Strings.map["enter_name"]![localstate.index]),
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
                      Strings.map["deviceid"]![localstate.index],
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                  TextFormField(
                    controller: deviceIdC,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            Strings.map["enter_deviceid"]![localstate.index]),
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
                      Strings.map["animal_select"]![localstate.index],
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
                                    selectedAnimal,
                                    deviceIdC.text);
                              }
                            },
                            child: Text(
                                Strings.map["add_cattle"]![localstate.index]));
                      }
                    },
                  ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

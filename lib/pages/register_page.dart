import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tourism/model/user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourism/pages/login_page.dart';
import 'package:tourism/repository/firebase_api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum Genre{masculino, femenino}


class _RegisterPageState extends State<RegisterPage> {

  final FirebaseApi _firebaseApi = FirebaseApi();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repPassword = TextEditingController();

  String _data = "Información: ";

  Genre? _genre = Genre.masculino;

  bool _adventure = false;
  bool _nature = false;
  bool _architectural = false;
  bool _historical = false;

  String buttonMsg = "Fecha de Nacimiento";

  String _date = "";

  String _dateConverter(DateTime newDate){
    final DateFormat formater = DateFormat("yyyy-MM-dd");
    final String dateFormated = formater.format(newDate);
    return dateFormated;
  }

  void _showSelectedDate() async{
    final DateTime? newDate = await showDatePicker(
        context: context,
        locale: const Locale("es", "CO"),
        initialDate: DateTime(2022,11),
        firstDate: DateTime(1900,1),
        lastDate: DateTime(2022,12),
        helpText: "Fecha de Nacimiento"
    );
    if (newDate != null){
      setState(() {
        _date = _dateConverter(newDate);
        buttonMsg = "Fecha de Nacimiento: ${_date.toString()}";
      });
    }
  }

  void _showMsg(String msg){
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(content: Text(msg),
          action: SnackBarAction(
          label: "Aceptar", onPressed: scaffold.hideCurrentSnackBar
      ),
      ),
    );
  }

  void saveUser(User user) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString("user", jsonEncode(user));
    var result = await _firebaseApi.registerUser(user.email, user.password);
  }

  void _onRegisterButtonClicked() {
    setState(() {
      if (_password.text == _repPassword.text){
      String genre = "Masculino";
      String favoritos = "";

      if (_genre == Genre.femenino) {
        genre = "Femenino";
      }

      if (_adventure) favoritos = "$favoritos Aventura";
      if (_nature) favoritos = "$favoritos Naturaleza";
      if (_architectural) favoritos = "$favoritos Arquitectónico";
      if (_historical) favoritos = "$favoritos Histórico";
      var user = User (
          _name.text, _email.text, _password.text, genre, favoritos, _date);
      saveUser(user);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }else{
      _showMsg("Las contraseñas deben ser iguales");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Center (
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(image: AssetImage("assets/images/ic_launcher.png")),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Nombre"),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Correo electrónico"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _password,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Contraseña"),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _repPassword,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Repita contraseña"),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 28.0,
                    ),
                    const Text(
                      "Género",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text("Masculino"),
                            leading: Radio<Genre>(
                              value: Genre.masculino,
                              groupValue: _genre,
                              onChanged: (Genre? value){
                                setState(() {
                                _genre = value;
                                });
                              }
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text("Femenino"),
                            leading: Radio<Genre>(
                                value: Genre.femenino,
                                groupValue: _genre,
                                onChanged: (Genre? value){
                                  setState(() {
                                    _genre = value;
                                  });
                                }
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 21.0,
                    ),
                    const Text(
                      "Tipo de turismo preferido",
                      style: TextStyle(fontSize: 20),
                    ),
                    CheckboxListTile(
                      title: const Text("Aventura"),
                      value: _adventure,
                      selected: _adventure,
                      onChanged: (bool? value){
                        setState(() {
                          _adventure = value!;
                        });
                      }
                    ),
                    CheckboxListTile(
                        title: const Text("Naturaleza"),
                        value: _nature,
                        selected: _nature,
                        onChanged: (bool? value){
                          setState(() {
                            _nature = value!;
                          });
                        }
                    ),
                    CheckboxListTile(
                        title: const Text("Arquitectónico"),
                        value: _architectural,
                        selected: _architectural,
                        onChanged: (bool? value){
                          setState(() {
                            _architectural = value!;
                          });
                        }
                    ),
                    CheckboxListTile(
                        title: const Text("Histórico"),
                        value: _historical,
                        selected: _historical,
                        onChanged: (bool? value){
                          setState(() {
                            _historical = value!;
                          });
                        }
                    ),
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: (){
                        _showSelectedDate();
                      },
                      child: Text(buttonMsg),

                    ),
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: (){
                        _onRegisterButtonClicked();
                      },
                      child: const Text("Registrar"),
                      
                    ),
              ],
            ),
          ),
    )
      ),
    );
  }
}



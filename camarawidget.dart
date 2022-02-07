import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types
class camarawidget extends StatefulWidget {
  const camarawidget({Key? key}) : super(key: key);

  @override
  _camarawidgetState createState() => _camarawidgetState();
}

// ignore: camel_case_types
class _camarawidgetState extends State<camarawidget> {
  @override
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController phonecontroller = new TextEditingController();
  TextEditingController subjectcontroller = new TextEditingController();
  late String codecontroller;
  bool  _isPressed = false;
  // CollectionReference _QUEUES = FirebaseFirestore.instance.collection('QUEUES');
  List codes = [];
  List names = [];
  List phones = [];
  List subjects = [];
  int _counter = 0;
  int _peoplecount = 0;
  int _othercounter = 0;
  void url = '';

//////AQUÍ EMPIEZA EL LLENADO DE FORMULARIO
  Future<void> _showVentanaDialogo(BuildContext context) {
    return showDialog(
        context: context,

        ///aqui se construye la pantalla
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Llena la información",
                  style: TextStyle(color: Colors.pink)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Divider(
                      height: 1,
                      color: Colors.pink,
                    ),
                    ListTile(
                      title: Text("Nombre"),
                    ),
                    TextField(controller: namecontroller),
                    Divider(
                      height: 1,
                      color: Colors.pink,
                    ),
                    ListTile(
                      title: Text("Tipo de trámite"),
                    ),
                    TextField(controller: subjectcontroller),
                    Divider(
                      height: 1,
                      color: Colors.pink,
                    ),
                    ListTile(
                      title: Text("Teléfono"),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: phonecontroller,
                    ),
                    ElevatedButton(
                      child: Text("Guardar"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () {
                        _incrementcounter();
                      },
                    )
                  ],
                ),
              ));
        });
  }

//////AQUÍ SE TERMINA EL LLENADO DE FORMULARIO
///////////////AQUÍ EMPEZAMOS A CHECAR
  Future<void> _showChecarCodigo(int i) {
    return showDialog(
        context: context,

        ///aqui se construye la pantalla
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(
                  child: Text('Revisa si el código es correcto',
                      style: TextStyle(color: Colors.pink))),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Divider(
                      height: 1,
                      color: Colors.pink,
                    ),
                    ListTile(
                      title: Text("Código:" + codes[i]),
                    ),
                    ListTile(
                        title: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                          // TextField(controller: namecontroller),
                          Divider(
                            height: 1,
                            color: Colors.pink,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.done_outline_rounded,
                              color: Colors.pink,
                            ),
                            onPressed: () => {
                              print("voya a mandar el"),
                              print(i),
                              _decrementcounter(names[i], phones[i], codes[i]),
                              Navigator.pop(context),
                            },
                          ),
                          IconButton(
                            alignment: Alignment.centerRight,
                            icon: Icon(
                              Icons.message_outlined,
                              color: Colors.pink,
                            ),
                            onPressed: () {
                              String msj =
                                  "Te recordamos tu código para entrar es: " +
                                      codes[i];
                              List<String> d = [phones[i]];
                              enviarsms(msj, d);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.do_not_touch,
                              color: Colors.pink,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  // //////////////
                                  SnackBar(
                                      content:
                                          Text('El código es incorrecto')));
                            },
                          ),
                        ])))
                  ],
                ),
              ));
        });
  }
////////////////////show info empieza

///////////////AQUÍ EMPEZAMOS A CHECAR
  Future<void> _showInfo(int i) {
    return showDialog(
        context: context,

        ///aqui se construye la pantalla
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(
                  child: Text('Mira la información del usuario',
                      style: TextStyle(color: Colors.pink))),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Divider(
                      height: 1,
                      color: Colors.pink,
                    ),
                    ListTile(
                      title: Text("Nombre: " + names[i]),
                    ),
                    ListTile(
                      title: Text("Tel: " + phones[i]),
                    ),
                    ListTile(
                      title: Text("Código: " + codes[i]),
                    ),
                    ListTile(
                        title: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                          // TextField(controller: namecontroller),
                          Divider(
                            height: 1,
                            color: Colors.pink,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.done_outline_rounded,
                              color: Colors.pink,
                            ),
                            onPressed: () => {
                              print("entre al press"),
                              Navigator.pop(context),
                            },
                          ),
                        ])))
                  ],
                ),
              ));
        });
  }

  ///show infor términa
  ///
  ///
  Widget build(BuildContext context) {
      
      void _myCallback(){
    setState(() {
      _isPressed = true;
    });
  }
    return Scaffold(
      appBar: AppBar(
        title: Text("No Queues"),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              new Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: Column(children: [
                  (_counter == 0)

                      ///en caso positivo
                      ? Text(
                          "No hay fila de espera",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 26),
                        )
                      ////en caso negativo
                      : Text(
                          "Hay $_counter esperando",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                  ElevatedButton(
                    child: Text("Agregar usuario"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      _showVentanaDialogo(context);
                    },
                  ),
                ]),
              ),
              new Container(
                  child: (_counter > 0)
                      ////positivo
                      ? ListBody(
                          children: [
                            for (var i = 0, ir=1; i < names.length; i++, ir++)
                              // int inu=i,
                              ListTile(
                                title: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        
                                        // _peoplecounter=i+1;
                                         "$ir." + names[i],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.pink,
                                          ),
                                          onPressed: () => _showInfo(i)),
                                      IconButton(
                                        alignment: Alignment.centerRight,
                                        icon: Icon(
                                          Icons.message_outlined,
                                          color: Colors.pink,
                                        ),
                                        onPressed: () {
                                          String msj =
                                              "Ya va a ser tu turno favor de regresar tu código para entrar es: " +
                                                  codes[i];
                                          List<String> d = [phones[i]];
                                          enviarsms(msj, d);
                                        },
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.phone_forwarded,
                                            color: Colors.pink,
                                          ),
                                          onPressed: () {
                                            hacerLlamada(phones[i]);
                                          }),
                                      IconButton(
                                        icon: Icon(
                                          Icons.done_outline_rounded,
                                          color: Colors.pink,
                                        ),
                                        onPressed: () => _showChecarCodigo(i),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.pink,
                                        ),
                                        onPressed: () {
                                          _decrementcounter(
                                              names[i], phones[i], codes[i]);
                                          // subjects[i], finalorder[i]
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Divider(
                              height: 1,
                              color: Colors.pink,
                            ),
                          ],
                        )

                      ///negativo
                      : Text(" ")),
            ],
          ),
        ),
      ),
    );
  }

  ////// contadores
  //////llamada backend
  void _incrementcounter() async {
    print("entre");
     print(namecontroller);
    codecontroller = phonecontroller.text.substring(0, 4);
    final String? nombre = namecontroller.text;
    final String? asunto = subjectcontroller.text;
    final int? phone = int.tryParse(phonecontroller.text);
    final int? codegenerator =
        int.tryParse(phonecontroller.text.substring(0, 4));
    print("length");
    print(phonecontroller.text.length);

    if (phonecontroller.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Text('El número de teléfono debe ser de 10 dígitos')));
    } else if (subjectcontroller.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Text('Especificar Asunto')));
    } else {

      // await _QUEUES .add({"CLIENT_NAME": nombre, "PHONE":phone, "SUBJECT": asunto});
      setState(() {
        print(phonecontroller.text);
        names.add(namecontroller.text);
        phones.add(phonecontroller.text);
        codes.add(phonecontroller.text.substring(0, 4) +
            phonecontroller.text.substring(6, 7));
        _counter++;
      });
    }
  }

////// String subjects, String finalorder
  void _decrementcounter(String name, String phonenum, String code) {
    setState(() {
      print("cel");
      print(phonenum);
      print("nombre");
      print(name);
      print("codigo");
      // print(finalorder[_counter]);
      print(code);

      names.removeWhere((item) => item == name);

      // finalorder.removeWhere((item) => item == finalorder[_counter]);
      phones.removeWhere((item) => item == phonenum);
      codes.removeWhere((element) => element == code);
      // subjects.removeWhere((item) => item ==subjects);
      _counter--;
    });
  }

  ///////aquí empieza la comunicación
  hacerLlamada(String phonenum) async {
    String urltel = 'tel:+52$phonenum';
    if (await canLaunch(urltel)) {
      await launch(urltel);
    } else {
      throw 'error en la llamada $urltel';
    }
  }

  enviarsms(String msj, List<String> d) async {
    String r = await sendSMS(message: msj, recipients: d).catchError((onError) {
      print(onError);
    });
    print(r);
  }
}

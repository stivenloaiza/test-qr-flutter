import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrzafiro/login_view.dart';
import 'package:qrzafiro/qr_view.dart';
import 'package:http/http.dart' as http;

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Zafiro'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String result="";
  List listCovid=[];
  bool isLoading=false;

  void _incrementCounter() async {
    _counter++;
    result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QRZafiro()));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading?CircularProgressIndicator()
          :Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10,),
            const Text(
              'Numero de veces escaneado',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text(
              'QR Leido:'
            ),
            Text(
              result,
            ),
            const SizedBox(height: 20,),
            InkWell(
              onTap: tapBotonHttp,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: const Text("COVID", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: listCovid.length,
                  itemBuilder: (context, index){
                    return Column(
                      children: [
                        ListTile(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginView(result:listCovid[index].toString())));
                          },
                          title: Text("ID Caso: ${listCovid[index]["id_de_caso"]}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Departamento: ${listCovid[index]["departamento_nom"]}"),
                              Text("Sexo: ${listCovid[index]["sexo"]}"),
                              Text("Estado: ${listCovid[index]["estado"]}"),
                            ],
                          ),
                          leading: Icon(Icons.bug_report),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        Divider()
                      ],
                    );
                  }
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void tapBotonHttp() async {
    print("click boton OK");
    isLoading=true;
    setState(() {});
    String departamento = "13001";
    String edad = "30";
    var url = Uri.parse('https://www.datos.gov.co/resource/gt2j-8ykr.json?departamento=$departamento&edad=$edad');
    http.Response response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if(response.statusCode == 200){
      listCovid = jsonDecode(response.body);
    }
    isLoading=false;
    setState(() {});
  }

}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _inputText = '';
  String _responseText = '';

  void _getResponse() async {
    final response = await getResponse(_inputText);
    setState(() {
      _responseText = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter FAQ'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) => _inputText = value,
          ),
          ElevatedButton(
            onPressed: () => _getResponse(),
            child: Text('Get Response'),
          ),
          Text(_responseText),
        ],
      ),
    );
  }


  Future<String> getResponse(String inputText) async {
    final String apiKey = 'YOUR - APIKey';
    final String endpointUrl = 'https://api.openai.com/v1/completions';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final Map<String, dynamic> data = {
      "model":"text-davinci-003",
      'prompt': '$inputText\nQ:',
      'temperature': 0.7,
      'max_tokens': 50,
      'n': 1,
      'stop': 'A:',
    };

    final response = await http.post(Uri.parse(endpointUrl), headers: headers, body: json.encode(data));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)['choices'][0]['text'];
      return responseData;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

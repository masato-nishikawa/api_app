import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// 自作の freezed クラスをインポート
import 'models/user.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String apiText = 'api通信をしていません。';
  List<dynamic> data = [];

  Future<void> _incrementCounter() async {
    setState(() {
      apiText = '通信中...';
    });

    try {
      final ipAddress = '192.168.1.62';
      final url = Uri.parse('http://$ipAddress:3000/api/person');
      final response = await http.get(url);

      setState(() {
        if (response.statusCode == 200) {
          apiText = '通信が完了しました。';
          data = jsonDecode(response.body);
        } else {
          apiText = 'エラー: ${response.statusCode}';
        }
      });
    } catch (e) {
      setState(() {
        apiText = '通信エラー: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('ローカル環境でAPI通信を行います。'),
            Text(
              apiText,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            PersonList(personInfo: data)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'API通信',
        child: const Icon(Icons.swap_vert),
      ),
    );
  }
}




class PersonList extends StatelessWidget {
  final List<dynamic> personInfo ;
  const PersonList({super.key, required this.personInfo});

  @override
  Widget build(BuildContext context) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          // 単純にリストとして表示しスクロールはしない
          physics: const NeverScrollableScrollPhysics(),
          itemCount: personInfo.length,
          itemBuilder: (context, index) {
            final person = personInfo[index];
            return ListTile(
              title: Column(
                children: [
                  Text('ID:${person['id'].toString()}'),
                  Text('名前:${person['name']}'),
                  Text('e-mail:${person['email']}'),
                ],
              ),
        );
      },
    );
  }
}

// class UserLoader {
//   // List=>dynamicでない・・・
//   static Future<List<User>> loadListFromAssets() async{
    
//   }
// }
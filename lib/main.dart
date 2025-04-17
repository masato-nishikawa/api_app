import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 自作の freezed クラスをインポート
import 'models/user.dart'; 
import 'providers/user_load_provider.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp()
    ),
  );
}

// TODO: 再通信中にロード画面が出ないで急に変わる

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'API通信アプリのデモ'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //　参照された時点で呼び出される
    final AsyncValue<List<User>> userList = ref.watch(userListProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('ローカル環境でAPI通信を行います。'),
            userList.when(
              data: (users) => PersonList(personInfo: users),
              loading: () => const CircularProgressIndicator(),
              error:(error, stackTrace) => Text('エラー: $error'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 値の変更がない場合はrefreshでなくinvalidateを使う
          ref.invalidate(userListProvider);
        },
        tooltip: 'API通信',
        child: const Icon(Icons.swap_vert),
      ),
    );
  }
}


class PersonList extends StatelessWidget {
  final List<User> personInfo ;
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
                  Text('ID:${person.id.toString()}'),
                  Text('名前:${person.name}'),
                  Text('e-mail:${person.email}'),
                ],
              ),
        );
      },
    );
  }
}

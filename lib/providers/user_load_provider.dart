import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UserLoader {
  // List<dynamic>でない・・・
  static Future<List<User>> loadListFromAssets() async {
    final ipAddress = '192.168.1.62';
    final url = Uri.parse('http://$ipAddress:3000/api/person');
    final response = await http.get(url);

    // wait関数を入れる
    await Future.delayed(const Duration(seconds: 2));

    final jsonList = json.decode(response.body) as List<dynamic>;
    return jsonList.map((e) => User.fromJson(e)).toList();
  }
}


final userListProvider = FutureProvider<List<User>>((ref) async {
  return await UserLoader.loadListFromAssets();
});
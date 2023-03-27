// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:almagestv2/models/models.dart';

class UserService extends ChangeNotifier {
  final String baseURL = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();
  bool isLoading = true;
  final List<UserData> users = [];
  String user = '';

  Future<String?> register(
    String firstname,
    String secondname,
    String email,
    String password,
    String cpassword,
  ) async {
    final Map<String, dynamic> authData = {
      'firstname': firstname,
      'secondname': secondname,
      'email': email,
      'password': password,
      'c_password': cpassword,
    };

    final url = Uri.http(baseURL, '/public/api/register', {});

    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some token",
        },
        body: json.encode(authData));
    final Map<String, dynamic> decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      print('success');
    } else {
      print('error');
    }

    if (decoded['success'] == true) {
      await storage.write(key: 'token', value: decoded['data']['token']);
      await storage.write(
          key: 'name', value: decoded['data']['name'].toString());
    } else {
      return decoded['message'];
    }
    return null;
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.http(baseURL, '/public/api/login', {});

    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some token",
        },
        body: json.encode(authData));

    final Map<String, dynamic> decoded = json.decode(response.body);

    if (decoded['success'] == true) {
      await storage.write(key: 'token', value: decoded['data']['token']);
      await storage.write(key: 'id', value: decoded['data']['id'].toString());
      return decoded['data']['type'] +
          ',' +
          decoded['data']['actived'].toString();
    } else {
      return decoded['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String> readId() async {
    return await storage.read(key: 'id') ?? '';
  }

  Future<List<UserData>> getUsers() async {
    final url = Uri.http(baseURL, '/public/api/users');
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final Map<String, dynamic> decode = json.decode(resp.body);
    var user = Users.fromJson(decode);
    for (var i in user.data!) {
      if (i.deleted == 0) {
        users.add(i);
      }
    }
    isLoading = false;
    notifyListeners();
    return users;
  }

  getUser() async {
    String? token = await readToken();
    String? id = await readId();

    final url = Uri.http(baseURL, '/public/api/user/$id');
    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    await storage.write(
        key: 'company_id', value: decodedResp['data']['company_id'].toString());
    isLoading = false;
    notifyListeners();
    return decodedResp['data']['company_id'].toString();
  }

  Future postActivate(String id) async {
    final url = Uri.http(baseURL, '/public/api/activate', {'user_id': id});
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
  }

  Future postDeactivate(String id) async {
    final url = Uri.http(baseURL, '/public/api/deactivate', {'user_id': id});
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
  }

  Future postDelete(String id) async {
    final url = Uri.http(baseURL, '/public/api/deleted/$id');
    String? token = '';
    isLoading = true;
    notifyListeners();
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    final Map<String, dynamic> decoded = json.decode(resp.body);
    if (decoded['success'] == true) {
      print('succesful');
    } else {
      print('unsuccesful');
      print(decoded.toString());
    }
  }

  Future postUpdate(
    String id,
    String firstname,
    String secondname,
    String email,
    String password,
    String companyId,
  ) async {
    final Map<String, dynamic> authData = {
      'user_id': id,
      'firstname': firstname,
      'secondname': secondname,
      'email': email,
      'password': password,
      'company_id': companyId
    };
    final url = Uri.http(baseURL, '/public/api/user/update/', {'user_id': id});
    String? token = '';
    isLoading = true;
    notifyListeners();
    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: json.encode(authData));

    final Map<String, dynamic> decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      print('success');
    } else {
      print('error');
    }

    return null;
  }
}

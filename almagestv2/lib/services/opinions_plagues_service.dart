import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:almagestv2/services/services.dart';
import 'package:almagestv2/models/models.dart';

class OpinionsPlaguesService extends ChangeNotifier {
  final String baseURL = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();
  bool isLoading = true;
  final List<PlagueData> plagues = [];
  final List<OpinionData> opinions = [];
  final UserService userService = UserService();

  Future getPlagues() async {
    plagues.clear();
    final url = Uri.http(baseURL, '/public/api/plagues', {});
    String? token = await userService.readToken();
    isLoading = true;
    notifyListeners();

    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    final Map<String, dynamic> decoded = json.decode(response.body);
    var plague = Plagues.fromJson(decoded);
    for (var i in plague.data!) {
      plagues.add(i);
    }
    isLoading = false;
    notifyListeners();
    return plagues;
  }

  Future postPlague(String name, String img, String productId) async {
    final Map<String, dynamic> createData = {
      'name': name,
      'img': img,
      'product_id': productId
    };
    final url = Uri.http(baseURL, '/public/api/plagues', createData);
    String? token = await userService.readToken();
    isLoading = true;
    notifyListeners();
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    final Map<String, dynamic> decoded = json.decode(response.body);

    return decoded['message'];
  }

  Future<List<OpinionData>> getOpinions() async {
    String? token = await userService.readToken();
    final url = Uri.http(baseURL, '/public/api/opinions', {});
    isLoading = true;
    notifyListeners();

    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    final Map<String, dynamic> decoded = json.decode(response.body);
    var opinion = Opinions.fromJson(decoded);
    for (var i in opinion.data!) {
      opinions.add(i);
    }
    isLoading = false;
    notifyListeners();
    return opinions;
  }

  Future postOpinion(String id, String headline, String description,
      String plagueId, String plagueName, String numLikes) async {
    final Map<String, dynamic> createData = {
      'id': id,
      'headline': headline,
      'description': description,
      'plague_id': plagueId,
      'plague_name': plagueName,
      'num_likes': numLikes
    };
    final url = Uri.http(baseURL, '/public/api/opinions', createData);
    String? token = await userService.readToken();
    isLoading = true;
    notifyListeners();
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    final Map<String, dynamic> decoded = json.decode(response.body);

    return decoded['message'];
  }

  Future deleteOpinion(String id) async {
    String? token = await userService.readToken();
    final url = Uri.http(baseURL, '/public/api/opinions/$id');
    isLoading = true;
    notifyListeners();

    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    final Map<String, dynamic> decoded = json.decode(response.body);
    return decoded['message'];
  }

  Future postLike(String opinionId) async {
    final Map<String, dynamic> likeData = {
      'user_id': UserService.userId,
      'opinion_id': opinionId,
    };
    final url = Uri.http(baseURL, '/public/api/like', likeData);
    String? token = await userService.readToken();
    isLoading = true;
    notifyListeners();
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    final Map<String, dynamic> decoded = json.decode(response.body);

    //Necesario utilizar el data para registrar quién da Like.
    return decoded['message'];
  }
}

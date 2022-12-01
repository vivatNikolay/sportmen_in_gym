import 'dart:convert';
import 'package:http/http.dart';

import '../../models/account.dart';
import '../../models/visit.dart';
import 'http_service.dart';

class VisitHttpService extends HttpService<Visit>{

  Future<List<Visit>> getByAccount(Account account) async {
    final uri = Uri.http(url, '/sportsmanDetails/visits/${account.id}');
    Response res = await get(uri,
        headers: <String, String>{
          'authorization' : basicAuth(account.email, account.password)
        });
    print(res.body);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((i) =>
      Visit.fromJson(i)).toList();
    } else {
      throw "Unable to retrieve visits.";
    }
  }

  Future<List<Visit>> getBySubscription(Account account) async {
    final uri = Uri.http(url, '/sportsmanDetails/visitsBySubscription/${account.id}');
    Response res = await get(uri,
        headers: <String, String>{
          'authorization' : basicAuth(account.email, account.password)
        });
    print(res.body);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((i) =>
          Visit.fromJson(i)).toList();
    } else {
      throw "Unable to retrieve visits.";
    }
  }
}
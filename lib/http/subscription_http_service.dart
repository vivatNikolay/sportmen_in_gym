import 'dart:io';
import 'package:http/http.dart';

import '../../models/account.dart';
import '../../models/subscription.dart';
import 'http_service.dart';

class SubscriptionHttpService extends HttpService<Subscription> {

  Future<void> addMembership(Account ownAccount, String id,
      String dateOfStart, String dateOfEnd, String numberOfVisits) async {
    final params = {
      "id": id,
      "dateOfStart": dateOfStart,
      "dateOfEnd": dateOfEnd,
      "numberOfVisits": numberOfVisits
    };
    final uri = Uri.http(url, '/manager/addMembership', params);
    try {
      Response res = await post(uri,
          headers: <String, String>{
            HttpHeaders.authorizationHeader:
                basicAuth(ownAccount.email, ownAccount.password),
            HttpHeaders.contentTypeHeader: 'application/json',
          });
      if (res.statusCode != 200) {
        throw 'Ошибка при добавлении';
      }
    } on SocketException {
      throw 'Нет интернет соединения';
    } on Exception {
      throw 'Ошибка';
    }
  }
}
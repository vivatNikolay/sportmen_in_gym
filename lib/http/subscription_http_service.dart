import 'dart:io';
import 'package:http/http.dart';

import '../../models/account.dart';
import '../../models/subscription.dart';
import 'http_service.dart';

class SubscriptionHttpService extends HttpService<Subscription> {

  Future<bool> addMembership(Account ownAccount, String email,
      String dateOfStart, String dateOfEnd, String numberOfVisits) async {
    final params = {
      "email": email,
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
      if (res.statusCode == 200) {
        return true;
      }
    } on Exception {
      return false;
    }
    return false;
  }
}
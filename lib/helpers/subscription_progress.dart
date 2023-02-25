import 'package:intl/intl.dart';

import '../models/subscription.dart';

class SubscriptionProgress {
  static final DateFormat _formatterDate = DateFormat('dd.MM.yyyy');

  static getString(List<Subscription> subscriptions) {
    Subscription? subscription;
    if (subscriptions.isNotEmpty) {
      subscription = subscriptions.last;
    }
    if (subscription != null) {
      if (subscription.dateOfEnd
          .add(const Duration(days: 1))
          .isBefore(DateTime.now())) {
        return 'Истекает ${_formatterDate.format(subscription.dateOfEnd)}';
      } else {
        return '${subscription.visits.length}/${subscription.numberOfVisits} '
            'до ${_formatterDate.format(subscription.dateOfEnd)}';
      }
    }
    return 'Не добавлен';
  }
}
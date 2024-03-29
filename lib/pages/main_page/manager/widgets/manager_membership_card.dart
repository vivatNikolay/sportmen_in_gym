import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../membership_list/memberships_page.dart';
import '../../../../helpers/constants.dart';
import '../../../../models/custom_icons.dart';
import '../../../../models/membership.dart';
import '../../../../models/visit.dart';
import '../../../../services/membership_fire.dart';
import '../../../../services/visit_fire.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../visits_list.dart';
import '../../widgets/membership_progress.dart';

class ManagerMembershipCard extends StatelessWidget {
  final String userId;
  final MembershipFire _membershipFire = MembershipFire();
  final VisitFire _visitFire = VisitFire();

  ManagerMembershipCard({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: StreamBuilder(
          stream: _membershipFire.streamByUser(userId),
          builder: (context, AsyncSnapshot<QuerySnapshot> memSnapshot) {
            Membership? membership;
            if (!memSnapshot.hasError &&
                memSnapshot.hasData &&
                memSnapshot.data!.docs.isNotEmpty) {
              membership =
                  Membership.fromDocument(memSnapshot.data!.docs.first);
            }
            return ListTile(
              leading: const Icon(CustomIcons.sub, size: 26, color: mainColor),
              minLeadingWidth: 22,
              title: Text(
                'membership'.i18n(),
                style: const TextStyle(fontSize: 20),
              ),
              subtitle: MembershipProgress(
                membership: membership,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add, size: 32, color: mainColor),
                onPressed: () async {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  if (_isMembershipInactive(membership)) {
                    if (_checkStartDate(membership, context)) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MembershipsPage(userId: userId)));
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        textConfirmation: 'addVisitToMembership'.i18n(),
                        onYes: () async =>
                            _addMembershipVisit(userId, membership!, context),
                      ),
                    );
                  }
                },
              ),
              onTap: () {
                if (membership != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VisitsList(
                            title: 'membershipHistory'.i18n(),
                            accountId: userId,
                            membershipId: membership!.id,
                          )));
                }
              },
            );
          }),
    );
  }

  Future<void> _addMembershipVisit(
      String userId, Membership membership, BuildContext context) async {
    membership.visitCounter += 1;
    await _membershipFire.put(membership);
    await _visitFire.create(Visit(
        date: DateTime.now(), userId: userId, membershipId: membership.id));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('visitAddedToMembership'.i18n())));
    Navigator.of(context).pop();
  }

  bool _isMembershipInactive(Membership? membership) {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (membership == null) {
      return true;
    }
    if (membership.dateOfEnd.isBefore(today)) {
      return true;
    }
    if (membership.dateOfStart.isAfter(today)) {
      return true;
    }
    if (membership.visitCounter >= membership.numberOfVisits) {
      return true;
    }
    return false;
  }

  bool _checkStartDate(Membership? membership, BuildContext context) {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (membership == null) {
      return true;
    }
    if (membership.dateOfStart.isAfter(today)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('membershipDidNotStart'.i18n()),
      ));
      return false;
    }
    return true;
  }
}

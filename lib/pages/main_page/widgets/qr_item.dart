import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../helpers/constants.dart';

class QrItem extends StatelessWidget {
  final String data;
  final VoidCallback onTap;

  const QrItem({required this.data, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(150)),
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width/10.8),
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            radius: 0.86,
            colors: [
              mainColor,
              mainColor,
              Theme.of(context).backgroundColor,
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 4,
            )
          ],
        ),
        child: QrImageView(
          data: data,
          size: MediaQuery.of(context).size.width/2.28,
          foregroundColor: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }
}

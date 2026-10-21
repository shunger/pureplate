import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// A QR code for an invite link, black on white so any camera reads it,
/// including in dark mode.
class InviteQrCode extends StatelessWidget {
  final String link;
  final double size;

  const InviteQrCode({super.key, required this.link, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Invite QR code',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: QrImageView(
          data: link,
          size: size,
          backgroundColor: Colors.white,
          // Quiet zone comes from the padding above.
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

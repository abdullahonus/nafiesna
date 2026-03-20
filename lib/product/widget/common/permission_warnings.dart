import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../init/theme/app_colors.dart';
import '../../init/theme/app_text_styles.dart';

class NotificationWarningWidget extends StatefulWidget {
  const NotificationWarningWidget({super.key});

  @override
  State<NotificationWarningWidget> createState() => _NotificationWarningWidgetState();
}

class _NotificationWarningWidgetState extends State<NotificationWarningWidget> with WidgetsBindingObserver {
  bool _isDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkStatus();
  }

  Future<void> _checkStatus() async {
    bool isDenied = false;

    if (Platform.isIOS) {
      // iOS'ta bildirim izinleri için FirebaseMessaging ayarları en güvenilir kaynaktır.
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
      isDenied = settings.authorizationStatus == AuthorizationStatus.denied ||
          settings.authorizationStatus == AuthorizationStatus.notDetermined;
    } else {
      // Android ve diğer platformlar için permission_handler kullanımı yeterlidir.
      final status = await Permission.notification.status;
      isDenied = !(status.isGranted || status.isProvisional || status.isLimited);
    }

    if (mounted) {
      setState(() {
        _isDenied = isDenied;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDenied) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () async {
        if (Platform.isIOS) {
          final settings = await FirebaseMessaging.instance.getNotificationSettings();
          if (settings.authorizationStatus == AuthorizationStatus.denied) {
            openAppSettings();
          } else {
            // İzin istenmemişse veya provisional ise isteyebiliriz.
            // Zaten izin verilmişse requestPermission() mevcut durumu döner, dialog açmaz.
            await FirebaseMessaging.instance.requestPermission();
            await _checkStatus();
          }
        } else {
          final current = await Permission.notification.status;
          if (current.isPermanentlyDenied) {
            openAppSettings();
          } else {
            final result = await Permission.notification.request();
            if (mounted) {
              setState(() {
                _isDenied = !(result.isGranted || result.isProvisional || result.isLimited);
              });
            }
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.notifications_off_rounded, color: AppColors.error, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Sohbet ve canlı yayınları kaçırmamak için bildirim izni verin.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.error, size: 20),
          ],
        ),
      ),
    );
  }
}

class LocationInfoWarningButton extends StatefulWidget {
  const LocationInfoWarningButton({super.key});

  @override
  State<LocationInfoWarningButton> createState() => _LocationInfoWarningButtonState();
}

class _LocationInfoWarningButtonState extends State<LocationInfoWarningButton> with WidgetsBindingObserver {
  bool _isDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkStatus();
  }

  Future<void> _checkStatus() async {
    final status = await Permission.locationWhenInUse.status;
    if (mounted) {
      setState(() {
        _isDenied = !(status.isGranted || status.isLimited);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDenied) return const SizedBox.shrink();

    return IconButton(
      tooltip: 'Konum İzni Gerekli',
      icon: const Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 22),
      onPressed: () async {
        final current = await Permission.locationWhenInUse.status;
        if (!context.mounted) return;
        if (current.isPermanentlyDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Doğru vakitler ve camiler için konum izni gereklidir.'),
              action: SnackBarAction(
                label: 'AYARLAR',
                textColor: AppColors.primary,
                onPressed: () => openAppSettings(),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          final result = await Permission.locationWhenInUse.request();
          if (mounted) {
            setState(() {
              _isDenied = !(result.isGranted || result.isLimited);
            });
          }
        }
      },
    );
  }
}


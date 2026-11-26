import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'auth_service.dart';

/// Push notifications (Firebase Cloud Messaging).
///
/// Every phone has a token. It is saved in `users/{uid}.fcmTokens` (a list,
/// because one user can sign in on several phones). A server (Cloud
/// Functions, see /functions) reads the list of the person it wants to
/// notify and sends the message only to those tokens.
class PushService {
  PushService._();

  static final _users = FirebaseFirestore.instance.collection('users');
  static StreamSubscription<String>? _refreshSub;

  /// Call once from main(): shows a message while the app is open.
  /// (When the app is closed or in the background, Android shows it itself.)
  static void listenInForeground() {
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      Get.snackbar(notification.title ?? 'CareerMate', notification.body ?? '');
    });
  }

  /// Asks for permission and saves this phone's token for the signed-in user.
  static Future<void> saveToken() async {
    final user = AuthService.currentUser;
    if (user == null) return;

    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();

      final token = await messaging.getToken();
      debugPrint('FCM token: $token'); // handy for "Send test message"
      if (token != null) await _add(user.uid, token);

      // Tokens change sometimes (reinstall, restore): keep Firestore updated.
      _refreshSub ??= messaging.onTokenRefresh.listen((newToken) {
        final current = AuthService.currentUser;
        if (current != null) _add(current.uid, newToken);
      });
    } catch (e) {
      // Never block sign-in because of notifications.
      debugPrint('PushService.saveToken failed: $e');
    }
  }

  /// Call before signing out, so this phone stops receiving that user's
  /// notifications.
  static Future<void> removeToken() async {
    try {
      final user = AuthService.currentUser;
      final token = await FirebaseMessaging.instance.getToken();
      if (user != null && token != null) {
        await _users.doc(user.uid).update({
          'fcmTokens': FieldValue.arrayRemove([token]),
        });
      }
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      debugPrint('PushService.removeToken failed: $e');
    }
  }

  static Future<void> _add(String uid, String token) {
    return _users.doc(uid).update({
      'fcmTokens': FieldValue.arrayUnion([token]),
    });
  }
}

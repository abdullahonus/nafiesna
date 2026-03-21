import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Kullanıcının şu an sohbet ekranında olup olmadığını tutar.
/// `true` iken gelen chat bildirimleri bastırılır.
final chatScreenActiveProvider = StateProvider<bool>((ref) => false);

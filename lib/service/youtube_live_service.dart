import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// YouTube Data API v3 ile kanalın canlı yayın durumunu kontrol eder.
class YouTubeLiveService {
  YouTubeLiveService({required String apiKey}) : _apiKey = apiKey;

  final String _apiKey;
  static const String _channelHandle = '@NafiEsna';
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
  ));

  String? _cachedChannelId;
  LiveStreamInfo? _cachedResult;
  DateTime? _lastCheck;

  static const Duration _cacheTimeout = Duration(minutes: 2);

  /// Kanalın o an canlı yayında olup olmadığını kontrol eder.
  Future<LiveStreamInfo> checkLiveStatus() async {
    if (_lastCheck != null &&
        _cachedResult != null &&
        DateTime.now().difference(_lastCheck!) < _cacheTimeout) {
      return _cachedResult!;
    }

    try {
      final String channelId = await _getChannelId();

      final Response<Map<String, dynamic>> response = await _dio.get(
        '$_baseUrl/search',
        queryParameters: <String, dynamic>{
          'part': 'snippet',
          'channelId': channelId,
          'type': 'video',
          'eventType': 'live',
          'key': _apiKey,
          'maxResults': 1,
        },
      );

      final Map<String, dynamic> data = response.data!;
      final List<dynamic> items = data['items'] as List<dynamic>? ?? [];

      if (items.isNotEmpty) {
        final Map<String, dynamic> snippet =
            (items[0] as Map<String, dynamic>)['snippet']
                as Map<String, dynamic>;
        final String videoId =
            ((items[0] as Map<String, dynamic>)['id']
                as Map<String, dynamic>)['videoId'] as String;

        _cachedResult = LiveStreamInfo(
          isLive: true,
          title: snippet['title'] as String? ?? 'Canlı Yayın',
          videoId: videoId,
          thumbnailUrl: _extractThumbnail(snippet),
        );
      } else {
        _cachedResult = const LiveStreamInfo(isLive: false);
      }

      _lastCheck = DateTime.now();
      return _cachedResult!;
    } catch (e) {
      debugPrint('YouTube live check error: $e');
      return _cachedResult ?? const LiveStreamInfo(isLive: false);
    }
  }

  Future<String> _getChannelId() async {
    if (_cachedChannelId != null) return _cachedChannelId!;

    final Response<Map<String, dynamic>> response = await _dio.get(
      '$_baseUrl/channels',
      queryParameters: <String, dynamic>{
        'part': 'id',
        'forHandle': _channelHandle,
        'key': _apiKey,
      },
    );

    final List<dynamic> items =
        response.data!['items'] as List<dynamic>? ?? [];

    if (items.isEmpty) {
      throw Exception('YouTube channel not found: $_channelHandle');
    }

    _cachedChannelId =
        (items[0] as Map<String, dynamic>)['id'] as String;
    return _cachedChannelId!;
  }

  String? _extractThumbnail(Map<String, dynamic> snippet) {
    final Map<String, dynamic>? thumbnails =
        snippet['thumbnails'] as Map<String, dynamic>?;
    if (thumbnails == null) return null;

    final Map<String, dynamic>? high =
        thumbnails['high'] as Map<String, dynamic>?;
    return high?['url'] as String?;
  }
}

class LiveStreamInfo {
  const LiveStreamInfo({
    required this.isLive,
    this.title,
    this.videoId,
    this.thumbnailUrl,
  });

  final bool isLive;
  final String? title;
  final String? videoId;
  final String? thumbnailUrl;

  String get videoUrl => 'https://www.youtube.com/watch?v=$videoId';
}

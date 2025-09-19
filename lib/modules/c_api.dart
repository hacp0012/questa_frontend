import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_store.dart';

/// API request handler.
class CApi {
  /// Get auth token key.
  static const String loginTokenKey = 'WhVt4hwNwNx0pCKT0X4qvLIOBCb0kwxixBH4';

  /// User login authentication token key.
  static String? get loginToken => CStore.prefs.getString(loginTokenKey);
  static set loginToken(String? token) {
    if (token != null) CStore.prefs.setString(loginTokenKey, token);
  }

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${CConsts.API_URL}/questa_v1',
      headers: {'Accept': 'application/json'},
      receiveDataWhenStatusError: true,
      validateStatus: (status) => true, // kDebugMode,
    ),
  );

  final _options = CacheOptions(
    // A default store is required for interceptor.
    store: HiveCacheStore(null),

    // All subsequent fields are optional to get a standard behaviour.

    // Default.
    policy: CachePolicy.request,
    // Returns a cached response on error for given status codes.
    // Defaults to `[]`.
    hitCacheOnErrorCodes: [500],
    // Allows to return a cached response on network errors (e.g. offline usage).
    // Defaults to `false`.
    hitCacheOnNetworkFailure: true,
    // Overrides any HTTP directive to delete entry past this duration.
    // Useful only when origin server has no cache config or custom behaviour is desired.
    // Defaults to `null`.
    maxStale: const Duration(days: 7),
    // Default. Allows 3 cache sets and ease cleanup.
    priority: CachePriority.high,
    // Default. Body and headers encryption with your own algorithm.
    cipher: null,
    // Default. Key builder to retrieve requests.
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    // Default. Allows to cache POST requests.
    // Assigning a [keyBuilder] is strongly recommended when `true`.
    allowPostMethod: true,
  );

  /// Normal request without Cache.
  static Dio get request {
    _dio.options.headers['Authorization'] = loginToken != null ? 'Bearer $loginToken' : null;
    return _dio;
  }

  /// Make a cached request.
  static Dio get cachedRequest {
    _dio.options.headers['Authorization'] = loginToken != null ? 'Bearer $loginToken' : null;
    _dio.interceptors.add(DioCacheInterceptor(options: CApi()._options));
    return _dio;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  HttpClient._internal() {
    _init();
  }

  late Dio _dio;
  final String baseUrl = "https://your-api-base-url.com";
  final int sendTimeout = 20;
  final int connectTimeout = 20;
  final int receiveTimeout = 20;

  // Token刷新状态管理
  bool _isRefreshingToken = false;
  final List<RequestOptions> _tokenRefreshQueue = [];

  // 错误消息映射
  static const Map<int, String> _errorMessages = {
    400: "请求参数错误",
    401: "未授权，请重新登录",
    403: "权限不足，拒绝访问",
    404: "请求资源不存在",
    408: "请求超时",
    500: "服务器内部错误",
    501: "服务未实现",
    502: "网关错误",
    503: "服务不可用",
    504: "网关超时",
  };

  void _init() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      sendTimeout: Duration(seconds: sendTimeout),
      connectTimeout: Duration(seconds: connectTimeout),
      receiveTimeout: Duration(seconds: receiveTimeout),
      headers: {'Content-Type': 'application/json'},
    );

    _dio = Dio(options);

    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 添加Token到请求头
        String? token = await _getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // 统一处理业务状态码
        _handleBusinessCode(response);
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        // Token过期处理 (401表示Token过期)
        if (error.response?.statusCode == 401) {
          return _handleTokenExpired(error, handler);
        }

        // 处理其他网络错误
        _showNetworkError(error);
        return handler.next(error);
      },
    ));
  }

  // 处理Token过期
  Future<void> _handleTokenExpired(DioException error, ErrorInterceptorHandler handler) async {
    _tokenRefreshQueue.add(error.requestOptions);

    if (!_isRefreshingToken) {
      _isRefreshingToken = true;
      try {
        final newToken = await _refreshToken();
        await _saveToken(newToken);

        for (var options in _tokenRefreshQueue) {
          options.headers['Authorization'] = 'Bearer $newToken';
          _retryRequest(options);
        }
      } catch (refreshError) {
        _showError("Token刷新失败，请重新登录");
        _goToLogin();
        return handler.reject(error);
      } finally {
        _tokenRefreshQueue.clear();
        _isRefreshingToken = false;
      }
    }
    return handler.resolve(Response(requestOptions: error.requestOptions));
  }

  // 处理业务状态码
  void _handleBusinessCode(Response response) {
    // 假设业务响应格式: {"code": 200, "message": "成功", "data": {}}
    final dynamic data = response.data;
    if (data is Map && data.containsKey('code')) {
      final code = data['code'];
      final message = data['message']?.toString() ?? "操作完成";

      // 非200状态码视为业务异常
      if (code != 200) {
        _showBusinessError(code, message);
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: "业务异常: $message",
        );
      } else {
        // 正常业务提示
        _showSuccess(message);
      }
    }
  }

  // 显示网络错误
  void _showNetworkError(DioException error) {
    String errorMsg = "网络连接异常";

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        errorMsg = "网络连接超时";
        break;
      case DioExceptionType.badCertificate:
        errorMsg = "证书验证失败";
        break;
      case DioExceptionType.cancel:
        errorMsg = "请求已取消";
        break;
      case DioExceptionType.connectionError:
        errorMsg = "网络连接失败";
        break;
      case DioExceptionType.unknown:
        errorMsg = "未知网络错误";
        break;
      default:
        if (error.response != null) {
          final statusCode = error.response!.statusCode;
          errorMsg = _errorMessages[statusCode] ?? "服务器错误 ($statusCode)";
        }
    }

    _showError(errorMsg);
  }

  // 显示业务错误
  void _showBusinessError(int code, String message) {
    // 根据业务状态码定制提示
    String fullMessage = "业务错误[$code]: $message";
    _showError(fullMessage);
  }

  // 显示成功提示
  void _showSuccess(String message) {
    if (kDebugMode) {
      print("操作成功: $message");
    }
    // 实际项目中调用提示组件
    // Toast.show("✅ $message");
  }

  // 显示错误提示
  void _showError(String message) {
    if (kDebugMode) {
      print("错误: $message");
    }
    // 实际项目中调用提示组件
    // Toast.show("❌ $message");
  }

  // Token相关方法
  Future<String?> _getToken() async => 'your_current_token';
  Future<String> _refreshToken() async => 'new_refreshed_token';
  Future<void> _saveToken(String token) async {}
  void _goToLogin() => _showError("登录状态已过期，请重新登录");
  Future<void> _retryRequest(RequestOptions options) async => _dio.request(
    options.path,
    data: options.data,
    queryParameters: options.queryParameters,
    options: Options(method: options.method, headers: options.headers),
  );

  // 通用请求方法
  Future<Response> request(
      String path, {
        String method = 'GET',
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      return await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );
    } on DioException catch (e) {
      // 统一错误处理
      _showNetworkError(e);
      rethrow;
    }
  }

  // GET请求
  Future<Response> get(String path, {
    Map<String, dynamic>? queryParameters,
  }) => request(path, method: 'GET', queryParameters: queryParameters);

  // POST请求
  Future<Response> post(String path, {
    dynamic data,
  }) => request(path, method: 'POST', data: data);

  // PUT请求
  Future<Response> put(String path, {
    dynamic data,
  }) => request(path, method: 'PUT', data: data);

  // DELETE请求
  Future<Response> delete(String path) => request(path, method: 'DELETE');
}

/* 使用示例
void main() async {
  final http = HttpClient();

  try {
    // 正常请求
    final response = await http.get('/api/data');
    print("响应数据: ${response.data}");

    // 触发业务异常
    await http.post('/api/create', data: {});
  } catch (e) {
    print("捕获异常: $e");
  }
}
 */
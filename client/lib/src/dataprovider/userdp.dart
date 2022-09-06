import 'package:core/model/user.dart';
import 'package:dio/dio.dart';

class UserDp {
  final _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/'));

  Future<List<User>> get() async {
    final response = await _dio.get('/');
    return (response.data['users'] as List)
        .map<User>((json) => User.fromJson(json))
        .toList();
  }

  Future<User> save(User user) async {
    final response = await _dio.post('/', data: user.toJason());
    return User.fromJson(response.data);
  }

  Future delete(String id) async {
    final response = await _dio.delete('/$id');
    return response.data;
  }

  Future<User> update(String id, User user) async {
    try {
      final response = await _dio.put('/$id', data: user.toUpdateJason());
      return User.fromJson(response.data);
    } catch (e) {
      print(e.toString());
    }
  }
}

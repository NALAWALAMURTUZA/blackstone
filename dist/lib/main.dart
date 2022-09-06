import 'dart:convert';
import 'dart:io';

import 'package:mime_type/mime_type.dart';
import 'package:mongo_dart/mongo_dart.dart';

var baseExecPath;
var users;
Future<void> main() async {
  final server = await createServer();
  await setUpDatabase();
  print('Serving at ${server.address}:${server.port}');
  print('Script execution base path is $baseExecPath');

  print('Try it out: http://localhost:${server.port}/');
  print('Try it out: http://localhost:${server.port}/api');

  // Listen for requests
  await for (var request in server) {
    handleRequest(request);
  }
}

Future<void> setUpDatabase() async {
  var db = Db("mongodb://localhost:27017/blackstone");
  users = db.collection('users');
  await db.open();
}

/// http://localhost:8080
/// http://localhost:8080/index.html
/// http://localhost:8080/api
/// http://localhost:8080/api/getMessage - json
void handleRequest(HttpRequest request) {
  final uri = request.uri;
  if (uri.path.contains('/api')) {
    _handleApiRequest(request);
  } else {
    _handleStaticFilesRequest(request);
  }
}

Future<HttpServer> createServer() async {
  final address = InternetAddress.loopbackIPv4;
  var server = await HttpServer.bind(address, 8080);
  baseExecPath = Platform.script.path.replaceAll('/lib/main.dart', '');
  return server;
}

Future<void> _handleApiRequest(HttpRequest request) async {
  _setResponseHeader(request);
  switch (request.method) {
    case 'GET':
      _handleGet(request);
      break;
    case 'POST':
      _handlePost(request);
      break;
    case 'PUT':
      _handlePut(request);
      break;
    case 'DELETE':
      _handleDelete(request);
      break;
    default:
      _handleDefault(request);
  }
}

void _handleStaticFilesRequest(HttpRequest request) async {
  final uri = request.uri;
  var path = uri.path;

  // Normalize path ending
  if (path.endsWith('/')) {
    path = path.substring(0, path.length - 1);
  }
  // Provide default index.html
  if (!path.contains(".")) {
    path += "/index.html";
  }
  // Set the absolute file to serve
  final filePath = '$baseExecPath/html$path';

  //print("path=$path");
  print('Request: static server filePath=$filePath');

  // Stream file to client
  final File file = await new File(filePath);
  file.exists().then((found) {
    if (found) {
      String mimeType = mime(filePath);
      if (mimeType == null) mimeType = 'text/plain; charset=UTF-8';
      request.response.headers.set('Content-Type', mimeType);
      file.openRead().pipe(request.response).catchError((e) {
        print('openRead error $e');
      });
    } else {
      _handle404(request);
    }
  });
}

Future<void> _handleGet(HttpRequest request) async {
  final allUsers = await users.find().toList();
  request.response
    ..statusCode = HttpStatus.ok
    ..write(json.encode({'users': allUsers}))
    ..close();
}

Future<void> _handlePost(HttpRequest request) async {
  String data = await utf8.decoder.bind(request).join();
  Map<String, dynamic> valueMap = json.decode(data);
  await users.save(valueMap);
  request.response
    ..write(
      json.encode(await users.findOne(where.eq('name', valueMap['name']))),
    )
    ..close();
}

Future<void> _handlePut(HttpRequest request) async {
  String id = request.uri.pathSegments.last ?? "";
  if (id == null || id.isEmpty) {
    _handle404(request);
  }
  String data = await utf8.decoder.bind(request).join();
  Map<String, dynamic> valueMap = json.decode(data);
  await users.update(where.eq('_id', ObjectId.fromHexString(id)), valueMap);
  request.response
    ..write(
      json.encode(
        await users.findOne(
          where.eq('_id', ObjectId.fromHexString(id)),
        ),
      ),
    )
    ..close();
}

Future<void> _handleDelete(HttpRequest request) async {
  String id = request.uri.pathSegments.last ?? "";
  if (id == null || id.isEmpty) {
    _handle404(request);
  }
  await users.remove(where.eq('_id', ObjectId.fromHexString(id)));
  request.response
    ..write("")
    ..close();
}

void _handleDefault(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.methodNotAllowed
    ..write('Unsupported request: ${request.method}.')
    ..close();
}

void _setResponseHeader(HttpRequest request) {
  request.response.headers.add('Access-Control-Allow-Origin', '*');

  request.response.headers
      .add('Access-Control-Allow-Methods', 'GET, POST, DELETE, PUT');
  request.response.headers
      .add('Access-Control-Allow-Headers', 'Origin, Content-Type');
  request.response.headers.add('Content-Type', 'application/json');
}

void _handle404(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.notFound
    ..headers.contentType = ContentType.html
    ..write('404')
    ..close();
}

import 'dart:io';

import 'package:mime_type/mime_type.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:sevr/sevr.dart';

var baseExecPath;
void main() async {
  baseExecPath = Platform.script.path.replaceAll('/lib/server.dart', '');
  var db = Db("mongodb://localhost:27017/blackstone");
  final users = db.collection('users');
  await db.open();
  // Listen for requests
  // Create server
  const port = 8080;
  final server = Sevr();

  final uriPaths = ['/', '/api/', '/api/:id'];
  for (var route in uriPaths) {
    server.options(route, [
      (req, res) {
        _setResponseHeader(req, res);
        return res.status(200);
      }
    ]);
  }
  server.get('/', [
    _setResponseHeader,
    (ServRequest req, ServResponse res) async {
      var path = req.path;

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
      final File file = File(filePath);
      file.exists().then((found) {
        if (found) {
          print("found file");
          String mimeType = mime(filePath);
          mimeType ??= 'text/plain; charset=UTF-8';
          res.response.headers.set('Content-Type', mimeType);
          file.openRead().pipe(res.response).catchError((e) {
            print('openRead error $e');
          });
        } else {
          _handle404(res);
        }
      });
    }
  ]);

  server.get('/api/', [
    _setResponseHeader,
    (ServRequest req, ServResponse res) async {
      final allUsers = await users.find().toList();
      return res.status(200).json({'users': allUsers});
    }
  ]);

  server.post('/api/', [
    _setResponseHeader,
    (ServRequest req, ServResponse res) async {
      await users.save(req.body as Map<String, dynamic>);
      return res.json(
        await users.findOne(where.eq('name', req.body['name'])),
      );
    }
  ]);

  server.delete('/api/:id', [
    _setResponseHeader,
    (ServRequest req, ServResponse res) async {
      String id = req.params['id'] ?? "";
      if (id.isNotEmpty) {
        await users.remove(where.eq('_id', ObjectId.fromHexString(id)));
        return res.status(200);
      }
      return res.status(404);
    }
  ]);

  server.put('/api/:id', [
    _setResponseHeader,
    (ServRequest req, ServResponse res) async {
      String id = req.params['id'] ?? "";
      if (id.isNotEmpty) {
        await users.update(where.eq('_id', ObjectId.fromHexString(id)),
            req.body as Map<String, dynamic>);
        return res.json(
          await users.findOne(
            where.eq('_id', ObjectId.fromHexString(id)),
          ),
        );
      }
      return res.status(404);
    }
  ]);

  // Listen for connections
  server.listen(port, callback: () {
    print('Server listening on port: $port');
  });
  Future.delayed(const Duration(seconds: 2), () {
    print('Serving at ${server.server.address}:${server.port}');
    print('Try it out: http://localhost:${server.port}/');
    print('Try it out: http://localhost:${server.port}/api');
  });
}

void _setResponseHeader(ServRequest req, ServResponse res) {
  res.response.headers.add('Access-Control-Allow-Origin', '*');
  res.response.headers
      .add('Access-Control-Allow-Methods', 'GET, POST, DELETE, PUT');
  res.response.headers
      .add('Access-Control-Allow-Headers', 'Origin, Content-Type');
}

void _handle404(ServResponse res) {
  res.response
    ..headers.contentType = ContentType.html
    ..write('404')
    ..close();
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HttpService {
  Future<String> cnpjGetName(String cnpj) async {
    var url = Uri.https('publica.cnpj.ws', '/cnpj/$cnpj');
    var response = await http.get(url);
    Logger().i('response code: ${response.statusCode}');
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> json = jsonDecode(response.body);
        return json['estabelecimento']["nome_fantasia"];
      } catch (e) {
        Logger().e(e);
        rethrow;
      }
    }
    return cnpj;
  }
}

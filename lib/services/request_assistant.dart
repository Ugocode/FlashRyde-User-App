import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> recieveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));

    try {
      if (httpResponse.statusCode == 200) {
        String responseData = httpResponse.body;

        var decodeData = jsonDecode(responseData);

        return decodeData;
      } else {
        return "Failed";
      }
    } catch (exp) {
      return "Failed";
    }
  }
}

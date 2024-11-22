import 'dart:convert';

import 'package:http/http.dart' as https;

class LmsServices {
  Future<List<dynamic>> fetchSubjects() async{
    try {
      String url = 'https://trogon.info/interview/php/api/subjects.php';
      final response = await https.get(Uri.parse(url));
      if(response.statusCode == 200){
        return json.decode(response.body) as List<dynamic>;
      }
      else{
        throw Exception('Failed to load subjects list');
      }
    } catch (e) {
      throw 'Error in fetching the subjects';
    }
  }
}

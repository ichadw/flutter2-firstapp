import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchAlbum(String term) async {
  final response = await http.get(
    Uri.https('deezerdevs-deezer.p.rapidapi.com', 'search', {"q": term}),
    headers: {
      "x-rapidapi-key": "9c76b35fe1msh7c8b0c9c09152bfp1bcfa6jsn74d78d717869",
      "x-rapidapi-host": "deezerdevs-deezer.p.rapidapi.com",
      "useQueryString": "true"
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return jsonDecode(response.body)['data'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

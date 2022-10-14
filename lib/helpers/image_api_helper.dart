import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quote_app/modals/image.dart';

class ImageAPIHelper {
  ImageAPIHelper._();

  static final ImageAPIHelper imageAPIHelper = ImageAPIHelper._();

  Future<List<myImages>?> fetchImages() async {

    http.Response response = await http.get(
      Uri.parse(
        "https://api.unsplash.com/photos?per_page=400&page=3&client_id=Y9INCjdWrlugQXSXHkRkYpDucItoatr_gf89YSVPy44",
      ),
    );
    if(response.statusCode == 200)
      {
        List<dynamic> decodedData = jsonDecode(response.body);

        List<myImages> images = decodedData.map((e) => myImages.fromMap(data: e),).toList();

        return images;
      }
    return null;
  }
}

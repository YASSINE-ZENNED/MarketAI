import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SupportChatService {
  final String apiUrl = 'http://localhost:8080/api/sendMessage'; // Replace with your API endpoint
  final Map<String, String> headers = {'Content-Type': 'application/json'};

  Future<String> MsgForChatBot(String text,List<File> pickedImages) async{

    try {

      final body = jsonEncode({
        'text': text,
        'image': "base64Encode(bytes)", // Encode image bytes to base64
        // Add any other necessary fields for your API request
      });

      final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        // Successful response handling
        return "true";

      } else {

        // Handle non-200 status code response
        return "false";
      }
    } catch (e) {
      print('Error sending message and image: $e');
      // Handle error as needed
      return "false";
    }
  }
}

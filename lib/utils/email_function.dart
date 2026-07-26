import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<bool> sendContactForm(String name, String email, String message) async {
  try {
    final response = await http.post(
      Uri.parse('https://sendcontactmail-37fq2xx2sa-uc.a.run.app'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'message': message}),
    );

    log('Status: ${response.statusCode}');
    log('Body: ${response.body}');

    return response.statusCode == 200;
  } catch (e, stack) {
    log('Error: $e');
    log('Stack: $stack');
    return false;
  }
}
// Future<bool> sendContactForm(String name, String email, String message) async {
//   try {
//     final url = Uri.parse('https://sendcontactmail-37fq2xx2sa-uc.a.run.app');

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'name': name, 'email': email, 'message': message}),
//     );

//     if (response.statusCode == 200) {
//       log("Email sent successfully!");
//       return true;
//     } else {
//       log("Failed to send email: ${response.body}");
//       return false;
//     }
//   } catch (e) {
//     log("Error sending email: $e");
//     return false;
//   }
// }

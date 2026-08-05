import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:personal_portfolio/model/contact_message.dart';

import 'email_service.dart';

class EmailServiceImpl implements EmailService {
  static const _serviceId = "service_s930nk6";
  static const _templateId = "__ejs-test-mail-service__";
  static const _publicKey = "hLmynmnMEiclU4s-d";

  @override
  Future<bool> send(ContactMessage message) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    // ۲. ارسال درخواست با هدر دقیق JSON
    final response = await http.post(
      url,
      headers: {
        'Content-Type':
            'application/json', // حتماً به فرمت حروف بزرگ و کوچک دقت کنید
      },
      body: json.encode({
        'service_id': 'service_wtkllbq', // شناسه سرویس شما
        'template_id': 'template_iv6nzb3', // شناسه قالب شما
        'user_id': 'hLmynmnMEicIU4s-d', // کلید عمومی شما از پنل
        'template_params': message.toJson(),
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    return response.statusCode == 200;
  }
}

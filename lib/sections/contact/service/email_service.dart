import 'package:personal_portfolio/model/contact_message.dart';

abstract class EmailService {
  Future<bool> send(ContactMessage message);
}

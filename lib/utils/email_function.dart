import 'package:url_launcher/url_launcher.dart';

Future<void> sendContactForm(String name, String email, String message) async {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: encodeQueryParameters(<String, String>{
      'subject': name,
      'body': message,
    }),
  );

  launchUrl(emailLaunchUri);
}

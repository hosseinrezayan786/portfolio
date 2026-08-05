class ContactMessage {
  final String name;
  final String email;
  final String message;

  const ContactMessage({
    required this.name,
    required this.email,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {"from_name": name, "from_email": email, "message": message};
  }
}

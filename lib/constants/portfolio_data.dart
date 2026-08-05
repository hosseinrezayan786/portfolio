import 'package:personal_portfolio/constants/images.dart';

class PortfolioData {
  // personal info
  static const String name = 'Hossein Rezayan';
  static const String title = 'Flutter Developer';
  static const String profileImagePath = 'assets/images/coding_boy.jpg';
  static const String quote =
      'I Transform complex challenges into simple, beautiful products that improve everyday lifes';
  static const String bio =
      "I believe technology should make life easier. That's why I design and build mobile applications that simplify everyday challenges into intuitive experiences. Every product I create is focused on solving real user problems with simplicity, quality, and thoughtful design.";

  static const String aboutImage = 'assets/images/profile_image.jpg';
  // Contact Information
  static const String email = 's.hosseinrezayan7@gmail.com';
  static const String phone = '+93 701758962';

  // Social Media Links

  static const String githubUrl = 'https://github.com/hosseinrezayan786';
  static const String linkedinUrl =
      'https://www.linkedin.com/in/hossein-rezayan-a34018336/';
  static const String whatsappUrl = "https://wa.me/93701758962";
  static const String cvUrl = '';

  // skills
  static const List<Map<String, dynamic>> skills = [
    {
      'name': 'Clean Architecture',
      'iconKey': 'cleanArchitecture',
      'accentColor': 0xFF54C5F8,
    },
    {'name': 'Flutter', 'iconKey': 'flutter', 'accentColor': 0xFF54C5F8},
    {'name': 'Dart', 'iconKey': 'dart', 'accentColor': 0xFF54C5F8},
    {'name': 'Bloc', 'iconKey': 'layerGroup', 'accentColor': 0xFF54C5F8},
    {'name': 'Provider', 'iconKey': 'link', 'accentColor': 0xFF06B6D4},
    {'name': 'Firebase', 'iconKey': 'firebase', 'accentColor': 0xFFFFCA28},
    {'name': 'Hive', 'iconKey': 'database', 'accentColor': 0xFFE0A800},
    {'name': 'Supabase', 'iconKey': 'firebase', 'accentColor': 0xFFFFCA28},
    {'name': 'REST API', 'iconKey': 'api', 'accentColor': 0xFF7C3AED},
    {'name': 'Git', 'iconKey': 'git', 'accentColor': 0xFFF1502F},
    {'name': 'GitHub', 'iconKey': 'github', 'accentColor': 0xFF188717},
    {'name': 'Figma', 'iconKey': 'figma', 'accentColor': 0xFFF24E1E},

    {'name': 'Postman', 'iconKey': 'postman', 'accentColor': 0xFFFF6C37},
    {'name': 'VS Code', 'iconKey': 'vscode', 'accentColor': 0xFF007ACC},
    {'name': 'Cursor', 'iconKey': 'cursor', 'accentColor': 0xFF59E1E},
  ];

  // Projects
  static const List<Map<String, dynamic>> projects = [
    // Main Projects
    {
      'title': 'Maffad bitcoins',
      'description':
          'Making cryptocurrency trading simple, secure, and trustworthy.',
      'technologies': [
        'Flutter',
        'Dart',
        'Bloc',
        'REST_API',
        'Clean Architecture',
      ],
      'highlights': [
        'Authentication',
        'Digital Wallet',
        'KYC Verification',
        'Notifications',
        'Transaction History',
      ],
      'imageUrl': AppImages.maffadMain,
      'galleryImages': [
        AppImages.maffad_1,
        AppImages.maffad_2,
        AppImages.maffad_3,
        AppImages.maffad_4,
        AppImages.maffad_5,
        AppImages.maffad_6,
        AppImages.maffad_7,
      ],
      'githubUrl': 'https://github.com/Shaham-Ahammed/trim-spot-user',

      'userAndroidUrl': 'https://www.amazon.com/dp/B0D571DFTK/ref=apps_sf_sta',
      'adminAndroidUrl': 'https://www.amazon.com/dp/B0CY5D6XFL/ref=apps_sf_sta',
      'type': 'main',
    },

    {
      'title': 'Helma English',
      'description':
          'Helping learners remember vocabulary through meaningful connections',
      'technologies': ['Flutter', 'Dart', 'Provider', 'Hive', 'Supabase'],
      'highlights': [
        'Offline Learning',
        'Flashcards',
        'Story-based Learning',
        'Localization',
        'Progress Tracking',
      ],
      'imageUrl': AppImages.helmaMain,
      'galleryImages': [
        AppImages.helma1,
        AppImages.helma2,
        AppImages.helma3,
        AppImages.helma4,
      ],
      'webUrl': 'https://www.kawader.gov.qa/',
      'iosUrl': 'https://apps.apple.com/qa/app/kawader-qatar/id6755183682',
      'androidUrl':
          'https://play.google.com/store/apps/details?id=com.cgb.kawader',

      'type': 'main',
    },

    {
      'title': 'Ravvan Delivery',

      'description':
          'Simplifying cargo transportation through a seamless digital experience.',
      'technologies': ['Flutter', 'Dart', 'REST API', 'Bloc'],
      'highlights': [
        'Cargo Booking',
        'Multi Destination',
        'Order Tracking',
        'Driver Requests',
      ],
      'imageUrl': AppImages.ravvanMain,
      'galleryImages': [
        AppImages.ravvanMain,
        AppImages.ravvan1,
        AppImages.ravvan2,
        AppImages.ravvan3,
        AppImages.ravvan4,
        AppImages.ravvan5,
        AppImages.ravvan6,
      ],
      'webUrl': 'https://my-bel0ved.web.app',
      'type': 'main',
    },

    {
      'title': 'Hyro Plast',
      'description':
          'My first published mobile application for a real business.',
      'technologies': ['Java', 'Android Studio', 'XML'],
      'highlights': [
        'Product Catalog',
        'Google Play Publishing',
        'Client Collaboration',
      ],
      'imageUrl': AppImages.hyroPlast,
      'galleryImages': [
        AppImages.hyroPlast,
        AppImages.hyroPlast2,
        AppImages.hyroPlast3,
        AppImages.hyroPlast4,
        AppImages.hyroPlast5,
        AppImages.hyroPlast6,
        AppImages.hyroPlast7,
        AppImages.hyroPlast8,
        AppImages.hyroPlast9,
      ],
      'githubUrl': 'https://github.com/Shaham-Ahammed/flutter-music-player',
      'androidUrl': 'https://www.amazon.com/dp/B0CPYR6D8W/ref=apps_sf_sta',
      'type': 'main',
    },

    {
      'title': 'Food Delivery Demo',
      'description':
          'Learning the fundamentals of building real-world mobile applications.',
      'technologies': ['Flutter', 'Firebase Authentication', 'Cloud Firestore'],
      'highlights': ['Food Ordering', 'Order Management', 'Firebase CRUD'],
      'imageUrl': AppImages.foodDelivery,
      'galleryImages': [
        AppImages.foodDelivery1,
        AppImages.foodDelivery2,
        AppImages.foodDelivery3,
        AppImages.foodDelivery4,
        AppImages.foodDelivery5,
      ],
      'githubUrl': 'https://github.com/Shaham-Ahammed/flutter-music-player',
      'androidUrl': 'https://www.amazon.com/dp/B0CPYR6D8W/ref=apps_sf_sta',
      'type': 'main',
    },

    // Mini Projects
    {
      'title': 'Animated Music Player',
      'description':
          'Exploring animation and storytelling through interactive conversations.',
      'technologies': [
        'Flutter',
        'Dart',
        'AnimationController',
        'Audio Player',
      ],

      'highlights': [
        'Rotating Vinyl Animation',
        'Wave Pulse Effect',
        'Local Audio Playback',
        'Custom UI Animation',
      ],

      'imageUrl': AppImages.musicPlayer,
      'githubUrl': 'https://github.com/Shaham-Ahammed/neflix_clone',
      'type': 'mini',
    },
    {
      'title': 'Conversation Player',
      'description':
          'Exploring animation and storytelling through interactive conversations.',
      'technologies': [
        'Flutter',
        'Dart',
        'AnimationController',
        'Audio Player',
        'ScrollController',
      ],

      'highlights': [
        'Animated Characters',
        'Voice Synchronization',
        'Auto Scrolling',
        'Message Highlighting',
      ],
      'imageUrl': AppImages.wordSpelling,
      'githubUrl':
          'https://github.com/Shaham-Ahammed/LET-HIM-COOK---Recipe-application',
      'type': 'mini',
    },
    {
      'title': 'Shopping UI Concept',
      'description':
          'Exploring clean interfaces through a modern shopping experience.',
      'technologies': ['Flutter', 'Dart', 'Material Design'],

      'highlights': [
        'Dark Theme',
        'Modern Shopping UI',
        'Product Cards',
        'Responsive Layout',
      ],
      'imageUrl': AppImages.shopy,
      'githubUrl':
          'https://github.com/Shaham-Ahammed/student-management-app-getX-sqflite',
      'type': 'mini',
    },
    {
      'title': 'Habit Tracker',
      'description': 'Building better habits through simple visual feedback.',
      'technologies': ['Flutter', 'Dart'],

      'highlights': [
        'Calendar View',
        'Habit Tracking',
        'Progress Heatmap',
        'Custom Daily Tasks',
      ],
      'imageUrl': AppImages.habitTracker,
      'githubUrl': 'https://github.com/Shaham-Ahammed/weather-app-bloc-and-api',
      'type': 'mini',
    },

    {
      'title': 'Focus Timer',
      'description':
          'Exploring how visual design can improve focus and productivity.',
      'technologies': ['Flutter', 'Dart'],

      'highlights': [
        'Pomodoro Timer',
        'Dynamic Themes',
        'Custom Timer Settings',
        'Minimal UI',
      ],
      'imageUrl': AppImages.pomaTimer,
      'githubUrl':
          'https://github.com/Shaham-Ahammed/tic-tac-toe/blob/main/lib/main.dart',
      'type': 'mini',
    },
  ];

  // Experience
  static const List<Map<String, dynamic>> experiences = [
    {
      'title': 'Android Developer (Part-time)',
      'company': 'Hyro Plast | On-site & Remote',
      'location': 'Iran',
      'period': '2023 - 2024',
      'description':
          'Developed my first commercial Android application while working at Hyro Plast, a manufacturer of stretch film products.\nDesigned and built a digital product catalog that allowed customers to explore products, learn about the company, and submit purchase requests directly to the business.\nThis experience introduced me to working with real client requirements, delivering software for a business, and publishing an application on Google Play.',
      'technologies': ['Java', 'Android Studio', 'XML'],
      // 'website': 'https://salayan/',
    },
    {
      'title': 'Flutter Developer',
      'company': 'Solayan | On-site & Remote',
      'location': 'Iran',
      'period': '2025 - 2026',
      'description':
          'After a year of self-directed learning and building personal projects, I joined Solayan as a Flutter Intern and later progressed into a Flutter Developer.\nContributed to production-ready logistics and fintech applications by integrating REST APIs, authentication, digital wallets, notifications, and KYC workflows while collaborating closely with backend developers.\nFocused on building scalable architecture, maintainable code, and user-centered mobile experiences.',
      'technologies': [
        'Flutter',
        'Dart',
        'REST API',
        'Firebase',
        'Supabase',
        'Clean Architecture',
        'Bloc',
        'Provider',
      ],
      'website': 'https://www.salayan.com/',
    },
  ];
}

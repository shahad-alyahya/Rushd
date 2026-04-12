import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// --- Global App Imports ---
import 'splash_screen.dart';

// --- Admin Section ---
import 'Admin/add_security.dart';
import 'Admin/AddZonePage.dart';
import 'Admin/HomePage-3.dart';
import 'Admin/Mesgsage_4.dart';
import 'Admin/message_3.dart';
import 'Admin/security_Staff_List.dart';
import 'Admin/ZonesListPage.dart';

// --- Security Section ---
import 'Security/edit_profile_2.dart';
import 'Security/home_page2.dart';
import 'Security/profile_2.dart';

// --- SecurityStaff Section ---
import 'SecurityStaff/ZoneAlerts-1.dart';
import 'SecurityStaff/ZoneAlerts-2.dart';

// --- Shared Components ---
import 'shared/VisitorBottomBar1.dart';

// --- Visitor Section ---
import 'Visitor/alternative_route.dart';
import 'Visitor/create_password.dart';
import 'Visitor/edit_profile_1.dart';
import 'Visitor/faqs_1.dart';
import 'Visitor/homepage1.dart';
import 'Visitor/loginPage.dart';
import 'Visitor/massage1.dart';
import 'Visitor/massage2.dart';
import 'Visitor/profile_1.dart';
import 'Visitor/reset_password.dart';
import 'Visitor/routes.dart';
import 'Visitor/signupPage.dart';
import 'Visitor/verify_email-2.dart';
import 'Visitor/verifyEmailPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(
    'pk.eyJ1IjoiamFuYS1tYXAiLCJhIjoiY21ua2t2NmEwMHl2bTJvcXRtbTc3dmd4OCJ9.IFJKzxCXiljylAhDapynfQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rushd App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF867AB9),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
      },
    );
  }
}
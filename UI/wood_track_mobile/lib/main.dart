import 'package:wood_track_mobile/providers/cart_provider.dart';
import 'package:wood_track_mobile/providers/dropdown_provider.dart';
import 'package:wood_track_mobile/providers/order_provider.dart';
import 'package:wood_track_mobile/providers/product_provider.dart';
import 'package:wood_track_mobile/providers/recommender_provider.dart';
import 'package:wood_track_mobile/providers/registration_provider.dart';
import 'package:wood_track_mobile/providers/review_provider.dart';
import 'package:wood_track_mobile/providers/user_provider.dart';
import 'package:wood_track_mobile/screens/home/home_screen.dart';
import 'package:wood_track_mobile/screens/login/login_screen.dart';
import 'package:wood_track_mobile/screens/registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wood_track_mobile/helpers/my_http_overrides.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:io';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  HttpOverrides.global = MyHttpOverrides();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RegistrationProvider()),
          ChangeNotifierProvider(create: (_) => DropdownProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ReviewProvider()),
          ChangeNotifierProvider(create: (_) => RecommendationProvider()),
        ],
        child: MaterialApp(
          home: const LoginScreen(),
            theme: ThemeData(
              primaryColor: const Color(0xFF5D4037),
            ),
          onGenerateRoute: (settings) {
            if (settings.name == HomePage.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => HomePage()));
            }
            if (settings.name == LoginScreen.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => LoginScreen()));
            }
            if (settings.name == RegistrationScreen.routeName) {
              return MaterialPageRoute(
                  builder: ((context) => RegistrationScreen()));
            }
          },
        ));
  }
}

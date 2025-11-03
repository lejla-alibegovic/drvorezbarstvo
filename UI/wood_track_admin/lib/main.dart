import 'dart:io';
import 'package:wood_track_admin/providers/dropdown_provider.dart';
import 'package:wood_track_admin/providers/product_orders_provider.dart';
import 'package:wood_track_admin/providers/reports_provider.dart';
import 'package:wood_track_admin/providers/reviews_provider.dart';
import 'package:wood_track_admin/providers/tool_orders_provider.dart';
import 'package:wood_track_admin/screens/employees/employee_list_screen.dart';
import 'package:wood_track_admin/screens/clients/client_list_screen.dart';
import 'package:wood_track_admin/screens/order/tool_order_list_screen.dart';
import 'package:wood_track_admin/screens/productCategories/productCategory_list_screen.dart';
import 'package:wood_track_admin/screens/order/product_order_list_screen.dart';
import 'package:wood_track_admin/screens/products/product_list_screen.dart';
import 'package:wood_track_admin/screens/reports/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:wood_track_admin/providers/cities_provider.dart';
import 'package:wood_track_admin/providers/countries_provider.dart';
import 'package:wood_track_admin/screens/cities/city_list_screen.dart';
import 'package:wood_track_admin/screens/countries/country_list_screen.dart';
import 'package:wood_track_admin/screens/home/home_screen.dart';
import 'package:wood_track_admin/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wood_track_admin/screens/toolCategories/toolCategory_list_screen.dart';
import 'package:wood_track_admin/screens/tools/tool_list_screen.dart';
import 'helpers/my_http_overrides.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CountryProvider()),
          ChangeNotifierProvider(create: (_) => CityProvider()),
          ChangeNotifierProvider(create: (_) => ProductOrderProvider()),
          ChangeNotifierProvider(create: (_) => ToolOrderProvider()),
          ChangeNotifierProvider(create: (_) => ReportsProvider()),
          ChangeNotifierProvider(create: (_) => ReviewsProvider()),
          ChangeNotifierProvider(create: (_) => DropdownProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const LoginScreen(),
          theme: ThemeData(
            primaryColor: const Color(0xFF5D4037),
          ),
          onGenerateRoute: (settings) {
            if (settings.name == LoginScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const LoginScreen()),
              );
            }
            if (settings.name == HomeScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const HomeScreen()),
              );
            }
            if (settings.name == ClientListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const ClientListScreen()),
              );
            }
            if (settings.name == EmployeeListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const EmployeeListScreen()),
              );
            }
            if (settings.name == ProductListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const ProductListScreen()),
              );
            }
            if (settings.name == ProductOrderListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const ProductOrderListScreen()),
              );
            }
            if (settings.name == ToolOrderListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const ToolOrderListScreen()),
              );
            }
            if (settings.name == ProductCategoryListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const ProductCategoryListScreen()),
              );
            }
            if (settings.name == ToolCategoryListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const ToolCategoryListScreen()),
              );
            }
            if (settings.name == ToolListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const ToolListScreen()),
              );
            }
            if (settings.name == ReportScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const ReportScreen()),
              );
            }
            if (settings.name == CountryListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const CountryListScreen()),
              );
            }
            if (settings.name == CityListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const CityListScreen()),
              );
            }
            return MaterialPageRoute(
              builder: ((context) => const UnknownScreen()),
            );
          },
        ));
  }
}

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown Screen'),
      ),
      body: const Center(
        child: Text('Unknown Screen'),
      ),
    );
  }
}

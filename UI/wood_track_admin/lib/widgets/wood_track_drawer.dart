import 'package:wood_track_admin/screens/clients/client_list_screen.dart';
import 'package:wood_track_admin/screens/order/product_order_list_screen.dart';
import 'package:wood_track_admin/screens/order/tool_order_list_screen.dart';
import 'package:wood_track_admin/screens/reports/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wood_track_admin/screens/reviews/review_list_screen.dart';
import 'package:wood_track_admin/screens/toolCategories/toolCategory_list_screen.dart';
import 'package:wood_track_admin/screens/tools/tool_list_screen.dart';
import '../providers/login_provider.dart';
import '../screens/cities/city_list_screen.dart';
import '../screens/countries/country_list_screen.dart';
import '../screens/employees/employee_list_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/productCategories/productCategory_list_screen.dart';
import '../screens/products/product_list_screen.dart';

class WoodTrackDrawer extends StatefulWidget {
  const WoodTrackDrawer({super.key});

  @override
  _WoodTrackDrawerState createState() => _WoodTrackDrawerState();
}

class _WoodTrackDrawerState extends State<WoodTrackDrawer> {
  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: const Color(0xFF5D4037),
      elevation: 5,
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF5D4037),
              ),
              accountName: null,
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.construction,
                  size: 40,
                  color: Color(0xFF8D6E63),
                ),
              )),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_filled,
                  label: "Početna",
                  routeName: HomeScreen.routeName,
                  currentRoute: currentRoute,
                  route: const HomeScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  label: "Klijenti",
                  routeName: ClientListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ClientListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.badge_outlined,
                  activeIcon: Icons.badge,
                  label: "Uposlenici",
                  routeName: ClientListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const EmployeeListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.category_outlined,
                  activeIcon: Icons.category,
                  label: "Kategorije proizvoda",
                  routeName: ProductCategoryListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ProductCategoryListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.inventory_outlined, // Ikona za inventar
                  activeIcon: Icons.inventory,
                  label: "Proizvodi",
                  routeName: ProductListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ProductListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.category_outlined,
                  activeIcon: Icons.category,
                  label: "Alati",
                  routeName: ToolListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ToolListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.category_outlined,
                  activeIcon: Icons.category,
                  label: "Kategorije alata",
                  routeName: ToolCategoryListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ToolCategoryListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.local_shipping_outlined,
                  activeIcon: Icons.local_shipping,
                  label: "Narudžbe alata",
                  routeName: ProductOrderListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ToolOrderListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.local_shipping_outlined,
                  activeIcon: Icons.local_shipping,
                  label: "Narudžbe proizvoda",
                  routeName: ProductOrderListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ProductOrderListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.reviews,
                  activeIcon: Icons.local_shipping,
                  label: "Recenzije",
                  routeName: ReviewListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ReviewListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.assessment_outlined,
                  activeIcon: Icons.assessment,
                  label: "Izvještaji",
                  routeName: ReportScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ReportScreen(),
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                  height: 30,
                  color: Color(0xFFD7CCC8),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.public_outlined,
                  activeIcon: Icons.public,
                  label: "Države",
                  routeName: CountryListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const CountryListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.location_city_outlined,
                  activeIcon: Icons.location_city,
                  label: "Gradovi",
                  routeName: CityListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const CityListScreen(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                "Odjava",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                LoginProvider.setResponseFalse();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required IconData activeIcon,
        required String label,
        required String routeName,
        required String? currentRoute,
        required Widget route,
      }) {
    final isSelected = currentRoute == routeName;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFD7CCC8) : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? const Color(0xFFF3F2F2) : const Color(0xFFDDC8C8),
        ),
        title: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFFF3F2F2) : const Color(
                0xFFDDC8C8),
          ),
        ),
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => route),
          );
        },
      ),
    );
  }
}
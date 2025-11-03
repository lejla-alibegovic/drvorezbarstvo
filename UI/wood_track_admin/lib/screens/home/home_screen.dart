import 'package:wood_track_admin/screens/employees/employee_list_screen.dart';
import 'package:wood_track_admin/screens/clients/client_list_screen.dart';
import 'package:wood_track_admin/screens/productCategories/productCategory_list_screen.dart';
import 'package:wood_track_admin/screens/order/product_order_list_screen.dart';
import 'package:wood_track_admin/screens/products/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import '../../providers/dashboard_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DashboardProvider _dashboardProvider = DashboardProvider();
  Map<String, dynamic>? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      var response = await _dashboardProvider.getAdminData();
      setState(() {
        data = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.teal,
        ),
      )
          : data == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              "Nije moguće učitati podatke",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                "Pokušaj ponovo",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pregled statistički podataka",
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildCard(
                  "Klijenti",
                  Icons.people_alt,
                  data!['clients'].toString(),
                  Colors.blue.shade700,
                  ClientListScreen.routeName,
                ),
                _buildCard(
                  "Uposlenici",
                  Icons.badge,
                  data!['employees'].toString(),
                  Colors.green.shade700,
                  EmployeeListScreen.routeName,
                ),
                _buildCard(
                  "Proizvodi",
                  Icons.shopping_bag,
                  data!['products'].toString(),
                  Colors.purple.shade700,
                  ProductListScreen.routeName,
                ),
                _buildCard(
                  "Kategorije",
                  Icons.category,
                  data!['productCategories'].toString(),
                  Colors.red.shade700,
                  ProductCategoryListScreen.routeName,
                ),
                _buildCard(
                  "Narudžbe proizvoda",
                  Icons.shopping_cart,
                  data!['orders'].toString(),
                  Colors.teal.shade700,
                  ProductOrderListScreen.routeName,
                ),
                _buildCard(
                  "Uplaćeno",
                  Icons.payments,
                  "${data!['totalPayments']?.toString() ?? '0'} KM",
                  Colors.indigo.shade700,
                 HomeScreen.routeName,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      String title,
      IconData icon,
      String value,
      Color color,
      String routeName,
      ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Container(
          padding: const EdgeInsets.all(12), // Reduced padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Added this
            children: [
              Container(
                padding: const EdgeInsets.all(8), // Reduced padding
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24, // Reduced size
                  color: color,
                ),
              ),
              const SizedBox(height: 8), // Reduced spacing
              Flexible( // Added Flexible
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14, // Reduced font size
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1, // Ensure single line
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4), // Reduced spacing
              Flexible( // Added Flexible
                child: Text(
                  value,
                  style: GoogleFonts.montserrat(
                    fontSize: 18, // Reduced font size
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1, // Ensure single line
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wood_track_mobile/models/product.dart';
import 'package:wood_track_mobile/providers/cart_provider.dart';
import 'package:wood_track_mobile/providers/login_provider.dart';
import 'package:wood_track_mobile/screens/cart/cart_page.dart';
import 'package:wood_track_mobile/screens/login/login_screen.dart';
import 'package:wood_track_mobile/screens/product/product_cart.dart';
import 'package:wood_track_mobile/screens/product/product_list_page.dart';

class MainDashboard extends StatefulWidget {
  final List<Product> recommendations;
  final bool isLoading;
  final VoidCallback onRefresh;
  final PageController pageController;

  const MainDashboard({
    super.key,
    required this.recommendations,
    required this.isLoading,
    required this.onRefresh,
    required this.pageController,
  });

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 120,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Wood Track', style: TextStyle(color: Colors.white)),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.brown[800]!, Colors.brown[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              leading: Stack(
                alignment: Alignment.center,
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () => _showLogoutDialog(context),
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartPage()),
                        );
                      },
                    ),
                    if (cartProvider.itemCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cartProvider.itemCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),

            // Welcome Section
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.brown[50]!, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dobrodošli, ' + LoginProvider.authResponse!.firstName!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ručno izrađeni drveni proizvodi po vašoj mjeri',
                      style: TextStyle(color: Colors.brown[600]),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1517705008128-361805f42e86?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Tradicija kvalitete od 1952.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // All Products Section
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 16),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Proizvodi samo za Vas...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = widget.recommendations[index];
                    return ProductCard(product: product);
                  },
                  childCount: widget.recommendations.length,
                ),
              ),
            ),

            // See All Button
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[700],
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: Colors.brown[900]?.withOpacity(0.3),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductListPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.zoom_out_map, size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Pogledajte ostale proizvode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
            ),

            // About Us Section
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.brown[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'O nama',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Drvorez je porodična radnja sa tradicijom dužom od 70 godina. '
                          'Svaki naš proizvod je ručno izrađen sa pažnjom i ljubavlju prema drvetu. '
                          'Koristimo samo kvalitetne materijale i tradicionalne tehnike obrade.',
                      style: TextStyle(
                        color: Colors.brown[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Potvrda odjave', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Da li ste sigurni da se želite odjaviti?'),
        actions: [
          TextButton(
            child: Text('Odustani', style: TextStyle(color: Colors.brown[800])),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Odjavi se', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );

    if (confirmed == true) {
      Navigator.popAndPushNamed(context, LoginScreen.routeName);
    }
  }
}
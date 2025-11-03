import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wood_track_mobile/models/product.dart';
import 'package:wood_track_mobile/providers/recommender_provider.dart';
import 'package:wood_track_mobile/screens/home/dashboard_screen.dart';
import 'package:wood_track_mobile/screens/order/order_list_page.dart';
import 'package:wood_track_mobile/screens/user/profile_edit_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  List<Product> _recommendations = [

  ];

  bool _isRecommendationsLoading = false;

  Future<void> _loadRecommendations() async {
    if (_isRecommendationsLoading) return;

    setState(() => _isRecommendationsLoading = true);

    try {
      final recommendationsProvider = Provider.of<RecommendationProvider>(context, listen: false);
      final results = await recommendationsProvider.getRecommendations();
      if (mounted) {
        setState(() => _recommendations = results);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Greška prilikom učitavanja preporučenih proizvoda: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRecommendationsLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRecommendations());
  }


  @override
  Widget build(BuildContext context) {

    final List<Widget> _pages = [
      MainDashboard(
          recommendations: _recommendations,
          isLoading: _isRecommendationsLoading,
          onRefresh: _loadRecommendations,
          pageController: _pageController
      ),
      OrderListPage(),
      ProfileEditPage()
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Početna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reorder),
            label: 'Narudžbe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
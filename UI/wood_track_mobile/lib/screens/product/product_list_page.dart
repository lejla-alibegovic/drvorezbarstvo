import 'package:wood_track_mobile/helpers/image_helper.dart';
import 'package:wood_track_mobile/models/list_item.dart';
import 'package:wood_track_mobile/models/product.dart';
import 'package:wood_track_mobile/providers/cart_provider.dart';
import 'package:wood_track_mobile/providers/dropdown_provider.dart';
import 'package:wood_track_mobile/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wood_track_mobile/screens/cart/cart_page.dart';
import 'package:wood_track_mobile/screens/product/product_cart.dart';
import 'package:wood_track_mobile/screens/product/product_details_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  ProductProvider? _productProvider;
  final DropdownProvider _dropdownProvider = DropdownProvider();

  List<Product> _products = [];
  List<ListItem> _categories = [];
  int? _selectedCategoryId;
  String _searchQuery = '';

  int _page = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  _loadData() async {
    await _loadCategories();
    await _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadProducts();
    }
  }

  Future<void> _loadCategories() async {
    try {
      final items = await _dropdownProvider.getItems('product-categories');
      setState(() {
        _categories = [ListItem(key: 0, value: 'Svi proizvodi'), ...items];
        _selectedCategoryId = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text('Greška prilikom učitavanja kategorija: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _loadProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      var params = {
        'pageNumber': _page.toString(),
        'pageSize': _pageSize.toString(),
      };

      if (_selectedCategoryId != null && _selectedCategoryId != 0) {
        params['categoryId'] = _selectedCategoryId.toString();
      }

      if (_searchQuery.isNotEmpty) {
        params['searchFilter'] = _searchQuery;
      }

      final response = await _productProvider!.getForPagination(params);

      setState(() {
        _products.addAll(response.items);
        _hasMore = response.items.length >= _pageSize;
        _page++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text('Greška prilikom učitavanja proizvoda: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _refreshProducts() {
    setState(() {
      _products.clear();
      _page = 1;
      _hasMore = true;
    });
    _loadProducts();
  }

  void _onCategoryChanged(int? value) {
    setState(() {
      _selectedCategoryId = value;
    });
    _refreshProducts();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _refreshProducts();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proizvodi',
            style:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[800])),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.brown[50],
        iconTheme: IconThemeData(color: Colors.brown[800]),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.brown[800]),
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
                        constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          cartProvider.itemCount.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.brown[50],
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Pretraži proizvode...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                          : null,
                    ),
                    onChanged: _onSearch,
                  ),
                ),
                SizedBox(height: 12),
                // Category Dropdown
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<int>(
                      value: _selectedCategoryId,
                      items: _categories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.key,
                          child: Text(
                            category.value,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: _onCategoryChanged,
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Product List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _refreshProducts();
                return Future.value();
              },
              child: _products.isEmpty && !_isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nema proizvoda za prikaz',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (_searchQuery.isNotEmpty ||
                        _selectedCategoryId != 0)
                      TextButton(
                        onPressed: _refreshProducts,
                        child: Text('Prikaži sve proizvode'),
                      ),
                  ],
                ),
              )
                  : GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: EdgeInsets.all(8),
                itemCount: _products.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _products.length) {
                    return _hasMore
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox();
                  }
                  final product = _products[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
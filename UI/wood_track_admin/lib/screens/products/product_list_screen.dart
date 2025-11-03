import 'package:wood_track_admin/screens/products/product_add_screen.dart';
import 'package:wood_track_admin/screens/products/product_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:wood_track_admin/models/product.dart';
import 'package:wood_track_admin/providers/products_provider.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class ProductListScreen extends StatefulWidget {
  static const String routeName = "products";
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductProvider? _productProvider;
  final TextEditingController _searchController = TextEditingController();
  List<Product> data = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  String searchFilter = '';
  bool isLoading = true;
  String apiUrl = "";
  final bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    apiUrl = dotenv.env['API_URL_DOCKER']!;
    _productProvider = ProductProvider();
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    setState(() {
      isLoading = true;
    });

    if (searchFilter != '') {
      page = 1;
    }

    var response = await _productProvider?.getForPagination({
      'SearchFilter': searchFilter.toString(),
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
    });

    setState(() {
      data = response?.items as List<Product>;
      totalRecordCounts = response?.totalCount as int;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            _buildHeader(),
            _buildSearch(),
            Expanded(
              child: isLoading ? _buildShimmerLoader() : _buildList(),
            ),
            _buildPagination(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductAddScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Proizvodi",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          if (_isSearching)
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: _buildSearchField()),
            ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildSearchField(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        hintText: 'Pretraži proizvode...',
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.brown),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    searchFilter = '';
                    loadData(searchFilter, 1, pageSize);
                  });
                },
              )
            : null,
      ),
      onChanged: (value) {
        setState(() {
          searchFilter = value;
          loadData(searchFilter, 1, pageSize);
        });
      },
    );
  }

  Widget _buildShimmerLoader() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildList() {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined,
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "Nema pronađenih proizvoda",
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final product = data[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductEditScreen(id: product.id)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: product.isEnable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    product.isEnable ? "AKTIVAN" : "NEAKTIVAN",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Center(
                child: Container(
                  height: 80,
                  child:
                      (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[100],
                                  child: imageWidget(product.imageUrl)),
                            )
                          : _buildDefaultProductImage(),
                ),
              ),

              const SizedBox(height: 12),

              // Product name
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Category
              Text(
                product.productCategory?.name ?? "Bez kategorije",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${product.price.toStringAsFixed(2)} KM",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  Text(
                    "Stanje: ${product.stock}",
                    style: TextStyle(
                      fontSize: 12,
                      color: product.stock > 0 ? Colors.grey[800] : Colors.red,
                      fontWeight: product.stock <= 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultProductImage() {
    return const Center(
      child: Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.brown),
    );
  }

  Widget _buildPagination() {
    final totalPages = (totalRecordCounts / pageSize).ceil();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: page > 1
                ? () {
                    setState(() {
                      page--;
                      loadData(searchFilter, page, pageSize);
                    });
                  }
                : null,
          ),
          ...List.generate(
            totalPages,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () {
                  setState(() {
                    page = index + 1;
                    loadData(searchFilter, page, pageSize);
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: page == index + 1 ? Colors.brown : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      color: page == index + 1 ? Colors.white : Colors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: page < totalPages
                ? () {
                    setState(() {
                      page++;
                      loadData(searchFilter, page, pageSize);
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget imageWidget(String url) {
    if (url.isEmpty) {
      return Icon(Icons.image, color: Colors.grey[300], size: 40);
    }
    if (url.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        url,
        width: 50,
        height: 50,
        placeholderBuilder: (context) => Container(
          color: Colors.grey[100],
          child: Icon(Icons.image, color: Colors.grey[300]),
        ),
      );
    } else {
      return Image.network(
        apiUrl + url,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[100],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image, color: Colors.grey[300]);
        },
      );
    }
  }

  void _showDeleteDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              const Text("Potvrda brisanja"),
            ],
          ),
          content: Text(
            "Da li ste sigurni da želite obrisati proizvod ${product.name}?",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Odustani"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _deleteProduct(product.id);
              },
              child:
                  const Text("Obriši", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await _productProvider?.deleteById(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proizvod uspješno obrisan'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      loadData(searchFilter, 1, pageSize);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Greška pri brisanju proizvoda'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

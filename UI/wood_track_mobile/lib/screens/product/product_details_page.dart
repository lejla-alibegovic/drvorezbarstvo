import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wood_track_mobile/models/product.dart';
import 'package:wood_track_mobile/models/review.dart';
import 'package:wood_track_mobile/providers/cart_provider.dart';
import 'package:wood_track_mobile/providers/product_provider.dart';
import 'package:wood_track_mobile/providers/review_provider.dart';
import 'package:wood_track_mobile/utils/authorization.dart';
import 'package:wood_track_mobile/screens/cart/cart_page.dart';
import 'package:wood_track_mobile/helpers/image_helper.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;

  const ProductDetailsPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductProvider _productProvider;
  Product? _product;
  bool _isLoading = true;

  final _reviewFormKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;
  bool _showReviewForm = false;

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    setState(() => _isLoading = true);
    try {
      final p = await _productProvider.getById(widget.productId, null);
      setState(() {
        _product = p;
        _isLoading = false;
        _showReviewForm = false;
        _rating = 0;
        _commentController.clear();
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Greška prilikom učitavanja detalja: $e")),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (!_reviewFormKey.currentState!.validate()) return;
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Molimo odaberite ocjenu')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
      var review = Review(
        id: 0,
        clientId: Authorization.id!,
        productId: widget.productId,
        rating: _rating,
        comment: _commentController.text,
      );

      var success = await reviewProvider.insert(review);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Recenzija uspješno dodana' : 'Greška pri dodavanju recenzije'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      await _fetchProduct();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri slanju recenzije: ${e.toString()}')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Widget _buildReviewForm() {
    return Form(
      key: _reviewFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ocijenite proizvod:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 30,
                ),
                onPressed: () => setState(() => _rating = index + 1),
              );
            }),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Komentar (opcionalno)',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            maxLines: 3,
            validator: (value) {
              if (value != null && value.length > 500) {
                return 'Komentar ne smije biti duži od 500 znakova';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() => _showReviewForm = false),
                child: Text('Odustani',style: TextStyle(color: Colors.red)),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Pošalji', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${review.client?.firstName ?? ""} ${review.client?.lastName ?? ""}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  review.dateCreated != null
                      ? '${review.dateCreated!.day}.${review.dateCreated!.month}.${review.dateCreated!.year}'
                      : '',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            if (review.comment != null && review.comment!.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(review.comment!),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: true);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Detalji proizvoda"),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Detalji proizvoda")),
        body: Center(child: Text("Greška pri dohvaćanju proizvoda.")),
      );
    }

    final isCurrentUserReviewer = _product!.reviews.any(
            (review) => review.clientId == Authorization.id);

    CartItem? cartItem;
    try {
      cartItem = cartProvider.items.firstWhere((item) => item.product.id == _product!.id);
    } catch (e) {
      cartItem = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalji proizvoda"),
        backgroundColor: Colors.brown[50],
        iconTheme: IconThemeData(color: Colors.brown[800]),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(),
                    ),
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
      backgroundColor: Colors.brown[50],
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.brown[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImageHelper.buildImage(_product!.imageUrl),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_product!.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('${_product!.price.toStringAsFixed(2)} KM', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown[800])),
                    SizedBox(height: 16),
                    Text('Opis:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(_product!.description),
                    SizedBox(height: 16),
                    if (_product!.manufacturer != null && _product!.manufacturer!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Proizvođač:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(_product!.manufacturer!),
                          SizedBox(height: 16),
                        ],
                      ),
                    Text('Dimenzije:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('${_product!.length}cm x ${_product!.width}cm x ${_product!.height}cm'),
                    SizedBox(height: 24),

                    Text('Dojmovi:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    if (_product!.reviews.isEmpty)
                      Text('Trenutno nema dojmova za ovaj proizvod.')
                    else
                      Column(
                        children: _product!.reviews.map(_buildReviewItem).toList(),
                      ),

                    if (!_showReviewForm && !isCurrentUserReviewer)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                          label: Text('Ostavi dojam', style: TextStyle(color: Theme.of(context).primaryColor)),
                          onPressed: () => setState(() => _showReviewForm = true),
                        ),
                      ),
                    if (_showReviewForm) _buildReviewForm(),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (cartItem != null)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.brown[800]),
                          onPressed: () {
                            cartProvider.removeItem(_product!);
                          },
                        ),
                        Text(
                          cartItem.quantity.toString(),
                          style: TextStyle(color: Colors.brown[800], fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.brown[800]),
                          onPressed: () {
                            cartProvider.addItem(_product!);
                          },
                        ),
                      ],
                    )
                  else
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          cartProvider.addItem(_product!);
                        },
                        icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                        label: Text('Dodaj u košaricu', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
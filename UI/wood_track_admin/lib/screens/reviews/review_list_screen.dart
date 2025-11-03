import 'package:flutter/material.dart';
import 'package:wood_track_admin/models/product.dart';
import 'package:wood_track_admin/models/review.dart';
import 'package:wood_track_admin/models/user_model.dart';
import 'package:wood_track_admin/providers/reviews_provider.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReviewListScreen extends StatefulWidget {
  static const String routeName = "reviews";
  const ReviewListScreen({Key? key}) : super(key: key);

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<int> _ratingOptions = [0, 1, 2, 3, 4, 5];
  int _selectedRating = 0;
  bool _isLoading = true;
  List<Review> _reviews = [];
  int _page = 1;
  int _pageSize = 10;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reviewsProvider = Provider.of<ReviewsProvider>(context, listen: false);

      var params = {
        'PageNumber': _page.toString(),
        'PageSize': _pageSize.toString(),
        'SearchFilter': _searchController.text,
      };

      if (_selectedRating > 0){
        params['Rating'] = _selectedRating.toString();
      }

      final response = await reviewsProvider.getForPagination(params);

      setState(() {
        _reviews = response.items;
        _totalCount = response.totalCount;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri učitavanju recenzija: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow[700]!;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: _getRatingColor(rating),
          size: 20,
        );
      }),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16),
                hintText: 'Pretraži recenzije...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search,
                    color: Theme.of(context).primaryColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _loadData();
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                _loadData();
              },
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedRating,
                items: _ratingOptions.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value == 0 ? 'Sve ocjene' : '$value zvjezdica'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedRating = newValue!;
                    _loadData();
                  });
                },
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.product?.name ?? 'Proizvod #${review.product?.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildRatingStars(review.rating),
              ],
            ),
            const SizedBox(height: 8),
            if (review.client != null)
              Text(
                'Korisnik: ${review.client!.firstName} ${review.client!.lastName}',
                style: const TextStyle(color: Colors.grey),
              ),
            if (review.dateCreated != null)
              Text(
                'Datum: ${DateFormat('dd.MM.yyyy HH:mm').format(review.dateCreated!)}',
                style: const TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 12),
            if (review.comment != null && review.comment!.isNotEmpty)
              Text(
                review.comment!,
                style: const TextStyle(fontSize: 14),
              ),
            if (review.comment == null || review.comment!.isEmpty)
              const Text(
                'Nema komentara',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final totalPages = (_totalCount / _pageSize).ceil();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Prikazano ${_reviews.length} od $_totalCount zapisa',
            style: TextStyle(color: Colors.grey[600]),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left,
                    color: Theme.of(context).primaryColor),
                onPressed: _page > 1
                    ? () {
                  setState(() {
                    _page--;
                    _loadData();
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
                        _page = index + 1;
                        _loadData();
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _page == index + 1
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: _page == index + 1
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right,
                    color: Theme.of(context).primaryColor),
                onPressed: _page < totalPages
                    ? () {
                  setState(() {
                    _page++;
                    _loadData();
                  });
                }
                    : null,
              ),
            ],
          ),
          Row(
            children: [
              const Text('Zapisa po stranici:'),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _pageSize,
                    items: [5, 10, 20, 50].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _pageSize = newValue;
                          _page = 1;
                          _loadData();
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    if (_reviews.isEmpty) return const SizedBox();

    // Calculate average rating
    final averageRating = _reviews
        .map((r) => r.rating)
        .reduce((a, b) => a + b) /
        _reviews.length;

    // Count reviews by rating
    final ratingCounts = Map<int, int>.fromIterable(
      List.generate(5, (i) => i + 1),
      value: (rating) => _reviews.where((r) => r.rating == rating).length,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Statistika recenzija',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Prosječna ocjena:'),
                  const SizedBox(width: 8),
                  _buildRatingStars(averageRating.round()),
                  const SizedBox(width: 8),
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...ratingCounts.entries.map((entry) {
                final percentage = (_reviews.isNotEmpty)
                    ? (entry.value / _reviews.length * 100)
                    : 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: _buildRatingStars(entry.key),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: Colors.grey[200],
                              color: _getRatingColor(entry.key),
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${percentage.toStringAsFixed(1)}%'),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recenzije proizvoda",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            _buildSearchAndFilter(),
            _buildStatsSection(),
            Expanded(
              child: _isLoading
                  ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor))
                  : _reviews.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.reviews_outlined,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "Nema pronađenih recenzija",
                      style: TextStyle(
                          color: Colors.grey[600], fontSize: 18),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: _loadData,
                color: Theme.of(context).primaryColor,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    ..._reviews.map((review) => _buildReviewCard(review)),
                  ],
                ),
              ),
            ),
            _buildPaginationControls(),
          ],
        ),
      ),
    );
  }
}
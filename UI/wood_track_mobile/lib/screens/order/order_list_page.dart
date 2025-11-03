import 'package:wood_track_mobile/helpers/colors.dart';
import 'package:wood_track_mobile/models/order.dart';
import 'package:wood_track_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wood_track_mobile/providers/order_provider.dart';
import 'package:intl/intl.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Order> _orders = [];
  String _statusFilter = 'Sve';
  final List<String> _statusOptions = [
    'Sve',
    'Na čekanju',
    'Poslano',
    'Isporučeno',
    'Otkazano'
  ];
  int _currentPage = 1;
  int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_refreshOrders);
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialOrders());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_isLoading && _hasMore) {
        _loadMoreOrders();
      }
    }
  }

  Future<void> _loadInitialOrders() async {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
    });
    await _fetchOrders(reset: true);
  }

  Future<void> _loadMoreOrders() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _currentPage++;
    });
    await _fetchOrders();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
    });
    await _fetchOrders(reset: true);
  }

  Future<void> _fetchOrders({bool reset = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final params = {
        'pageNumber': _currentPage.toString(),
        'pageSize': _pageSize.toString(),
        'userId': Authorization.id.toString()
      };

      if (_statusFilter != 'Sve') {
        params['status'] = (_statusOptions.indexOf(_statusFilter) - 1).toString();
      }

      if (_searchController.text.isNotEmpty) {
        params['searchFilter'] = _searchController.text;
      }

      final response = await orderProvider.getForPagination(params);
      final newOrders = response.items;

      setState(() {
        if (newOrders.length < _pageSize) {
          _hasMore = false;
        }
        if (reset) {
          _orders = newOrders;
        } else {
          _orders.addAll(newOrders);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška pri učitavanju narudžbi: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getStatusText(int? status) {
    switch (status) {
      case 0:
        return 'Na čekanju';
      case 1:
        return 'Prihvaćeno';
      case 2:
        return 'Realizovano';
      case 3:
        return 'Otkazano';
      default:
        return 'N/A';
    }
  }

  Color _getStatusColor(int? status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _cancelOrder(Order order) async {
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Otkazivanje narudžbe'),
          content: const Text('Da li ste sigurni da želite otkazati ovu narudžbu?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Ne'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Da', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      setState(() => _isLoading = true);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      var result = await orderProvider.cancelOrder(order.id!);

      if (result) {
        setState(() {
          final index = _orders.indexOf(order);
          _orders[index].status = 3;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Narudžba je uspješno otkazana.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ova narudžba se ne može otkazati.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška prilikom otkazivanja narudžbe: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text('Moje narudžbe',
            style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown[50],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.brown[800]),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.brown[800]),
            onPressed: _refreshOrders,
          ),
        ],
      ),
      backgroundColor: Colors.brown[50],
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
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
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Pretraži narudžbe...',
                    prefixIcon: Icon(Icons.search, color: Colors.brown[800]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 12),
                // Status Filter
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<String>(
                      value: _statusFilter,
                      isExpanded: true,
                      items: _statusOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _statusFilter = newValue!;
                        });
                        _refreshOrders();
                      },
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.brown[800]),
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.brown[800]),
                      underline: SizedBox(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Order List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshOrders,
              color: Colors.brown[800],
              child: _orders.isEmpty && !_isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 64,
                      color: Colors.brown[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nema narudžbi',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.brown[600],
                      ),
                    ),
                    if (_statusFilter != 'Sve')
                      TextButton(
                        onPressed: () {
                          setState(() => _statusFilter = 'Sve');
                          _refreshOrders();
                        },
                        child: Text('Prikaži sve narudžbe'),
                      ),
                  ],
                ),
              )
                  : ListView.builder(
                controller: _scrollController,
                itemCount: _orders.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _orders.length) {
                    return _hasMore
                        ? Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.brown[800],
                        ),
                      ),
                    )
                        : SizedBox();
                  }

                  final order = _orders[index];
                  final canCancel = order.status == 0;

                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.brown[50],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '#${order.id}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[800],
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          '${dateFormat.format(order.date?.toLocal() ?? DateTime.now())} • ${timeFormat.format(order.date?.toLocal() ?? DateTime.now())}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${order.items.length} proizvoda • ${order.totalAmount.toStringAsFixed(2)} KM',
                          style: theme.textTheme.bodySmall,
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _getStatusText(order.status),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: _getStatusColor(order.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Customer Info
                                _buildDetailRow(
                                  icon: Icons.person,
                                  title: 'Kupac',
                                  value: order.fullName ?? 'N/A',
                                ),
                                _buildDetailRow(
                                  icon: Icons.phone,
                                  title: 'Telefon',
                                  value: order.phoneNumber ?? 'N/A',
                                ),
                                _buildDetailRow(
                                  icon: Icons.location_on,
                                  title: 'Adresa',
                                  value: order.address ?? 'N/A',
                                ),
                                if (order.note != null &&
                                    order.note!.isNotEmpty)
                                  _buildDetailRow(
                                    icon: Icons.note,
                                    title: 'Napomena',
                                    value: order.note!,
                                  ),
                                const SizedBox(height: 16),
                                // Order Items
                                Text(
                                  'Proizvodi',
                                  style: theme.textTheme.titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown[800],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...order.items.map((item) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.brown[300],
                                          borderRadius:
                                          BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${item.product!.name}',
                                              style: theme.textTheme
                                                  .bodyMedium,
                                            ),
                                            Text(
                                              '${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} KM',
                                              style: theme.textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                color:
                                                theme.hintColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${item.totalPrice.toStringAsFixed(2)} KM',
                                        style: theme.textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                const SizedBox(height: 16),
                                // Order Total
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ukupno:',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${order.totalAmount.toStringAsFixed(2)} KM',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown[800],
                                      ),
                                    ),
                                  ],
                                ),
                                if (canCancel) ...[
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () => _cancelOrder(order),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: Colors.red),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                      child: Text(
                                        'OTKAŽI NARUDŽBU',
                                        style: TextStyle(
                                            color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.brown[800],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
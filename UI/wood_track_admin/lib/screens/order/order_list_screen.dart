import 'package:wood_track_admin/models/order.dart';
import 'package:wood_track_admin/providers/orders_provider.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/reports_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class OrderListScreen extends StatefulWidget {
  static const String routeName = "orders";
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final OrderProvider _orderProvider = OrderProvider();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  List<Order> _orders = [];
  int _page = 1;
  int _pageSize = 10;
  int _totalCount = 0;
  bool _isLoading = true;
  final List<String> _statusOptions = [
    'Sve',
    'Na čekanju',
    'Poslano',
    'Isporučeno',
    'Otkazano'
  ];
  String _selectedStatus = 'Sve';
  String _selectedChangeStatus = 'Na čekanju';

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
      var params = {
        'PageNumber': _page.toString(),
        'PageSize': _pageSize.toString(),
        'SearchFilter': _searchController.text,
      };

      if (_selectedStatus != 'Sve') {
        params['Status'] =
            (_statusOptions.indexOf(_selectedStatus) - 1).toString();
      }

      final response = await _orderProvider.getForPagination(params);

      setState(() {
        _orders = response.items;
        _totalCount = response.totalCount;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri učitavanju narudžbi: ${e.toString()}"),
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

  Future<void> _generateReport() async {
    if (_orders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nema podataka za generisanje izvještaja"),
          backgroundColor: Colors.amber,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reportsProvider =
      Provider.of<ReportsProvider>(context, listen: false);
      final pdfBytes = await reportsProvider.downloadOrdersReport(
        searchFilter: _searchController.text,
        status: (_statusOptions.indexOf(_selectedStatus) - 1).toString(),
        pageNumber: _page,
        pageSize: _pageSize,
      );

      final directory = await getDownloadsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory!.path}/izvjestaj_narudzbi_$timestamp.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Izvještaj uspješno preuzet"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      await OpenFile.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Greška prilikom generisanja izvještaja"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showOrderDetails(Order order) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Detalji narudžbe #${order.id}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Order Summary
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Kupac:', order.fullName ?? 'N/A'),
                            if (order.transactionId?.isNotEmpty == true)
                              _buildDetailRow(
                                  'Broj transakcije:', order.transactionId ?? 'N/A'),
                            _buildDetailRow('Adresa:', order.address ?? 'N/A'),
                            _buildDetailRow('Telefon:', order.phoneNumber ?? 'N/A'),
                            _buildDetailRow(
                                'Datum:',
                                order.date != null
                                    ? DateFormat('dd.MM.yyyy HH:mm').format(order.date!)
                                    : 'N/A'),
                            _buildDetailRow(
                                'Status:', _getStatusText(order.status ?? 0)),
                            _buildDetailRow('Ukupno:',
                                '${order.totalAmount.toStringAsFixed(2)} KM'),
                            if (order.note != null && order.note!.isNotEmpty)
                              _buildDetailRow('Napomena:', order.note!),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      'Stavke narudžbe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Order Items
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: order.items.length,
                        itemBuilder: (context, index) {
                          final item = order.items[index];
                          return ListTile(
                            leading: Icon(Icons.shopping_basket,
                                color: Theme.of(context).primaryColor),
                            title: Text(item.product?.name ?? 'Proizvod #${item.productId}'),
                            subtitle: Text(
                                '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)} KM'),
                            trailing: Text(
                              '${(item.quantity * item.unitPrice).toStringAsFixed(2)} KM',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text('Zatvori'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Na čekanju';
      case 1:
        return 'Poslano';
      case 2:
        return 'Isporučeno';
      case 3:
        return 'Otkazano';
      default:
        return 'Nepoznat status';
    }
  }

  Color _getStatusColor(int? status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Theme.of(context).primaryColor;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateOrderStatus(Order order) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Promijeni status narudžbe',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _getStatusText(order.status ?? 0),
                      items: _statusOptions.sublist(1).map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedChangeStatus = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                          child: const Text('Odustani'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              // Map the selected status back to status code
                              int newStatus;
                              switch (_selectedChangeStatus) {
                                case 'Na čekanju':
                                  newStatus = 0;
                                  break;
                                case 'Poslano':
                                  newStatus = 1;
                                  break;
                                case 'Isporučeno':
                                  newStatus = 2;
                                  break;
                                case 'Otkazano':
                                  newStatus = 3;
                                  break;
                                default:
                                  newStatus = 0;
                              }

                              await _orderProvider.changeOrderStatus(
                                  order.id, newStatus);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      "Status narudžbe uspješno ažuriran"),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );

                              Navigator.pop(context);
                              _loadData();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Greška: ${e.toString()}"),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Spasi'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchField() {
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
                hintText: 'Pretraži narudžbe...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
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
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedStatus,
                items: _statusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
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
                    "Narudžbe",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.bar_chart, size: 20, color: Colors.white),
                        label: const Text(
                          "Izvještaj",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onPressed: _generateReport,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            ),
            _buildSearchField(),
            Expanded(
              child: _isLoading
                  ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor))
                  : _orders.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_outlined,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "Nema pronađenih narudžbi",
                      style: TextStyle(
                          color: Colors.grey[600], fontSize: 18),
                    ),
                  ],
                ),
              )
                  : Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: DataTable(
                          columnSpacing: 24,
                          horizontalMargin: 16,
                          headingRowColor:
                          WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) =>
                                Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                          ),
                          columns: [
                            DataColumn(
                              label: Text(
                                'Broj',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Kupac',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Datum',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Iznos',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Akcije',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                          rows: _orders.map((order) {
                            return DataRow(
                              cells: [
                                DataCell(Text('#${order.id}')),
                                DataCell(
                                  Text(order.fullName ?? 'N/A',
                                      overflow: TextOverflow.ellipsis),
                                ),
                                DataCell(
                                  Text(
                                    order.date != null
                                        ? DateFormat('dd.MM.yyyy')
                                        .format(order.date!)
                                        : 'N/A',
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      '${order.totalAmount.toStringAsFixed(2)} KM',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                            order.status)
                                            .withOpacity(0.2),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _getStatusColor(
                                              order.status),
                                        ),
                                      ),
                                      child: Text(
                                        _getStatusText(
                                            order.status ?? 0),
                                        style: TextStyle(
                                          color: _getStatusColor(
                                              order.status),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove_red_eye,
                                              color: Theme.of(context).primaryColor),
                                          onPressed: () =>
                                              _showOrderDetails(order),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () =>
                                              _updateOrderStatus(order),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
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
                    'Prikazano ${_orders.length} od $_totalCount zapisa',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left, color: Theme.of(context).primaryColor),
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
                        (_totalCount / _pageSize).ceil(),
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
                        icon: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
                        onPressed: _page < (_totalCount / _pageSize).ceil()
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
            ),
          ],
        ),
      ),
    );
  }
}
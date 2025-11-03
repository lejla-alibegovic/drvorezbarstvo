import 'package:flutter/material.dart';
import 'package:wood_track_admin/models/listItem.dart';
import 'package:wood_track_admin/models/tool_order.dart';
import 'package:wood_track_admin/providers/tool_orders_provider.dart';
import 'package:wood_track_admin/providers/dropdown_provider.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class ToolOrderListScreen extends StatefulWidget {
  static const String routeName = "tool-orders";

  const ToolOrderListScreen({Key? key}) : super(key: key);

  @override
  State<ToolOrderListScreen> createState() => _ToolOrderListScreenState();
}

class _ToolOrderListScreenState extends State<ToolOrderListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  bool _isLoading = true;
  List<ToolOrder> _toolOrders = [];
  int _page = 1;
  int _pageSize = 10;
  int _totalCount = 0;
  List<ListItem> _tools = [];
  DateTime? _selectedDeliveryDate;
  int? _selectedToolId;
  int _selectedQuantity = 1;
  ToolOrder? _editingOrder;
  ToolOrderProvider? _toolOrderProvider;

  @override
  void initState() {
    super.initState();
    _toolOrderProvider = ToolOrderProvider();
    _loadData();
    _loadTools();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _toolOrderProvider?.getForPagination({
        'PageNumber': _page.toString(),
        'PageSize': _pageSize.toString(),
        'SearchFilter': _searchController.text,
      });

      setState(() {
        _toolOrders = response?.items as List<ToolOrder>;
        _totalCount = response?.totalCount as int;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Greška pri učitavanju narudžbi alata: ${e.toString()}"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTools() async {
    try {
      final dropdownProvider =
      Provider.of<DropdownProvider>(context, listen: false);
      var response = await dropdownProvider.getItems("tools");
      setState(() {
        _tools = response as List<ListItem>;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri učitavanju alata: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _showAddToolOrderDialog() async {
    _selectedToolId = null;
    _selectedQuantity = 1;
    _selectedDeliveryDate = null;

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Dodaj narudžbu alata',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tool selection dropdown
                      DropdownButtonFormField<int>(
                        value: _selectedToolId,
                        decoration: InputDecoration(
                          labelText: 'Alat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        items: _tools.map((tool) {
                          return DropdownMenuItem<int>(
                            value: tool.key,
                            child: Text(tool.value),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            _selectedToolId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Ovo polje je obavezno';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Quantity input
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Količina',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _selectedQuantity.toString(),
                        onChanged: (value) {
                          setState(() {
                            _selectedQuantity = int.tryParse(value) ?? 1;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Unesite validan broj';
                          }
                          if (int.parse(value) <= 0) {
                            return 'Količina mora biti veća od 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Delivery date picker
                      InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate:
                            DateTime.now().add(const Duration(days: 7)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDeliveryDate = pickedDate;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Datum isporuke',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorText: _selectedDeliveryDate == null ? 'Ovo polje je obavezno' : null,
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDeliveryDate != null
                                    ? DateFormat('dd.MM.yyyy')
                                    .format(_selectedDeliveryDate!)
                                    : 'Odaberite datum',
                                style: TextStyle(
                                  color: _selectedDeliveryDate == null ? Colors.grey : Colors.black,
                                ),
                              ),
                              Icon(Icons.calendar_today,
                                  color: _selectedDeliveryDate == null ? Colors.grey : Colors.black),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action buttons
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
                              bool isDateValid = _selectedDeliveryDate != null;
                              if (!isDateValid) {
                                setState(() {});
                              }

                              if (_formKey.currentState!.validate() && isDateValid) {
                                try {
                                  await _toolOrderProvider?.insert({
                                    'toolId': _selectedToolId,
                                    'quantity': _selectedQuantity,
                                    'deliveryDate':
                                    _selectedDeliveryDate!.toIso8601String(),
                                    'userId': 1
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                      Text('Narudžba alata uspješno dodana'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  Navigator.pop(context);
                                  _loadData();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Greška pri dodavanju: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Spremi'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showEditToolOrderDialog(ToolOrder order) async {
    _editingOrder = order;
    _selectedToolId = order.toolId;
    _selectedQuantity = order.quantity;
    _selectedDeliveryDate = order.deliveryDate;

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
                child: Form(
                  key: _editFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Uredi narudžbu alata',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tool selection dropdown
                      DropdownButtonFormField<int>(
                        value: _selectedToolId,
                        decoration: InputDecoration(
                          labelText: 'Alat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        items: _tools.map((tool) {
                          return DropdownMenuItem<int>(
                            value: tool.key,
                            child: Text(tool.value),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            _selectedToolId = value;
                          });
                        },
                        validator: (value) => value == null ? 'Ovo polje je obavezno' : null,
                      ),
                      const SizedBox(height: 16),

                      // Quantity input
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Količina',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _selectedQuantity.toString(),
                        onChanged: (value) {
                          setState(() {
                            _selectedQuantity = int.tryParse(value) ?? 1;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ovo polje je obavezno';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Unesite validan broj';
                          }
                          if (int.parse(value) <= 0) {
                            return 'Količina mora biti veća od 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Delivery date picker
                      InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDeliveryDate ??
                                DateTime.now().add(const Duration(days: 7)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDeliveryDate = pickedDate;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Datum isporuke',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorText: _selectedDeliveryDate == null ? 'Ovo polje je obavezno' : null,
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDeliveryDate != null
                                    ? DateFormat('dd.MM.yyyy')
                                    .format(_selectedDeliveryDate!)
                                    : 'Odaberite datum',
                                style: TextStyle(
                                  color: _selectedDeliveryDate == null ? Colors.grey : Colors.black,
                                ),
                              ),
                              Icon(Icons.calendar_today,
                                  color: _selectedDeliveryDate == null ? Colors.grey : Colors.black),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action buttons
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
                              bool isDateValid = _selectedDeliveryDate != null;
                              if (!isDateValid) {
                                setState(() {});
                              }

                              if (_editFormKey.currentState!.validate() && isDateValid) {
                                try {
                                  await _toolOrderProvider
                                      ?.update(_editingOrder!.id, {
                                    'id': _editingOrder!.id,
                                    'toolId': _selectedToolId,
                                    'quantity': _selectedQuantity,
                                    'deliveryDate':
                                    _selectedDeliveryDate!.toIso8601String(),
                                    'userId': _editingOrder!.userId
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                      Text('Narudžba alata uspješno ažurirana'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  Navigator.pop(context);
                                  _loadData();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Greška pri ažuriranju: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Spremi'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteToolOrder(int id) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Column(
          children: [
            Icon(Icons.warning_rounded, size: 48, color: Colors.orange),
            SizedBox(height: 10),
            Text('Potvrda brisanja',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
            'Da li ste sigurni da želite obrisati ovu narudžbu alata?',
            textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: Colors.brown,
            ),
            child: const Text('Odustani'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Obriši'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _toolOrderProvider?.deleteById(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Narudžba alata uspješno obrisana'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        _loadData();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Greška pri brisanju: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<pw.Font> _loadCustomFont() async {
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    return pw.Font.ttf(fontData);
  }

  Future<void> _generatePdf(ToolOrder order) async {
    final customFont = await _loadCustomFont();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Wood Track d.o.o.',
                    style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        font: customFont),
                  ),
                  pw.Text(
                    'Narudžba alata',
                    style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.brown,
                        font: customFont),
                  ),
                ],
              ),
              pw.Divider(thickness: 1, color: PdfColors.brown),
              pw.SizedBox(height: 16),

              // Order Details Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.brown, width: 1),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.brown100),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Detalji narudžbe',
                          style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.brown,
                              font: customFont),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                            'Alat: ${order.tool?.name ?? 'Nepoznato'}',
                            style: pw.TextStyle(font: customFont)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Količina: ${order.quantity}',
                            style: pw.TextStyle(font: customFont)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                            'Naručio: ${order.user?.firstName ?? ''} ${order.user?.lastName ?? ''}',
                            style: pw.TextStyle(font: customFont)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                            'Datum isporuke: ${DateFormat('dd.MM.yyyy').format(order.deliveryDate)}'),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                            'Status: ${order.deliveryDate.isBefore(DateTime.now()) ? 'Isporučeno' : 'U tijeku'}',
                            style: pw.TextStyle(font: customFont)),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 24),

              // Footer
              pw.Divider(thickness: 1, color: PdfColors.brown),
              pw.Text(
                'Hvala na povjerenju!',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.brown,
                ),
              ),
              pw.Text(
                'Wood Track d.o.o. | woodtrack.com | info@woodtrack.com',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
              ),
            ],
          );
        },
      ),
    );

    final downloadsDirectory = await getDownloadsDirectory();
    if (downloadsDirectory != null) {
      final file =
      File('${downloadsDirectory.path}/narudzba_alata_${order.id}.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF narudžbe uspješno generisan: ${file.path}'),
          backgroundColor: Colors.green,
        ),
      );

      await OpenFile.open(file.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška: Downloads folder nije pronađen'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showSendEmailDialog() async {
    final TextEditingController _toController = TextEditingController();
    final TextEditingController _subjectController = TextEditingController();
    final TextEditingController _bodyController = TextEditingController();
    File? _selectedFile;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _emailFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pošalji email dobavljaču',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // To (email) field
                        TextFormField(
                          controller: _toController,
                          decoration: InputDecoration(
                            labelText: 'Za (email)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ovo polje je obavezno';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Unesite validnu email adresu';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Subject field
                        TextFormField(
                          controller: _subjectController,
                          decoration: InputDecoration(
                            labelText: 'Naslov',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ovo polje je obavezno';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Body field
                        TextFormField(
                          controller: _bodyController,
                          decoration: InputDecoration(
                            labelText: 'Sadržaj',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignLabelWithHint: true,
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ovo polje je obavezno';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Attachment section
                        Text(
                          'Prilog:',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final result =
                                await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );
                                if (result != null) {
                                  setState(() {
                                    _selectedFile =
                                        File(result.files.single.path!);
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown[100],
                                foregroundColor: Colors.brown,
                              ),
                              child: const Text('Odaberi fajl'),
                            ),
                            const SizedBox(width: 10),
                            if (_selectedFile != null)
                              Expanded(
                                child: Text(
                                  _selectedFile!.path.split('/').last,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Action buttons
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
                                if (_emailFormKey.currentState!.validate()) {
                                  try {
                                    String? attachmentBase64;
                                    String? attachmentName;

                                    Map<String, dynamic> data = {
                                      'to': _toController.text,
                                      'subject': _subjectController.text,
                                      'body': _bodyController.text,
                                    };

                                    if (_selectedFile != null) {
                                      final bytes = await _selectedFile!.readAsBytes();

                                      data['file'] = http.MultipartFile.fromBytes(
                                        'file',
                                        bytes,
                                        filename: _selectedFile!.path.split('/').last,
                                      );
                                    }

                                    await _toolOrderProvider?.sendOrderEmail(data);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Email uspješno poslat'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Greška pri slanju emaila: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Pošalji'),
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
      },
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
                    "Narudžbe alata",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _showSendEmailDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.email, size: 20),
                            SizedBox(width: 8),
                            Text("Pošalji email"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _showAddToolOrderDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Kreiraj narudžbu"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildSearchField(),
            Expanded(
              child: _isLoading
                  ? const Center(
                  child: CircularProgressIndicator(color: Colors.brown))
                  : _toolOrders.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.construction_outlined,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "Nema pronađenih narudžbi alata",
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
                          headingRowColor: MaterialStateProperty
                              .resolveWith<Color>(
                                (Set<MaterialState> states) =>
                                Colors.brown.withOpacity(0.1),
                          ),
                          columns: const [
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Alat',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Količina',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Naručio',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Datum isporuke',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Status',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Akcije',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                          rows: _toolOrders.map((order) {
                            final isPastDue = order.deliveryDate
                                .isBefore(DateTime.now());
                            return DataRow(
                              cells: [
                                DataCell(Text(
                                    order.tool?.name ?? 'Nepoznato')),
                                DataCell(
                                    Text(order.quantity.toString())),
                                DataCell(Text(
                                    '${order.user?.firstName ?? ''} ${order.user?.lastName ?? ''}')),
                                DataCell(Text(DateFormat('dd.MM.yyyy')
                                    .format(order.deliveryDate))),
                                DataCell(
                                  Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isPastDue
                                          ? Colors.green[50]
                                          : Colors.orange[50],
                                      borderRadius:
                                      BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isPastDue
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
                                    child: Text(
                                      isPastDue
                                          ? 'Isporučeno'
                                          : 'U tijeku',
                                      style: TextStyle(
                                        color: isPastDue
                                            ? Colors.green
                                            : Colors.orange,
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
                                          icon: const Icon(
                                              Icons.picture_as_pdf,
                                              color: Colors.brown),
                                          onPressed: () =>
                                              _generatePdf(order),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.email,
                                              color: Colors.blue),
                                          onPressed: _showSendEmailDialog,
                                        ),
                                        if (isPastDue)
                                          const Tooltip(
                                            message:
                                            'Narudžba je već isporučena - nije moguće uređivati',
                                            child: Icon(Icons.lock,
                                                color: Colors.grey),
                                          ),
                                        if (!isPastDue)
                                          IconButton(
                                            icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue),
                                            onPressed: () =>
                                                _showEditToolOrderDialog(
                                                    order),
                                          ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              _deleteToolOrder(
                                                  order.id),
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
            _buildPaginationControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          hintText: 'Pretraži narudžbe alata...',
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
              _loadData();
            },
          )
              : null,
        ),
        onChanged: (value) {
          _loadData();
        },
      ),
    );
  }

  Widget _buildPaginationControls() {
    final totalPages = (_totalCount / _pageSize).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Prikazano ${_toolOrders.length} od $_totalCount zapisa',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
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
                            ? Colors.brown
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color:
                          _page == index + 1 ? Colors.white : Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
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
              DropdownButton<int>(
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
            ],
          ),
        ],
      ),
    );
  }
}
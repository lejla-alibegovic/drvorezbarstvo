import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:wood_track_admin/models/listItem.dart';
import 'package:wood_track_admin/screens/tools/tool_add_screen.dart';
import 'package:wood_track_admin/screens/tools/tool_edit_screen.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/tool.dart';
import '../../providers/dropdown_provider.dart';
import '../../providers/tools_provider.dart';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:file_saver/file_saver.dart';
import '../../providers/reports_provider.dart';

class ToolListScreen extends StatefulWidget {
  static const String routeName = "tools";
  const ToolListScreen({Key? key}) : super(key: key);

  @override
  State<ToolListScreen> createState() => _ToolListScreenState();
}

class _ToolListScreenState extends State<ToolListScreen> {
  final TextEditingController _searchController = TextEditingController();
  ToolProvider? _toolProvider;
  DropdownProvider? _dropdownProvider;
  List<Tool> data = [];
  List<ListItem> categories = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  String searchFilter = '';
  ListItem? selectedCategory;
  DateTime? selectedLastServiceDate;
  bool isLoading = true;
  String apiUrl = "";
  final bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    apiUrl = dotenv.env['API_URL_DOCKER']!;
    _toolProvider = ToolProvider();
    _dropdownProvider = DropdownProvider();
    loadCategories();
    loadData(searchFilter, page, pageSize);
  }

  Future<void> loadCategories() async {
      final categoriesResponse = await _dropdownProvider?.getItems("tool-categories");
      setState(() {
        categories = categoriesResponse as List<ListItem>;
      });
  }

  Future loadData(searchFilter, page, pageSize) async {
    setState(() {
      isLoading = true;
    });

    if (searchFilter != '') {
      page = 1;
    }

    var response = await _toolProvider?.getForPagination({
      'SearchFilter': searchFilter.toString(),
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
      if (selectedCategory != null) 'CategoryId': selectedCategory!.key.toString(),
      if (selectedLastServiceDate != null)
        'LastServiceDate': DateFormat('yyyy-MM-dd').format(selectedLastServiceDate!),
    });

    setState(() {
      data = response?.items as List<Tool>;
      totalRecordCounts = response?.totalCount as int;
      isLoading = false;
    });
  }

  Future<void> _generateReport() async {
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Nema podataka za generisanje izvještaja"),
          backgroundColor: Colors.yellow[800],
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final reportsProvider = Provider.of<ReportsProvider>(context, listen: false);
      final pdfBytes = await reportsProvider.downloadToolsReport(
        searchFilter: searchFilter,
        categoryId: selectedCategory?.key,
        lastServiceDate: selectedLastServiceDate != null ? DateFormat('yyyy-MM-dd').format(selectedLastServiceDate!) : null,
        pageNumber: page,
        pageSize: pageSize,
      );

      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = "izvjestaj_alata_$timestamp.pdf";

      final filePath = await FileSaver.instance.saveFile(
        name: fileName,
        bytes: pdfBytes as Uint8List,
        ext: "pdf",
        mimeType: MimeType.pdf,
      );

      if (filePath != null) {
        await OpenFile.open(filePath);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Izvještaj uspješno preuzet i otvoren"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška prilikom generisanja izvještaja: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
            _buildFilters(),
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
              MaterialPageRoute(builder: (_) => const ToolAddScreen()),
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
            "Alati",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.bar_chart, size: 20),
                label: const Text("Izvještaj"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.brown[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: _generateReport,
              ),
            ],
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

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<ListItem>(
              value: selectedCategory,
              hint: const Text("Kategorija"),
              onChanged: (ListItem? newValue) {
                setState(() {
                  selectedCategory = newValue;
                  loadData(searchFilter, 1, pageSize);
                });
              },
              items: categories.map((ListItem category) {
                return DropdownMenuItem<ListItem>(
                  value: category,
                  child: Text(category.value),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedLastServiceDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedLastServiceDate = picked;
                    loadData(searchFilter, 1, pageSize);
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Datum zadnjeg servisa",
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  selectedLastServiceDate != null
                      ? DateFormat('dd.MM.yyyy').format(selectedLastServiceDate!)
                      : "Odaberi datum",
                ),
              ),
            ),
          ),
          if (selectedCategory != null || selectedLastServiceDate != null)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.red),
              onPressed: () {
                setState(() {
                  selectedCategory = null;
                  selectedLastServiceDate = null;
                  loadData(searchFilter, 1, pageSize);
                });
              },
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
        hintText: 'Pretraži alate...',
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
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 16),
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
              "Nema pronađenih alata",
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final tool = data[index];
        return _buildToolCard(tool);
      },
    );
  }

  Widget _buildToolCard(Tool tool) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ToolEditScreen(id: tool.id)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tool.code,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tool.toolCategory.name ?? "Nekategorizirano",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Tool name
              Text(
                tool.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (tool.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    tool.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

              // Divider
              const Divider(height: 20, thickness: 1),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Dimension
                  _buildDetailItem(
                    icon: Icons.straighten,
                    label: "Dimenzija",
                    value: "${tool.dimension.toStringAsFixed(2)} cm",
                  ),

                  _buildDetailItem(
                    icon: Icons.calendar_today,
                    label: "Datum kreiranja",
                    value: DateFormat('dd.MM.yyyy').format(tool.dateCreated),
                  ),

                  if (tool.chargedDate != null)
                    _buildDetailItem(
                      icon: Icons.calendar_today,
                      label: "Datum zaduženja",
                      value: DateFormat('dd.MM.yyyy').format(tool.chargedDate!),
                    ),

                  if(tool.chargedByUser != null)
                  _buildDetailItem(
                    icon: Icons.person,
                    label: "Zadužio",
                    value: '${tool.chargedByUser!.firstName!} ${tool.chargedByUser!.lastName!}' ??
                        "Nepoznato",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.brown),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Chip(
      backgroundColor: Colors.brown.withOpacity(0.1),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.brown),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: Colors.brown.shade800)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.brown),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
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
                    color:
                        page == index + 1 ? Colors.brown : Colors.transparent,
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

  void _showDeleteDialog(BuildContext context, Tool tool) {
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
            "Da li ste sigurni da želite obrisati alat ${tool.name}?",
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
                await _deleteTool(tool.id);
              },
              child:
                  const Text("Obriši", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTool(int id) async {
    try {
      await _toolProvider?.deleteById(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alat uspješno obrisan'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      loadData(searchFilter, 1, pageSize);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Greška pri brisanju alata'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

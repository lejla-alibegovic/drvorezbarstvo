import 'package:flutter/material.dart';
import 'package:wood_track_admin/models/appUser.dart';
import 'package:wood_track_admin/providers/users_provider.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shimmer/shimmer.dart';
import 'employee_add_screen.dart';
import 'employee_edit_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  static const String routeName = "employees";
  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  UserProvider? _userProvider;
  final TextEditingController _searchController = TextEditingController();
  List<AppUser> data = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  String searchFilter = '';
  bool isLoading = true;
  final String apiUrl = dotenv.env['API_URL_DOCKER']!;

  @override
  void initState() {
    super.initState();
    _userProvider = UserProvider();
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    setState(() {
      isLoading = true;
    });

    if (searchFilter != '') {
      page = 1;
    }

    var response = await _userProvider?.getForPagination({
      'SearchFilter': searchFilter.toString(),
      'IsEmployee': 'true',
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
    });

    setState(() {
      data = response?.items as List<AppUser>;
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
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Uposlenici",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Dodaj uposlenika'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EmployeeAddScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            _buildSearchField(),
            Expanded(
              child: isLoading
                  ? const Center(
                  child: CircularProgressIndicator(color: Colors.brown))
                  : data.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_alt_outlined,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "Nema pronađenih uposlenika",
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
                          MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) =>
                                Colors.brown.withOpacity(0.1),
                          ),
                          columns: const [
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Slika',
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
                                  'Ime i prezime',
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
                                  'Pozicija',
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
                                  'Email',
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
                                  'Telefon',
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
                          rows: data.map((user) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.brown[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: (user.profilePhoto != null)
                                        ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        user.profilePhoto!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            _buildDefaultAvatar(),
                                      ),
                                    )
                                        : _buildDefaultAvatar(),
                                  ),
                                ),
                                DataCell(
                                  Text('${user.firstName} ${user.lastName}'),
                                ),
                                DataCell(
                                  Text(user.position ?? '-'),
                                ),
                                DataCell(
                                  Text(user.email ?? '-'),
                                ),
                                DataCell(
                                  Text(user.phoneNumber ?? '-'),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => EmployeeEditScreen(id: user.id)),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _showDeleteDialog(context, user);
                                          },
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
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          hintText: 'Pretraži uposlenike...',
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
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return const Center(
      child: Icon(Icons.person, size: 24, color: Colors.brown),
    );
  }

  Widget _buildPaginationControls() {
    final totalPages = (totalRecordCounts / pageSize).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Prikazano ${data.length} od $totalRecordCounts zapisa',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Row(
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
                        color: page == index + 1
                            ? Colors.brown
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color:
                          page == index + 1 ? Colors.white : Colors.brown,
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
          Row(
            children: [
              const Text('Zapisa po stranici:'),
              const SizedBox(width: 10),
              DropdownButton<int>(
                value: pageSize,
                items: [5, 10, 20, 50].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      pageSize = newValue;
                      page = 1;
                      loadData(searchFilter, page, pageSize);
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

  void _showDeleteDialog(BuildContext context, AppUser user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
          content: Text(
              'Da li ste sigurni da želite obrisati uposlenika ${user.firstName} ${user.lastName}?',
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
              onPressed: () async {
                Navigator.pop(context, true);
                await _deleteEmployee(user.id);
              },
              child: const Text('Obriši'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEmployee(int id) async {
    try {
      await _userProvider?.deleteById(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Uposlenik uspješno obrisan"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      loadData(searchFilter, 1, pageSize);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri brisanju uposlenika: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
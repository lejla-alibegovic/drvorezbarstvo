import 'package:flutter/material.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import '../../models/city.dart';
import '../../models/country.dart';
import '../../providers/cities_provider.dart';
import '../../providers/countries_provider.dart';

class CityListScreen extends StatefulWidget {
  static const String routeName = "cities";
  const CityListScreen({Key? key}) : super(key: key);

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  final CityProvider _cityProvider = CityProvider();
  final CountryProvider _countryProvider = CountryProvider();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _abrvController = TextEditingController();

  List<City> _cities = [];
  List<Country> _countries = [];
  int _page = 1;
  int _pageSize = 10;
  int _totalCount = 0;
  bool _isLoading = true;
  bool _isActive = false;
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCountries();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _cityProvider.getForPagination({
        'PageNumber': _page.toString(),
        'PageSize': _pageSize.toString(),
        'SearchFilter': _searchController.text,
      });

      setState(() {
        _cities = response.items;
        _totalCount = response.totalCount;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri učitavanju gradova: ${e.toString()}"),
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

  Future<void> _loadCountries() async {
    try {
      final response = await _countryProvider.getForPagination({
        'PageNumber': '1',
        'PageSize': '999',
      });

      setState(() {
        _countries = response.items;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri učitavanju država: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _showAddEditDialog({City? city}) async {
    final isEdit = city != null;
    _nameController.text = city?.name ?? '';
    _abrvController.text = city?.abrv ?? '';
    _isActive = city?.isActive ?? false;

    Country? selectedCountry;
    if (city?.country != null) {
      selectedCountry = _countries.firstWhere(
            (c) => c.id == city?.country?.id,
        orElse: () => _countries.first,
      );
    } else {
      selectedCountry = _countries.isNotEmpty ? _countries.first : null;
    }

    final _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isEdit ? 'Uredi grad' : 'Dodaj grad',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Naziv grada*',
                            prefixIcon: const Icon(Icons.location_city,
                                color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.brown, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Unesite naziv grada';
                            }
                            if (value.length < 2) {
                              return 'Naziv mora imati najmanje 2 karaktera';
                            }
                            if (value.length > 50) {
                              return 'Naziv može imati najviše 50 karaktera';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _abrvController,
                          decoration: InputDecoration(
                            labelText: 'Skraćenica*',
                            prefixIcon: const Icon(Icons.short_text, color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.brown, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Unesite skraćenicu';
                            }
                            if (value.length < 2) {
                              return 'Skraćenica mora imati najmanje 2 karaktera';
                            }
                            if (value.length > 10) {
                              return 'Skraćenica može imati najviše 10 karaktera';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<Country>(
                          value: selectedCountry,
                          decoration: InputDecoration(
                            labelText: 'Država*',
                            prefixIcon: const Icon(Icons.flag, color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.brown, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          items: _countries.map((Country country) {
                            return DropdownMenuItem<Country>(
                              value: country,
                              child: Text(country.name),
                            );
                          }).toList(),
                          onChanged: (Country? value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          },
                          validator: (value) =>
                          value == null ? 'Odaberite državu' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Aktivan'),
                            Checkbox(
                              value: _isActive,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isActive = value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                foregroundColor: Colors.brown,
                              ),
                              child: const Text('Odustani'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final newCity = City();
                                    newCity.id = city?.id ?? 0;
                                    newCity.name = _nameController.text;
                                    newCity.abrv = _abrvController.text;
                                    newCity.isActive = _isActive;
                                    newCity.countryId = selectedCountry!.id;

                                    if (isEdit) {
                                      await _cityProvider.update(newCity.id, newCity);
                                    } else {
                                      await _cityProvider.insert(newCity);
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(isEdit
                                            ? "Grad uspješno izmijenjen"
                                            : "Grad uspješno dodan"),
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
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Spasi'),
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

  Future<void> _deleteCity(int id) async {
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
        content: const Text('Da li ste sigurni da želite obrisati ovaj grad?',
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
        await _cityProvider.deleteById(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Grad uspješno obrisan"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        _loadData();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Greška pri brisanju: ${e.toString()}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          hintText: 'Pretraži gradove...',
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
                    "Gradovi",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Dodaj grad'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _showAddEditDialog(),
                  ),
                ],
              ),
            ),
            _buildSearchField(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.brown))
                  : _cities.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_city_outlined,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                "Nema pronađenih gradova",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: ListView(children: [
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
                                        Colors.brown.withOpacity(0.1),
                                  ),
                                  columns: const [
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Naziv',
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
                                          'Skraćenica',
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
                                          'Država',
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
                                          'Aktivan',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown,
                                          ),
                                          textAlign: TextAlign.center,
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
                                  rows: _cities.map((city) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Row(
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.brown[100],
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    city.name
                                                        .substring(0, 1)
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.brown,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(city.name),
                                            ],
                                          ),
                                        ),
                                        DataCell(Text(city.abrv)),
                                        DataCell(Text(
                                            city.country?.name ?? 'Nepoznato')),
                                        DataCell(
                                          Center(
                                            child: Checkbox(
                                              value: city.isActive,
                                              onChanged: null,
                                              activeColor: Colors.brown,
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
                                                  icon: const Icon(Icons.edit,
                                                      color: Colors.blue),
                                                  onPressed: () =>
                                                      _showAddEditDialog(
                                                          city: city),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.red),
                                                  onPressed: () =>
                                                      _deleteCity(city.id),
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
                            )
                          ])),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildPaginationControls(),
                ),
              ],
            ),
          ],
        ),
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
              'Prikazano ${_cities.length} od $_totalCount zapisa',
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
                        color: _page == index + 1 ? Colors.brown : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: _page == index + 1 ? Colors.white : Colors.brown,
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

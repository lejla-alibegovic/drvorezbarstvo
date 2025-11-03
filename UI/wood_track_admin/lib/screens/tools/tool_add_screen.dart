import 'package:intl/intl.dart';
import 'package:wood_track_admin/models/tool.dart';
import 'package:wood_track_admin/providers/tools_provider.dart';
import 'package:flutter/material.dart';
import 'package:wood_track_admin/models/listItem.dart';
import 'package:wood_track_admin/providers/dropdown_provider.dart';
import 'package:wood_track_admin/screens/tools/tool_list_screen.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';

class ToolAddScreen extends StatefulWidget {
  static const String routeName = "tool/add";
  const ToolAddScreen({super.key});

  @override
  State<ToolAddScreen> createState() => _ToolAddScreenState();
}

class _ToolAddScreenState extends State<ToolAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dimensionController = TextEditingController();
  final _chargedDateController = TextEditingController();
  final _lastServiceDateController = TextEditingController();

  DropdownProvider? _dropdownProvider;
  ToolProvider? _toolProvider;
  List<ListItem> categories = [];
  List<ListItem> employees = [];
  ListItem? _selectedCategory;
  ListItem? _selectedEmployee;
  DateTime? _selectedChargedDate;
  DateTime? _selectedLastServiceDate;
  bool _isNeedNewService = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dropdownProvider = DropdownProvider();
    _toolProvider = ToolProvider();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final categoriesResponse = await _dropdownProvider?.getItems("tool-categories");
      final employeesResponse = await _dropdownProvider?.getItems("employees");

      setState(() {
        categories = categoriesResponse as List<ListItem>;
        employees = employeesResponse as List<ListItem>;
        if (categories.isNotEmpty) _selectedCategory = categories[0];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri učitavanju podataka: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectChargedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedChargedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.brown,
              onPrimary: Colors.white,
              onSurface: Colors.brown,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.brown,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedChargedDate) {
      setState(() {
        _selectedChargedDate = picked;
        _chargedDateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  Future<void> _selectLastServiceDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedLastServiceDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.brown,
              onPrimary: Colors.white,
              onSurface: Colors.brown,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.brown,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedLastServiceDate) {
      setState(() {
        _selectedLastServiceDate = picked;
        _lastServiceDateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dodaj novi alat", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.brown,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBasicInfoCard(),
                const SizedBox(height: 20),
                _buildDetailsCard(),
                const SizedBox(height: 30),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Osnovne informacije",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _nameController,
              label: 'Naziv alata',
              icon: Icons.shopping_bag_outlined,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Unesite naziv alata'
                  : null,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<ListItem>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: "Kategorija",
                prefixIcon: const Icon(Icons.category_outlined, color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: Colors.grey[800]),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
              onChanged: (ListItem? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: categories.map((ListItem category) {
                return DropdownMenuItem<ListItem>(
                  value: category,
                  child: Text(category.value),
                );
              }).toList(),
              validator: (value) => value == null
                  ? 'Odaberite kategoriju'
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Detalji alata",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _codeController,
                    label: 'Šifra',
                    icon: Icons.qr_code,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildTextField(
                    controller: _dimensionController,
                    label: 'Dimenzija (cm)',
                    icon: Icons.straighten,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Unesite dimenziju';
                      if (double.tryParse(value!) == null) return 'Unesite validnu dimenziju';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<ListItem>(
              value: _selectedEmployee,
              decoration: InputDecoration(
                labelText: "Zadužio",
                prefixIcon: const Icon(Icons.person_outline, color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: Colors.grey[800]),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
              onChanged: (ListItem? newValue) {
                setState(() {
                  _selectedEmployee = newValue;
                });
              },
              items: employees.map((ListItem employee) {
                return DropdownMenuItem<ListItem>(
                  value: employee,
                  child: Text(employee.value),
                );
              }).toList(),
              validator: (value) => value == null
                  ? 'Odaberite uposlenika'
                  : null,
            ),
            const SizedBox(height: 15),
            _buildDateField(
              controller: _chargedDateController,
              label: 'Datum zaduženja',
              onTap: () => _selectChargedDate(context),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Odaberite datum zaduženja'
                  : null,
            ),
            const SizedBox(height: 15),
            _buildDateField(
              controller: _lastServiceDateController,
              label: 'Datum zadnjeg servisa',
              onTap: () => _selectLastServiceDate(context)
            ),
            const SizedBox(height: 15),
            SwitchListTile(
              title: const Text('Potreban novi servis'),
              value: _isNeedNewService,
              activeColor: Colors.brown,
              onChanged: (bool value) {
                setState(() {
                  _isNeedNewService = value;
                });
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Opis alata',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.description_outlined, color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Unesite opis alata'
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            foregroundColor: Colors.brown,
          ),
          child: const Text('Odustani'),
        ),
        const SizedBox(width: 15),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Spasi'),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.brown),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.brown, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.brown),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.brown, width: 2),
        ),
      ),
      onTap: onTap,
      validator: validator,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        DateFormat('yyyy-MM-dd').format(_selectedChargedDate!);
        final newTool = Tool();
        newTool.id = 0;
        newTool.code = _codeController.text;
        newTool.name = _nameController.text;
        newTool.description = _descriptionController.text;
        newTool.dimension = double.tryParse(_dimensionController.text) ?? 0.00;
        newTool.chargedDate = _selectedChargedDate;
        newTool.lastServiceDate = _selectedLastServiceDate;
        newTool.isNeedNewService = _isNeedNewService;
        newTool.toolCategoryId = _selectedCategory!.key;
        newTool.chargedByUserId = (_selectedEmployee?.key)!;
        
        bool? result = await _toolProvider?.insert(newTool);

        if (result == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Alat uspješno dodan"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ToolListScreen(),
            ),
          );
        } else {
          throw Exception("Greška pri spremanju podataka o alatu.");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Greška pri dodavanju alata: ${e.toString()}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _chargedDateController.dispose();
    _lastServiceDateController.dispose();
    _dimensionController.dispose();
    super.dispose();
  }
}
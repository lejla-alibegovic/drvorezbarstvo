import 'package:wood_track_admin/screens/employees/employee_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wood_track_admin/models/listItem.dart';
import 'package:wood_track_admin/providers/dropdown_provider.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../providers/users_provider.dart';

class EmployeeAddScreen extends StatefulWidget {
  static const String routeName = "employee/add";
  const EmployeeAddScreen({super.key});

  @override
  State<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends State<EmployeeAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _workingHoursController = TextEditingController();

  DropdownProvider? _dropdownProvider;
  UserProvider? _userProvider;
  dynamic bytes;
  dynamic _imageFile;
  List<ListItem> countries = [];
  List<ListItem> genders = [
    ListItem(key: 1, value: "Muški"),
    ListItem(key: 2, value: "Ženski"),
    ListItem(key: 3, value: "Ostalo"),
  ];
  List<ListItem> positions = [
    ListItem(key: 1, value: "Vođa smjene"),
    ListItem(key: 2, value: "Vođa odjela"),
    ListItem(key: 3, value: "Mašinski radnik"),
    ListItem(key: 4, value: "Radnik na laseru"),
    ListItem(key: 5, value: "Tehničar"),
  ];
  ListItem? _selectedCountry;
  ListItem? _selectedGender;
  ListItem? _selectedPosition;
  DateTime? _selectedDate;

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Unesite broj telefona';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Broj telefona može sadržavati samo brojeve';
    }
    if (value.length < 7) {
      return 'Broj telefona mora imati najmanje 7 cifara';
    }
    return null;
  }

  String? _validateYearsOfExperience(String? value) {
    if (value == null || value.isEmpty) {
      return 'Unesite godine iskustva';
    }
    final years = int.tryParse(value);
    if (years == null) {
      return 'Unesite validan broj';
    }
    if (years < 0 || years > 50) {
      return 'Godine iskustva moraju biti između 0 i 50';
    }
    return null;
  }

  String? _validateWorkingHours(String? value) {
    if (value == null || value.isEmpty) {
      return 'Unesite radno vrijeme';
    }
    if (!RegExp(r'^[0-9: -]+$').hasMatch(value)) {
      return 'Unesite validan format (npr. 08:00-16:00)';
    }
    return null;
  }

  String? _validateLicenseNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Unesite broj licence';
    }
    if (value.length < 5) {
      return 'Broj licence mora imati najmanje 5 karaktera';
    }
    return null;
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _imageFile = null;
    _dropdownProvider = DropdownProvider();
    _userProvider = UserProvider();
    _loadCountries();
  }

  Future _loadCountries() async {
    var response = await _dropdownProvider?.getItems("countries");
    setState(() {
      countries = response as List<ListItem>;
      if (countries.isNotEmpty) {
        _selectedCountry = countries[0];
      }
      if (positions.isNotEmpty) {
        _selectedPosition = positions[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dodaj novog uposlenika",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.brown,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.brown.withOpacity(0.5)),
                                  ),
                                  child: _imageFile != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      bytes,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : const Icon(Icons.person, size: 60, color: Colors.brown),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  icon:
                                  const Icon(Icons.photo_camera, size: 18),
                                  label: const Text('Dodaj sliku'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.brown,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: _selectImage,
                                ),
                              ],
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          controller: _firstNameController,
                                          label: 'Ime',
                                          icon: Icons.person_outline,
                                          validator: (value) =>
                                          value?.isEmpty ?? true
                                              ? 'Unesite ime'
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: _buildTextField(
                                          controller: _lastNameController,
                                          label: 'Prezime',
                                          icon: Icons.person_outline,
                                          validator: (value) =>
                                          value?.isEmpty ?? true
                                              ? 'Unesite prezime'
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  _buildTextField(
                                    controller: _usernameController,
                                    label: 'Korisničko ime',
                                    icon: Icons.alternate_email,
                                    validator: (value) => value?.isEmpty ?? true
                                        ? 'Unesite korisničko ime'
                                        : null,
                                  ),
                                  const SizedBox(height: 15),
                                  _buildTextField(
                                    controller: _emailController,
                                    label: 'Email',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true)
                                        return 'Unesite email';
                                      if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value!)) {
                                        return 'Unesite validan email';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
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
                          "Dodatne informacije",
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
                                controller: _addressController,
                                label: 'Adresa',
                                icon: Icons.home_outlined,
                                validator: (value) => value?.isEmpty ?? true
                                    ? 'Unesite adresu'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildTextField(
                                controller: _phoneController,
                                label: 'Telefon',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: _validatePhone,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _birthDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Datum rođenja',
                            prefixIcon:
                            const Icon(Icons.calendar_today, color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                              BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                              BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.brown, width: 2),
                            ),
                          ),
                          onTap: () => _selectDate(context),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Odaberite datum rođenja'
                              : null,
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<ListItem>(
                          value: _selectedGender,
                          decoration: InputDecoration(
                            labelText: "Spol",
                            prefixIcon:
                            const Icon(Icons.person_outline, color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: genders.map((ListItem gender) {
                            return DropdownMenuItem<ListItem>(
                              value: gender,
                              child: Text(gender.value),
                            );
                          }).toList(),
                          onChanged: (ListItem? newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                          validator: (value) =>
                          value == null ? 'Odaberite spol' : null,
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<ListItem>(
                          value: _selectedCountry,
                          decoration: InputDecoration(
                            labelText: "Država",
                            prefixIcon: const Icon(Icons.flag_outlined,
                                color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: TextStyle(color: Colors.grey[800]),
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.brown),
                          onChanged: (ListItem? newValue) {
                            setState(() {
                              _selectedCountry = newValue!;
                            });
                          },
                          items: countries.map((ListItem country) {
                            return DropdownMenuItem<ListItem>(
                              value: country,
                              child: Text(country.value),
                            );
                          }).toList(),
                          validator: (value) =>
                          value == null ? 'Odaberite državu' : null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Napomene',
                            alignLabelWithHint: true,
                            prefixIcon: const Icon(Icons.note_outlined,
                                color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Unesite napomene'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
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
                          "Profesionalne informacije",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<ListItem>(
                          value: _selectedPosition,
                          decoration: InputDecoration(
                            labelText: "Pozicija",
                            prefixIcon:
                            const Icon(Icons.work_outline, color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: positions.map((ListItem position) {
                            return DropdownMenuItem<ListItem>(
                              value: position,
                              child: Text(position.value),
                            );
                          }).toList(),
                          onChanged: (ListItem? newValue) {
                            setState(() {
                              _selectedPosition = newValue!;
                            });
                          },
                          validator: (value) =>
                          value == null ? 'Odaberite poziciju' : null,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _licenseNumberController,
                          label: 'Broj licence',
                          icon: Icons.badge_outlined,
                          validator: _validateLicenseNumber,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _yearsOfExperienceController,
                                label: 'Godine iskustva',
                                icon: Icons.timeline,
                                keyboardType: TextInputType.number,
                                validator: _validateYearsOfExperience,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildTextField(
                                controller: _workingHoursController,
                                label: 'Radno vrijeme (npr. 08:00-16:00)',
                                icon: Icons.access_time,
                                validator: _validateWorkingHours,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final formattedDate =
        DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now());

        final Map<String, dynamic> formData = {
          'Id': '0',
          'FirstName': _firstNameController.text,
          'LastName': _lastNameController.text,
          'UserName': _usernameController.text,
          'Email': _emailController.text,
          'PhoneNumber': _phoneController.text,
          'BirthDate': formattedDate,
          'Address': _addressController.text,
          'Gender': _selectedGender?.key.toString() ?? '3',
          'Description': _notesController.text,
          'IsEmployee': 'true',
          'CountryId': _selectedCountry?.key.toString(),
          'Position': _selectedPosition?.value,
          'LicenseNumber': _licenseNumberController.text,
          'YearsOfExperience': _yearsOfExperienceController.text,
          'WorkingHours': _workingHoursController.text,
        };

        if (bytes != null) {
          formData['file'] = http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: 'image.jpg',
          );
        }

        bool? result = await _userProvider?.insertFormData(formData);

        if (result != null && result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uposlenik uspješno dodan'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EmployeeListScreen(),
            ),
          );
        } else {
          throw Exception("Greška pri spremanju podataka o uposleniku.");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Greška pri dodavanju uposlenika: ${e.toString()}'),
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _licenseNumberController.dispose();
    _yearsOfExperienceController.dispose();
    _workingHoursController.dispose();
    super.dispose();
  }
}
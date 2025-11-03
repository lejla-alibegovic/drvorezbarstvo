import 'package:wood_track_admin/screens/clients/client_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wood_track_admin/models/listItem.dart';
import 'package:wood_track_admin/providers/dropdown_provider.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../providers/users_provider.dart';

class ClientEditScreen extends StatefulWidget {
  static const String routeName = "clients/edit";
  final int id;
  const ClientEditScreen({super.key, required this.id});

  @override
  State<ClientEditScreen> createState() => _ClientEditScreenState();
}

class _ClientEditScreenState extends State<ClientEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  DropdownProvider? _dropdownProvider;
  UserProvider? _userProvider;
  dynamic bytes;
  dynamic _imageFile;
  String? _existingProfilePhoto;
  List<ListItem> countries = [];
  List<ListItem> genders = [
    ListItem(key: 1, value: "Muški"),
    ListItem(key: 2, value: "Ženski"),
    ListItem(key: 3, value: "Ostalo"),
  ];
  ListItem? _selectedCountry;
  ListItem? _selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = true;

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageFile = pickedFile;
        _existingProfilePhoto = null;
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
    _dropdownProvider = DropdownProvider();
    _userProvider = UserProvider();
    _initData();
  }

  Future<void> _initData() async {
    await _loadCountries();
    await _loadClientData();
  }

  Future<void> _loadClientData() async {
    try {
      final client = await _userProvider?.getById(widget.id, null);
      if (client != null) {
        setState(() {
          _firstNameController.text = client.firstName;
          _lastNameController.text = client.lastName;
          _usernameController.text = client.userName;
          _emailController.text = client.email;
          _phoneController.text = client.phoneNumber;
          _addressController.text = client.address;
          _notesController.text = client.description ?? '';
          _selectedDate = client.birthDate;
          _birthDateController.text =
              DateFormat('dd.MM.yyyy').format(client.birthDate);
          _existingProfilePhoto = client.profilePhoto;

          _selectedGender = genders.firstWhere(
            (g) => g.key == client.gender,
            orElse: () => genders[0],
          );

          _selectedCountry = countries.firstWhere(
                (p) => p.key == client.countryId,
            orElse: () => countries[0],
          );

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Greška pri učitavanju podataka klijenta"),
            backgroundColor: Colors.red,
          ),
        );
      }
      Navigator.pop(context);
    }
  }

  Future _loadCountries() async {
    var response = await _dropdownProvider?.getItems("countries");
    setState(() {
      countries = response as List<ListItem>;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return MasterScreenWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Uredi klijenta",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.brown,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
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
                                    border: Border.all(
                                        color: Colors.brown.withOpacity(0.5)),
                                  ),
                                  child: _imageFile != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.memory(
                                            bytes!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : _existingProfilePhoto != null
                                          ? ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              child: Image.network(
                                                _existingProfilePhoto!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60, color: Colors.brown),
                                              ),
                                            )
                                          : const Icon(Icons.person, size: 60, color: Colors.brown),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  icon:
                                      const Icon(Icons.photo_camera, size: 18),
                                  label: const Text('Promijeni sliku'),
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
                                Icon(Icons.calendar_today, color: Colors.brown),
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
                            prefixIcon: const Icon(Icons.person_outline,
                                color: Colors.brown),
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
                          items: countries.map((ListItem country) {
                            return DropdownMenuItem<ListItem>(
                              value: country,
                              child: Text(country.value),
                            );
                          }).toList(),
                          onChanged: (ListItem? newValue) {
                            setState(() {
                              _selectedCountry = newValue;
                            });
                          },
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

  Widget _buildLargeTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        prefixIcon: Icon(icon, color: Colors.brown),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: validator,
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
          'Id': widget.id.toString(),
          'FirstName': _firstNameController.text,
          'LastName': _lastNameController.text,
          'UserName': _usernameController.text,
          'Email': _emailController.text,
          'PhoneNumber': _phoneController.text,
          'BirthDate': formattedDate,
          'Address': _addressController.text,
          'Gender': _selectedGender?.key.toString() ?? '3',
          'Description': _notesController.text,
          'IsClient': 'true'
        };

        if (_imageFile != null && bytes != null) {
          formData['file'] = http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: 'image.jpg',
          );
        }

        bool? result = await _userProvider?.updateFormData(formData);

        if (result != null && result) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Klijent uspješno ažuriran"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ClientListScreen()),
            );
          }
        } else {
          throw Exception("Greška pri spremanju podataka o klijentu.");
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Greška pri dodavanju klijenta: ${e.toString()}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Brisanje klijenta'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Jeste li sigurni da želite obrisati ovog klijenta?'),
                Text('Ova akcija je nepovratna.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Odustani'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Obriši', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await _deleteClient();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteClient() async {
    try {
      await _userProvider?.deleteById(widget.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Klijent uspješno obrisan"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ClientListScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri brisanju klijenta: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
    super.dispose();
  }
}

import 'package:wood_track_mobile/models/list_item.dart';
import 'package:wood_track_mobile/models/user_upsert_model.dart';
import 'package:wood_track_mobile/providers/base_provider.dart';
import 'package:wood_track_mobile/providers/dropdown_provider.dart';
import 'package:wood_track_mobile/providers/user_provider.dart';
import 'package:wood_track_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  DropdownProvider? _dropdownProvider;
  UserProvider? _usersProvider;
  DateTime? _birthDate;
  ListItem? _selectedGender;
  dynamic bytes;
  dynamic _imageFile;
  String? _existingProfilePhoto;
  List<ListItem> genders = [];
  bool _isPasswordSectionExpanded = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dropdownProvider = context.read<DropdownProvider>();
    _usersProvider = context.read<UserProvider>();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    loadUser();
  }

  Future<void> loadUser() async {
    setState(() => _isLoading = true);
    await loadGenders();

    try {
      var response = await _usersProvider!.getById(Authorization.id!, null);
      setState(() {
        _firstNameController.text = response.firstName;
        _lastNameController.text = response.lastName;
        _emailController.text = response.email;
        _phoneController.text = response.phoneNumber;
        _addressController.text = response.address;
        _birthDate = response.birthDate;
        _selectedGender = genders.firstWhere((x) => x.key == response.gender);
        _existingProfilePhoto = response.profilePhoto;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška pri učitavanju profila: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> loadGenders() async {
    try {
      var response = await _dropdownProvider!.getItems("genders");
      setState(() => genders = response ?? []);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška pri učitavanju spolova: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = pickedFile;
          _existingProfilePhoto = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška pri odabiru slike: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _birthDate) {
      setState(() => _birthDate = picked);
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final formData = <String, dynamic>{
        'id': Authorization.id!,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'userName': _emailController.text,
        'phoneNumber': _phoneController.text,
        'birthDate': _birthDate,
        'address': _addressController.text,
        'gender': _selectedGender?.key,
      };

      if (_newPasswordController.text.isNotEmpty) {
        formData['newPassword'] = _newPasswordController.text;
      }
      if (_oldPasswordController.text.isNotEmpty) {
        formData['oldPassword'] = _oldPasswordController.text;
      }

      if (bytes != null) {
        formData['file'] = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'image.jpg',
        );
      }

      final success = await _usersProvider!.updateFormData(formData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Profil uspješno ažuriran' : 'Greška pri ažuriranju profila'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška pri ažuriranju profila: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Uredi profil',
            style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown[50],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.brown[800]),
      ),
      backgroundColor: Colors.brown[50],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Photo
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: theme.primaryColor),
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
                          "${BaseProvider.apiUrl}/${_existingProfilePhoto!}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 60, color: theme.primaryColor),
                        ),
                      )
                          : Icon(Icons.person,
                          size: 60, color: theme.primaryColor),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Personal Information Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lični podaci', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 16),

                      // First Name Field
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'Ime',
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Unesite ime';
                          if (value.length < 2) return 'Ime mora imati najmanje 2 karaktera';
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZšđčćžŠĐČĆŽ\s]')),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Last Name Field
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Prezime',
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Unesite prezime';
                          if (value.length < 2) return 'Prezime mora imati najmanje 2 karaktera';
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZšđčćžŠĐČĆŽ\s]')),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email (disabled)
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).primaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Broj telefona',
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          prefixIcon: Icon(Icons.phone_outlined, color: Theme.of(context).primaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Unesite broj telefona';
                          if (!RegExp(r'^[0-9+]+$').hasMatch(value)) return 'Samo brojevi i + su dozvoljeni';
                          if (value.length < 8) return 'Broj mora imati najmanje 8 cifara';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Datum rođenja',
                            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                            prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _birthDate != null
                                      ? '${_birthDate!.day}.${_birthDate!.month}.${_birthDate!.year}'
                                      : 'Odaberite datum',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      DropdownButtonFormField<ListItem>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Spol',
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          prefixIcon: Icon(Icons.transgender, color: Theme.of(context).primaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        items: genders.map((gender) {
                          return DropdownMenuItem<ListItem>(
                            value: gender,
                            child: Text(gender.value),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedGender = value),
                        validator: (value) => value == null ? 'Odaberite spol' : null,
                      ),
                      const SizedBox(height: 16),

                      // Address
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Adresa',
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          prefixIcon: Icon(Icons.home_outlined, color: Theme.of(context).primaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Unesite adresu';
                          if (value.length < 5) return 'Adresa mora imati najmanje 5 karaktera';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text('Promjena lozinke', style: theme.textTheme.titleMedium),
                  initiallyExpanded: false,
                  onExpansionChanged: (expanded) => setState(() => _isPasswordSectionExpanded = expanded),
                  trailing: Icon(
                    _isPasswordSectionExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _oldPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Trenutna lozinka',
                              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                              prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                            ),
                            obscureText: true,
                            validator: _isPasswordSectionExpanded
                                ? (value) => value == null || value.isEmpty ? 'Unesite trenutnu lozinku' : null
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _newPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Nova lozinka',
                              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                              prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                            ),
                            obscureText: true,
                            validator: _isPasswordSectionExpanded
                                ? (value) {
                              if (value == null || value.isEmpty) return 'Unesite novu lozinku';
                              if (value.length < 6) return 'Lozinka mora imati najmanje 6 karaktera';
                              return null;
                            }
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Potvrdi lozinku',
                              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                              prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                            ),
                            obscureText: true,
                            validator: _isPasswordSectionExpanded
                                ? (value) {
                              if (value == null || value.isEmpty) return 'Potvrdite lozinku';
                              if (value != _newPasswordController.text) return 'Lozinke se ne podudaraju';
                              return null;
                            }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('SPREMI PROMJENE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
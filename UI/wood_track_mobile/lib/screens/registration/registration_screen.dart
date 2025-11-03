import 'package:wood_track_mobile/models/registration_model.dart';
import 'package:wood_track_mobile/providers/dropdown_provider.dart';
import 'package:wood_track_mobile/providers/registration_provider.dart';
import 'package:wood_track_mobile/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../helpers/date_time_helper.dart';
import '../../models/list_item.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = "registration";

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  RegistrationProvider? _registrationProvider;
  DropdownProvider? _dropdownProvider;
  List<ListItem> _genders = [];
  ListItem? _selectedGender = null;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5D4037),
              onPrimary: Colors.white,
              onSurface: Color(0xFF5D4037),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF5D4037),
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
        _dateOfBirthController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dropdownProvider = context.read<DropdownProvider>();
    _registrationProvider = context.read<RegistrationProvider>();
    _loadGenders();
  }

  Future<void> _loadGenders() async {
    try {
      final response = await _dropdownProvider?.getItems("genders");
      setState(() {
        _genders = response ?? [];
        _selectedGender = _genders.isNotEmpty ? _genders.first : null;
      });
    } catch (e) {
      print("Error loading genders: $e");
      setState(() {
        _genders = [];
        _selectedGender = null;
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lozinke se ne podudaraju'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        var newUser = RegistrationModel();

        newUser.id = 0;
        newUser.firstName = _firstNameController.text;
        newUser.lastName = _lastNameController.text;
        newUser.email = _emailController.text;
        newUser.phoneNumber = _phoneController.text;
        newUser.userName = _emailController.text;
        newUser.birthDate = DateTimeHelper.stringToDateTime(_dateOfBirthController.text).toLocal();
        newUser.gender = _selectedGender!.key;
        newUser.address = _addressController.text;

        final result = await _registrationProvider?.registration(newUser);

        if (result == true) {
          await _showSuccessDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Greška prilikom registracije'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Greška: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text(
              'Registracija uspješna!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Vaš račun je uspješno kreiran. Sada se možete prijaviti u aplikaciju.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D4037),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              child: const Text('PRIJAVI SE', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          height: 80,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Registracija",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFF5D4037),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Kreirajte svoj račun",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.brown.shade600,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Personal Info Section
                        _buildSectionHeader("Lični podaci"),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _firstNameController,
                          label: "Ime",
                          icon: Icons.person_outline,
                          validator: (value) => value?.isEmpty ?? true ? 'Unesite ime' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                            controller: _lastNameController,
                            label: "Prezime",
                            icon: Icons.person_outline,
                            validator: (value) => value?.isEmpty ?? true ? 'Unesite prezime' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextFormField(
                            controller: _dateOfBirthController,
                            label: "Datum rođenja",
                            icon: Icons.calendar_today,
                            validator: (value) => value?.isEmpty ?? true ? 'Unesite datum rođenja' : null,
                            onTap: () => _selectDate(context),
                          ),
                          const SizedBox(height: 16),
                        DropdownButtonFormField<ListItem>(
                          key: Key('genderDropdown'),
                          value: _selectedGender,
                          onChanged: (ListItem? newValue) {
                            setState(() {
                              _selectedGender = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Spol",
                            prefixIcon: const Icon(
                              Icons.transgender_outlined,
                              color: const Color(0xFF5D4037),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF00796B),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Odaberite spol';
                            }
                            return null;
                          },
                          items: _genders.map((ListItem item) {
                            return DropdownMenuItem<ListItem>(
                              value: item,
                              child: Text(item.value),
                            );
                          }).toList(),
                          hint: const Text('Odaberite spol'),
                        ),

                        // Contact Info Section
                        const SizedBox(height: 24),
                        _buildSectionHeader("Kontakt podaci"),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _phoneController,
                          label: "Telefon",
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return 'Unesite broj telefona';
                            if (!RegExp(r'^\d{9,15}$').hasMatch(value!)) {
                              return 'Broj mora imati 9-15 cifara';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _addressController,
                          label: "Adresa",
                          icon: Icons.home_outlined,
                          validator: (value) => value?.isEmpty ?? true ? 'Unesite adresu' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: _emailController,
                          label: "Email",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return 'Unesite email';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                              return 'Unesite validan email';
                            }
                            return null;
                          },
                        ),

                        // Register Button
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5D4037),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            onPressed: _isLoading ? null : _register,
                            child: _isLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                                : const Text(
                              'REGISTRUJ SE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Login Link
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Već imate račun?"),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, LoginScreen.routeName),
                              child: const Text(
                                "Prijavite se",
                                style: TextStyle(
                                  color: Color(0xFF5D4037),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.brown)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF5D4037),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Colors.brown)),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    FormFieldValidator<String>? validator,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _buildInputDecoration(label, icon).copyWith(
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onTap: onTap,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: onTap != null,
    );
  }
}
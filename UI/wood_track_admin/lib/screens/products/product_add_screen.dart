import 'package:wood_track_admin/screens/products/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wood_track_admin/models/listItem.dart';
import 'package:wood_track_admin/providers/dropdown_provider.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import 'package:http/http.dart' as http;
import '../../providers/products_provider.dart';

class ProductAddScreen extends StatefulWidget {
  static const String routeName = "product/add";
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _heightController = TextEditingController();
  final _widthController = TextEditingController();
  final _lengthController = TextEditingController();
  final _stockController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _ingredientsController = TextEditingController();

  DropdownProvider? _dropdownProvider;
  ProductProvider? _productProvider;
  dynamic bytes;
  dynamic _imageFile;
  List<ListItem> categories = [];
  ListItem? _selectedCategory;
  bool _isEnable = true;

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _imageFile = null;
    _dropdownProvider = DropdownProvider();
    _productProvider = ProductProvider();
    _loadCategories();
  }

  Future _loadCategories() async {
    var response = await _dropdownProvider?.getItems("product-categories");
    setState(() {
      categories = response as List<ListItem>;
      if (categories.isNotEmpty) {
        _selectedCategory = categories[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dodaj novi proizvod",
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
                                    border: Border.all(
                                        color: Colors.brown.withOpacity(0.5)),
                                  ),
                                  child: _imageFile != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.memory(
                                            bytes,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(Icons.shopping_bag_outlined,
                                          size: 60, color: Colors.brown),
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
                                  _buildTextField(
                                    controller: _nameController,
                                    label: 'Naziv proizvoda',
                                    icon: Icons.shopping_bag_outlined,
                                    validator: (value) => value?.isEmpty ?? true
                                        ? 'Unesite naziv proizvoda'
                                        : null,
                                  ),
                                  const SizedBox(height: 15),
                                  DropdownButtonFormField<ListItem>(
                                    value: _selectedCategory,
                                    decoration: InputDecoration(
                                      labelText: "Kategorija",
                                      prefixIcon: const Icon(
                                          Icons.category_outlined,
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
                                        _selectedCategory = newValue!;
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
                          "Detalji proizvoda",
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
                                controller: _priceController,
                                label: 'Cijena (KM)',
                                icon: Icons.attach_money_outlined,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (value) {
                                  if (value?.isEmpty ?? true)
                                    return 'Unesite cijenu';
                                  if (double.tryParse(value!) == null)
                                    return 'Unesite validnu cijenu';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildTextField(
                                controller: _stockController,
                                label: 'Stanje (kom)',
                                icon: Icons.inventory_outlined,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value?.isEmpty ?? true)
                                    return 'Unesite količinu';
                                  if (int.tryParse(value!) == null)
                                    return 'Unesite validan broj';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _heightController,
                                label: 'Visina (cm)',
                                icon: Icons.attach_money_outlined,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (value) {
                                  if (value?.isEmpty ?? true)
                                    return 'Unesite visinu';
                                  if (double.tryParse(value!) == null)
                                    return 'Unesite validnu visinu';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildTextField(
                                controller: _widthController,
                                label: 'Širina (cm)',
                                icon: Icons.attach_money_outlined,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (value) {
                                  if (value?.isEmpty ?? true)
                                    return 'Unesite širinu';
                                  if (double.tryParse(value!) == null)
                                    return 'Unesite validnu širinu';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildTextField(
                                controller: _lengthController,
                                label: 'Dubina (cm)',
                                icon: Icons.attach_money_outlined,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (value) {
                                  if (value?.isEmpty ?? true)
                                    return 'Unesite dubinu';
                                  if (double.tryParse(value!) == null)
                                    return 'Unesite validnu dubinu';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _manufacturerController,
                                label: 'Proizvođač',
                                icon: Icons.business_outlined,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildTextField(
                                controller: _barcodeController,
                                label: 'Barkod',
                                icon: Icons.qr_code,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SwitchListTile(
                          title: const Text('Proizvod je aktivan'),
                          value: _isEnable,
                          activeColor: Colors.brown,
                          onChanged: (bool value) {
                            setState(() {
                              _isEnable = value;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Opis proizvoda',
                            alignLabelWithHint: true,
                            prefixIcon: const Icon(Icons.description_outlined,
                                color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Unesite opis proizvoda'
                              : null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _ingredientsController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Sastojci',
                            alignLabelWithHint: true,
                            prefixIcon: const Icon(Icons.science_outlined,
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
        final Map<String, dynamic> formData = {
          'Id': '0',
          'Name': _nameController.text,
          'Description': _descriptionController.text,
          'Price': _priceController.text.isNotEmpty
              ? double.tryParse(_priceController.text)
                  .toString()
                  .replaceAll('.', ',')
              : '0,00',
          'Height': _heightController.text.isNotEmpty
              ? double.tryParse(_heightController.text)
              .toString()
              .replaceAll('.', ',')
              : '0,00',
          'Width': _widthController.text.isNotEmpty
              ? double.tryParse(_widthController.text)
              .toString()
              .replaceAll('.', ',')
              : '0,00',
          'Length': _lengthController.text.isNotEmpty
              ? double.tryParse(_lengthController.text)
              .toString()
              .replaceAll('.', ',')
              : '0,00',
          'Stock': _stockController.text,
          'IsEnable': _isEnable.toString(),
          'Manufacturer': _manufacturerController.text,
          'Barcode': _barcodeController.text,
          'ProductCategoryId': _selectedCategory?.key.toString() ?? '0',
        };

        if (bytes != null) {
          formData['file'] = http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: 'image.jpg',
          );
        }

        bool? result = await _productProvider?.insertFormData(formData);

        if (result != null && result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Proizvod uspješno dodan"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProductListScreen(),
            ),
          );
        } else {
          throw Exception("Greška pri spremanju podataka o proizvodu.");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Greška pri dodavanju proizvoda: ${e.toString()}"),
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
    _priceController.dispose();
    _stockController.dispose();
    _manufacturerController.dispose();
    _barcodeController.dispose();
    _heightController.dispose();
    _widthController.dispose();
    _lengthController.dispose();
    super.dispose();
  }
}

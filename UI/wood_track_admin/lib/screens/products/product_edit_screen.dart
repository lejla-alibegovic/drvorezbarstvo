import 'package:wood_track_admin/screens/products/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wood_track_admin/models/listItem.dart';
import 'package:wood_track_admin/providers/dropdown_provider.dart';
import 'package:wood_track_admin/widgets/master_screen.dart';
import 'package:http/http.dart' as http;
import '../../providers/products_provider.dart';

class ProductEditScreen extends StatefulWidget {
  final int id;
  const ProductEditScreen({super.key, required this.id});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
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

  DropdownProvider? _dropdownProvider;
  ProductProvider? _productProvider;
  dynamic bytes;
  dynamic _imageFile;
  String? _existingImageUrl;
  List<ListItem> categories = [];
  ListItem? _selectedCategory;
  bool _isEnable = true;
  bool _isLoading = true;
  String apiUrl = "";

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageFile = pickedFile;
        _existingImageUrl = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    apiUrl = dotenv.env['API_URL_DOCKER']!;
    _dropdownProvider = DropdownProvider();
    _productProvider = ProductProvider();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await _loadCategories();
      await _loadProductData();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri učitavanju podataka: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _loadProductData() async {
    try {
      var product = await _productProvider?.getById(widget.id, null);
      if (product != null) {
        setState(() {
          _nameController.text = product.name;
          _descriptionController.text = product.description;
          _priceController.text = product.price.toString();
          _heightController.text = product.height.toString();
          _widthController.text = product.width.toString();
          _lengthController.text = product.length.toString();
          _stockController.text = product.stock.toString();
          _manufacturerController.text = product.manufacturer ?? '';
          _barcodeController.text = product.barcode ?? '';
          _isEnable = product.isEnable;
          _existingImageUrl = product.imageUrl;

          if (categories.isNotEmpty) {
            _selectedCategory = categories.firstWhere(
              (g) => g.key == product.productCategoryId,
              orElse: () => categories[0],
            );
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri učitavanju proizvoda: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future _loadCategories() async {
    var response = await _dropdownProvider?.getItems("product-categories");
    setState(() {
      categories = response as List<ListItem>;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.brown));
    }

    return MasterScreenWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Uredi proizvod",
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
                                            bytes!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : _existingImageUrl != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: imageWidget(
                                                  _existingImageUrl!),
                                            )
                                          : _buildDefaultProductImage(),
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
                                const SizedBox(height: 10),
                                if (_existingImageUrl != null || bytes != null)
                                  TextButton.icon(
                                    icon: const Icon(Icons.delete, size: 18),
                                    label: const Text('Obriši sliku'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _imageFile = null;
                                        bytes = null;
                                        _existingImageUrl = null;
                                      });
                                    },
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
                                keyboardType:
                                    const TextInputType.numberWithOptions(
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

  Widget _buildDefaultProductImage() {
    return const Center(
      child: Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.brown),
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final Map<String, dynamic> formData = {
          'Id': widget.id.toString(),
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
          'ImageUrl': _existingImageUrl ?? ''
        };

        if (_imageFile != null && bytes != null) {
          formData['file'] = http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: 'image.jpg',
          );
        }

        bool? result = await _productProvider?.updateFormData(formData);
        if (result != null && result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Proizvod uspješno izmijenjen"),
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
          throw Exception("Greška pri izmijeni podataka o proizvodu.");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Greška pri izmijeni proizvoda: ${e.toString()}"),
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

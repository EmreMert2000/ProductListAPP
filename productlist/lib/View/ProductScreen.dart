import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/Product.dart';
import '../ViewModel/ProductViewModel.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductViewModel()..fetchProducts(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Ürünler',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Consumer<ProductViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: viewModel.filterProducts,
                    decoration: InputDecoration(
                      labelText: 'Ürün Ara',
                      prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Card(
                      margin: EdgeInsets.all(16.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(Colors.blueAccent[100]),
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Ürün Adı')),
                          DataColumn(label: Text('Adet')),
                          DataColumn(label: Text('Fiyat')),
                          DataColumn(label: Text('İşlemler')),
                        ],
                        rows: viewModel.products.map((product) {
                          return DataRow(cells: [
                            DataCell(Text(product.id?.toString() ?? 'N/A')),
                            DataCell(Text(product.name)),
                            DataCell(Text(product.quantity.toString())),
                            DataCell(
                                Text('${product.price.toStringAsFixed(2)} ₺')),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () {
                                      _showEditProductDialog(
                                          context, product, viewModel);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () =>
                                        viewModel.deleteProduct(product.id!),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddProductDialog(context),
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('Ürün Ekle'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Ürün ekleme için dialog
  void _showAddProductDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _quantityController = TextEditingController();
    final _priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final viewModel = Provider.of<ProductViewModel>(context, listen: false);

        return AlertDialog(
          title: Text('Yeni Ürün Ekle'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ürün Adı'),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Adet'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Fiyat'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'İptal',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final quantity =
                    int.tryParse(_quantityController.text.trim()) ?? 0;
                final price =
                    double.tryParse(_priceController.text.trim()) ?? 0.0;

                if (name.isNotEmpty && quantity > 0 && price > 0) {
                  viewModel.addProduct(
                    Product(name: name, quantity: quantity, price: price),
                  );
                  Navigator.pop(dialogContext);
                } else {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Lütfen geçerli değerler girin')),
                  );
                }
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  // Ürün düzenleme için dialog
  void _showEditProductDialog(
      BuildContext context, Product product, ProductViewModel viewModel) {
    final _nameController = TextEditingController(text: product.name);
    final _quantityController =
        TextEditingController(text: product.quantity.toString());
    final _priceController =
        TextEditingController(text: product.price.toString());

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Ürün Düzenle'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ürün Adı'),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Adet'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Fiyat'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final quantity =
                    int.tryParse(_quantityController.text.trim()) ?? 0;
                final price =
                    double.tryParse(_priceController.text.trim()) ?? 0.0;

                if (name.isNotEmpty && quantity > 0 && price > 0) {
                  final updatedProduct = Product(
                    id: product.id,
                    name: name,
                    quantity: quantity,
                    price: price,
                  );
                  viewModel.editProduct(updatedProduct);
                  Navigator.pop(dialogContext);
                } else {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Lütfen geçerli değerler girin')),
                  );
                }
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
}

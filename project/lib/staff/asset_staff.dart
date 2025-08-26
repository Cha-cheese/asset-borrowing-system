import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project/models/product.dart';
import 'package:project/staff/add_staff.dart';
import 'package:project/staff/edit_staff.dart';
import 'package:project/staff/assetdetail_staff.dart';

class AssetStaff extends StatefulWidget {
  @override
  _AssetStaffState createState() => _AssetStaffState();
}

class _AssetStaffState extends State<AssetStaff> {
  List<Product> filteredProducts = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(products);
    _sortProducts();
  }

  void _onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        filteredProducts = products.where((product) {
          return product.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
        _sortProducts();
      });
    });
  }

  int _getStatusOrder(String status) {
    switch (status) {
      case 'Available':
        return 0; // Status Available is at order 0
      case 'Pending':
        return 1; // Status Disable is at order 2
      case 'Borrowed':
        return 2; // Status Borrowed is at order 1
      case 'Disable':
        return 3; // Status Disable is at order 2
      default:
        return 4; // Other statuses are at the last order
    }
  }

  void _sortProducts() {
    filteredProducts.sort((a, b) {
      int statusComparison =
          _getStatusOrder(a.status).compareTo(_getStatusOrder(b.status));
      return statusComparison != 0
          ? statusComparison
          : a.title.compareTo(b.title);
    });
  }

  void _showConfirmationDialog(
      BuildContext context, String action, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to $action this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  product.status =
                      action == 'Disable' ? 'Disable' : 'Available';
                  _sortProducts();
                });
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8EDFF),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
        child: Column(
          children: [
            SearchBar(onSearch: _onSearch),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBookPage()),
                );
                setState(() {
                  filteredProducts = List.from(products);
                  _sortProducts();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF22aa39),
                foregroundColor: Colors.white,
                minimumSize: Size(100, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('ADD BOOK'),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(
                      child: Text('No results found',
                          style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: filteredProducts[index],
                          onStatusChange: (action) => _showConfirmationDialog(
                              context, action, filteredProducts[index]),
                          onEdit: () async {
                            bool? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBookPage(
                                  book: filteredProducts[index],
                                ),
                              ),
                            );
                            if (result == true) {
                              setState(() {
                                filteredProducts = List.from(products);
                                _sortProducts();
                              });
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(String) onStatusChange;
  final Function() onEdit;

  const ProductCard({
    required this.product,
    required this.onStatusChange,
    required this.onEdit,
    Key? key,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return const Color(0xFF00BF63); // Color for Available
      case 'Pending':
        return const Color.fromARGB(255, 10, 130, 228);
      case 'Borrowed':
        return const Color(0xFFE4B90A); // Color for Borrowed
      case 'Disable':
        return const Color(0xFF68737B); // Color for Disable
      default:
        return Colors.black; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0), // เพิ่ม padding รอบรูปภาพ
              child: Container(
                width: 90,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    // ตรวจสอบว่า image เป็น asset หรือ path จากการเลือก
                    image: product.image.contains('assets/')
                        ? AssetImage(product.image) as ImageProvider
                        : FileImage(File(product.image)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text('Status : ', style: TextStyle(fontSize: 16)),
                      Text(product.status,
                          style: TextStyle(
                              color: _getStatusColor(product.status),
                              fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Detailstaff(product: product),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1e1e1e),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          minimumSize: const Size(70, 30),
                        ),
                        child: const Text('Detail',
                            style: TextStyle(fontSize: 14)),
                      ),
                      const SizedBox(width: 5),

                      // If status is not 'Pending', show Edit and status change buttons
                      if (product.status != 'Pending') ...[
                        if (product.status != 'Borrowed')
                          ElevatedButton(
                            onPressed: onEdit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 245, 192, 60),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              minimumSize: const Size(70, 30),
                            ),
                            child: const Text('Edit',
                                style: TextStyle(fontSize: 14)),
                          ),
                        const SizedBox(width: 5),
                        // if (product.status == 'Available')
                        //   ElevatedButton(
                        //     onPressed: () => onStatusChange('Disable'),
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: const Color(0xFFAB0A0A),
                        //       foregroundColor: Colors.white,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8.0),
                        //       ),
                        //       minimumSize: const Size(40, 30),
                        //     ),
                        //     child: const Text('Disable',
                        //         style: TextStyle(fontSize: 12)),
                        //   )
                        // else if (product.status == 'Disable')
                        //   ElevatedButton(
                        //     onPressed: () => onStatusChange('Enable'),
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: const Color(0xFFFFB98E),
                        //       foregroundColor: Colors.white,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8.0),
                        //       ),
                        //       minimumSize: const Size(40, 30),
                        //     ),
                        //     child: const Text('Enable',
                        //         style: TextStyle(fontSize: 12)),
                        //   ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const SearchBar({required this.onSearch, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: 'Search book',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project/models/product.dart';
import 'package:project/user/assetdetail_user.dart';
import 'package:project/user/history_user.dart';
import 'package:project/user/profile_user.dart';
import 'package:project/user/rq.dart';

class AssetUser extends StatefulWidget {
  @override
  _AssetUserState createState() => _AssetUserState();
}

class _AssetUserState extends State<AssetUser> with SingleTickerProviderStateMixin {
  late TabController _tabController; // TabController
  String appBarTitle = 'Book List';
  List<Product> filteredProducts = products; // Filtered product list
  Timer? _debounce;
  String searchQuery = ''; // Variable to store search query

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Set number of tabs
    _tabController.addListener(() {
      setState(() {
        appBarTitle = _getAppBarTitle(_tabController.index);
      });
    });
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Book List';
      case 1:
        return 'Request';
      case 2:
        return 'History';
      case 3:
        return 'Profile';
      default:
        return 'Book List'; // Default case
    }
  }

  void _onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query;
        filteredProducts = products.where((product) {
          return product.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    });
  }

  // Function to order status
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

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sort filteredProducts by status and alphabetically
    filteredProducts.sort((a, b) {
      // Compare status
      int statusComparison =
          _getStatusOrder(a.status).compareTo(_getStatusOrder(b.status));
      if (statusComparison != 0) {
        return statusComparison; // Sort by status if not equal
      }
      // Sort by title if statuses are equal
      return a.title.compareTo(b.title);
    });

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 57, 72),
      ),
      backgroundColor: const Color.fromARGB(255, 216, 237, 255),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Book List tab
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              children: [
                // Show search box based on the condition
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextField(
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search book',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Product List
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(
                          child: Text('No results found',
                              style: TextStyle(fontSize: 18)),
                        )
                      : ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                                product: filteredProducts[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
          Rq(),
          HistoryUser(),
          ProfileUser(),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 39, 57, 72),
        child: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              appBarTitle = _getAppBarTitle(index);
            });
          },
          tabs: const [
            Tab(
              icon: Icon(Icons.list),
              text: 'List',
            ),
            Tab(
              icon: Icon(Icons.document_scanner_rounded),
              text: 'Request',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'History',
            ),
            Tab(
              icon: Icon(Icons.account_box),
              text: 'Profile',
            ),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Color.fromARGB(255, 255, 255, 255),
          indicatorColor: Colors.blue,
          indicatorWeight: 4.0,
          indicator: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.blue, width: 4.0),
            ),
          ),
        ),
      ),
    );
  }
}

// ProductCard class to display each product's details
class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

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
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Same card design as HistoryUser
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 150,
                  child: _buildImageWidget(product.image),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text('Status: ', style: TextStyle(fontSize: 14)),
                          Text(
                            product.status,
                            style: TextStyle(
                                color: _getStatusColor(product.status),
                                fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailUser(product: product),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1e1e1e), // Button color
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Button radius
                          ),
                          minimumSize: const Size(100, 35),
                        ),
                        child: const Text('Detail'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildImageWidget(String imagePath) {
    return imagePath.startsWith('assets/')
        ? Image.asset(
            imagePath,
            fit: BoxFit.cover,
          )
        : Image.file(
            File(imagePath),
            fit: BoxFit.cover,
          );
  }
}

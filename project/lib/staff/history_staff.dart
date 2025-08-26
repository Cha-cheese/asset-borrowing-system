import 'package:flutter/material.dart';
import 'package:project/models/info_staff.dart'; // Ensure this points to the correct path for info.dart
import 'package:project/staff/asset_staff.dart';
import 'package:project/staff/dashboard_staff.dart';
import 'package:project/staff/profile_staff.dart';
import 'package:project/staff/return_staff.dart'; // Ensure this points to your staff screen

// SearchBar widget for searching through the book list
class SearchBar extends StatelessWidget {
  final Function(String) onSearch;

  SearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: 'Search book',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        ),
      ),
    );
  }
}

class HistoryStaff extends StatefulWidget {
  const HistoryStaff({Key? key}) : super(key: key);

  @override
  State<HistoryStaff> createState() => _HistoryStaffState();
}

class _HistoryStaffState extends State<HistoryStaff> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController; // Declare the TabController
  String appBarTitle = 'Book List';
  String searchQuery = '';
  List<Map<String, String>> filteredBooks = Info.books;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // Correctly assign vsync to this

    // Listen for tab changes
    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            appBarTitle = 'Book List';
            break;
          case 1:
            appBarTitle = 'Dashboard';
            break;
          case 2:
            appBarTitle = 'History';
            break;
          case 3:
            appBarTitle = 'Get return';
            break;
          case 4:
            appBarTitle = 'Profile';
            break;
        }
      });
    });
  }

  // Function to filter the books based on search query
  void _filterBooks(String query) {
    setState(() {
      searchQuery = query;
      filteredBooks = Info.books
          .where((book) =>
              book['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call to ensure keep alive works

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 39, 57, 72),
      ),
      backgroundColor: Color.fromARGB(255, 216, 237, 255),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController, // Assign the TabController
              children: [
                Container(
                  color: Color.fromARGB(255, 216, 237, 255),
                  child: AssetStaff(),
                ),
                DashboardStaff(),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    children: [
                      // Adding SearchBar only in the History tab
                      SearchBar(onSearch: _filterBooks),
                      Expanded(
                        child: filteredBooks.isEmpty // Check if filteredBooks is empty
                            ? Center(
                                child: Text(
                                  'No results found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredBooks.length,
                                itemBuilder: (context, index) {
                                  final book = filteredBooks[index];
                                  return Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            book['image']!,
                                            width: 100,
                                            height: 120,
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  book['title']!,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Text('Borrowed Date: '),
                                                    Text('${book['borrowedDate']}'),
                                                  ],
                                                ),
                                                Text('Date Due: ${book['dueDate']}'),
                                                Text('Username: ${book['username']}'),
                                                Row(
                                                  children: [
                                                    Text('Status: '),
                                                    Text(
                                                      book['status']!,
                                                      style: TextStyle(
                                                        color: book['status'] == 'approved'
                                                            ? Colors.green
                                                            : book['status'] == 'rejected'
                                                                ? Colors.red
                                                                : book['status'] == 'borrowing'
                                                                    ? const Color.fromARGB(255, 231, 139, 0)
                                                                    : Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text('Approved by: ${book['approver']}'),
                                                Text('Return Asset: ${book['return asset']}'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                ReturnStaff(),
                ProfileStaff(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 39, 57, 72),
        child: TabBar(
          controller: _tabController, // Assign the TabController
          tabs: [
            Tab(icon: Icon(Icons.list), text: 'List'),
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.history), text: 'History'),
            Tab(icon: Icon(Icons.repeat_rounded), text: 'Get return'),
            Tab(icon: Icon(Icons.account_box), text: 'Profile'),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.blue,
          indicatorWeight: 4.0,
          indicator: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.blue, width: 4.0),
            ),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
          labelStyle: TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true; // Keep the state alive for the tab

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the TabController when done
    super.dispose();
  }
}

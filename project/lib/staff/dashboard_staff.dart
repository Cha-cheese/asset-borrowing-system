import 'package:flutter/material.dart';

class DashboardStaff extends StatefulWidget {
  const DashboardStaff({super.key});

  @override
  State<DashboardStaff> createState() => _DashboardStaffState();
}

class _DashboardStaffState extends State<DashboardStaff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 237, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DashboardTile(
                  icon: Icons.access_time,
                  label: 'Borrowed assets',
                  count: 5,
                  color: Colors.yellow.shade300,
                ),
                SizedBox(height: 30),
                DashboardTile(
                  icon: Icons.refresh,
                  label: 'Available assets',
                  count: 2,
                  color: Colors.green.shade300,
                ),
                SizedBox(height: 30),
                DashboardTile(
                  icon: Icons.cancel,
                  label: 'Disabled assets',
                  count: 0,
                  color: Colors.red.shade300,
                ),
                SizedBox(height: 30),
                DashboardTile(
                  icon: Icons.timer,
                  label: 'Pending',
                  count: 3,
                  color: Colors.blue.shade300,
                ),
                SizedBox(height: 30),
                DashboardTile(
                  icon: Icons.book,
                  label: 'Total books',
                  count: 10,
                  color: const Color.fromARGB(255, 121, 143, 255),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  DashboardTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 5),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // จัดแนวให้ไอคอนอยู่ด้านบน
        children: [
          Padding(
            padding: const EdgeInsets.only(
                right: 30,
                left: 20,
                top: 27.5), // ระยะห่างระหว่างไอคอนและข้อความ
            child: Icon(icon,
                size: 25, color: Colors.black), // ปรับขนาดไอคอนให้ดูเด่น
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // ข้อความอยู่ด้านบน
              crossAxisAlignment:
                  CrossAxisAlignment.start, // ข้อความอยู่ด้านซ้าย
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.8),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: 70), // ปรับระยะห่างตามต้องการ
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(221, 19, 18, 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
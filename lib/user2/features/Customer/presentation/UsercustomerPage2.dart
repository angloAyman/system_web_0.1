import 'package:flutter/material.dart';
import '../../../../features/customer/presentation/normal/normal_customer_page.dart';
import '../../../../features/customer/presentation/business/business_customer_page.dart';

class UserCustomerPage2 extends StatefulWidget {
  @override
  _UserCustomerPage2State createState() => _UserCustomerPage2State();
}

class _UserCustomerPage2State extends State<UserCustomerPage2> {
  String _selectedCustomerType = 'normal'; // Default type: normal customers
  String _searchQuery = ''; // Search query to filter customers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة العملاء'),
        actions: [
          TextButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/userMainScreen2'); // توجيه المستخدم إلى صفحة تسجيل الدخول
          }, label: Icon(Icons.home)),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                labelText: 'ابحث عن عميل',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(" نوع العملاء",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(width: 20,),
                // Dropdown to select customer type
                DropdownButton<String>(
                  value: _selectedCustomerType,
                  items: [
                    DropdownMenuItem(
                      value: 'normal',
                      child: Text('العملاء'),
                    ),
                    // DropdownMenuItem(
                    //   value: 'business',
                    //   child: Text('العملاء التجارين'),
                    // ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCustomerType = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          // Display the selected table
          Expanded(
            child:NormalCustomerPage(searchQuery: _searchQuery) // Page for normal customers
                // : BusinessCustomerPage(searchQuery: _searchQuery), // Page for business customers
          ),
        ],
      ),
    );
  }
}

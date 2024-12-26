// // import 'package:flutter/material.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// //
// // class FavoriteBillsPage extends StatelessWidget {
// //   final List<Bill> bills; // Pass the list of bills to this page
// //
// //   FavoriteBillsPage({required this.bills});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final favoriteBills = bills.where((bill) => bill.isFavorite).toList();
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('الفواتير المفضلة'),
// //       ),
// //       body: favoriteBills.isEmpty
// //           ? Center(child: Text('لا توجد فواتير مفضلة.'))
// //           : ListView.builder(
// //         itemCount: favoriteBills.length,
// //         itemBuilder: (context, index) {
// //           final bill = favoriteBills[index];
// //           return ListTile(
// //             title: Text('${bill.id} - ${bill.customerName}'),
// //             subtitle: Text('الحالة: ${bill.status}'),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';  // Import your repository to access Supabase
//
// class FavoriteBillsPage extends StatefulWidget {
//   @override
//   _FavoriteBillsPageState createState() => _FavoriteBillsPageState();
// }
//
// class _FavoriteBillsPageState extends State<FavoriteBillsPage> {
//   final BillRepository _billRepository = BillRepository();
//   late Future<List<Bill>> _favoriteBillsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _favoriteBillsFuture = _billRepository.getFavoriteBills();  // Fetch the favorite bills from the repository
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('الفواتير المفضلة'),
//       ),
//       body: FutureBuilder<List<Bill>>(
//         future: _favoriteBillsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('خطأ: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('لا توجد فواتير مفضلة.'));
//           }
//
//           final favoriteBills = snapshot.data!;
//
//           return ListView.builder(
//             itemCount: favoriteBills.length,
//             itemBuilder: (context, index) {
//               final bill = favoriteBills[index];
//               return ListTile(
//                 title: Text('${bill.id} - ${bill.customerName}'),
//                 subtitle: Text('الحالة: ${bill.status}'),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';  // Import your repository to access Supabase
//
// class FavoriteBillsPage extends StatefulWidget {
//   @override
//   _FavoriteBillsPageState createState() => _FavoriteBillsPageState();
// }
//
// class _FavoriteBillsPageState extends State<FavoriteBillsPage> {
//   final BillRepository _billRepository = BillRepository();
//   late Future<List<Bill>> _favoriteBillsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _favoriteBillsFuture = _billRepository.getFavoriteBills();  // Fetch the favorite bills from the repository
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('الفواتير المفضلة'),
//       ),
//       body: FutureBuilder<List<Bill>>(
//         future: _favoriteBillsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('خطأ: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('لا توجد فواتير مفضلة.'));
//           }
//
//           final favoriteBills = snapshot.data!;
//
//           return ListView.builder(
//             itemCount: favoriteBills.length,
//             itemBuilder: (context, index) {
//               final bill = favoriteBills[index];
//               return ListTile(
//                 title: Text('${bill.id} - ${bill.customerName}'),
//                 subtitle: Text('الحالة: ${bill.status}'),
//                 trailing: IconButton(
//                   icon: Icon(
//                     Icons.account_balance,  // Update icon based on favorite status
//                     color: bill.isFavorite ? Colors.blue : null,
//                   ),
//                   onPressed: () async {
//                     try {
//                       if (bill.isFavorite) {
//                         // Remove from favorites
//                         await _billRepository.removeFromFavorites(bill);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('تمت إزالة الفاتورة من المفضلة')),
//                         );
//                       } else {
//                         // Add to favorites
//                         await _billRepository.addToFavorites(bill);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('تمت إضافة الفاتورة إلى المفضلة')),
//                         );
//                       }
//
//                       setState(() {
//                         bill.isFavorite = !bill.isFavorite; // Toggle favorite state
//                       });
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('خطأ: ${e.toString()}')),
//                       );
//                     }
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';

class FavoriteBillsPage extends StatefulWidget {
  @override
  _FavoriteBillsPageState createState() => _FavoriteBillsPageState();
}

class _FavoriteBillsPageState extends State<FavoriteBillsPage> {
  final BillRepository _billRepository = BillRepository();
  late Future<List<Bill>> _favoriteBillsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch bills with isFavorite set to true
    _refreshFavoriteBills();
  }

  void _refreshFavoriteBills() {
    _favoriteBillsFuture = _billRepository.getFavoriteBills();
  }

  Future<void> _toggleFavoriteStatusAndUpdateDescription(Bill bill) async {
    final updatedDescription = await _showDescriptionDialog(context, bill.id, bill.description);

    if (updatedDescription != null) {
      try {
        await _billRepository.updateFavoriteStatusAndDescription(
          billId: bill.id,
          isFavorite: !bill.isFavorite, // Toggle the favorite status
          description: updatedDescription, // Set the updated description
        );

        // Update the UI
        setState(() {
          bill.isFavorite = !bill.isFavorite;
          bill.description = updatedDescription;
          // Refresh the list if removed from favorites
          if (!bill.isFavorite) _refreshFavoriteBills();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تمت ${bill.isFavorite ? "إضافة" : "إزالة"} الفاتورة للمفضلة')),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء تحديث الفاتورة: $e')),
        );
      }
    }
  }

  Future<String?> _showDescriptionDialog(BuildContext context, int billId, String currentDescription) async {
    final TextEditingController _descriptionController = TextEditingController(text: currentDescription);

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تحديث الوصف'),
        content: TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(labelText: 'الوصف'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, _descriptionController.text),
            child: Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الفواتير المفضلة'),
      ),
      body: FutureBuilder<List<Bill>>(
        future: _favoriteBillsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('خطأ: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد فواتير مفضلة.'));
          }

          final favoriteBills = snapshot.data!;

          return ListView.builder(
            itemCount: favoriteBills.length,
            itemBuilder: (context, index) {
              final bill = favoriteBills[index];
              return ListTile(
                title: Text('${bill.id} - ${bill.customerName}'),
                subtitle: Text('الحالة: ${bill.status} \nالوصف: ${bill.description}'),
                trailing: IconButton(
                  icon: Icon(
                    bill.isFavorite ? Icons.account_balance : Icons.account_balance_outlined,
                    color: bill.isFavorite ? Colors.blue : null,
                  ),
                  onPressed: () => _toggleFavoriteStatusAndUpdateDescription(bill),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

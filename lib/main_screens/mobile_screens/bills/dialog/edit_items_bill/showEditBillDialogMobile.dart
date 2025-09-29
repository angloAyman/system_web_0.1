import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/item/showAddItemDialog.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
import 'package:system/main_screens/mobile_screens/bills/dialog/add_items/showAddItemDialog_mobileLayout.dart';
import 'package:system/main_screens/mobile_screens/bills/dialog/edit_items_bill/showEditItemDialogMobile.dart';

Future<Bill?> showEditBillDialogMobile(BuildContext context, Bill bill) async {
  final updatedItems = List<BillItem>.from(bill.items);
  final _formKey = GlobalKey<FormState>();

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} جنيه مصري';
  }

  Future<void> _deleteItemFromDatabase(Bill bill, BillItem item) async {
    try {
      final supabase = Supabase.instance.client;
      final updatedItems = bill.items.where((i) => i != item).toList();

      await supabase.from('bills').update({
        'items': updatedItems.map((i) => i.toJson()).toList()
      }).eq('id', bill.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف العنصر بنجاح')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ أثناء حذف العنصر: $e')),
        );
      }
    }
  }

  Future<void> _updateBill() async {
    if (!_formKey.currentState!.validate()) return;
    if (updatedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن حفظ الفاتورة بدون عناصر')),
      );
      return;
    }

    try {
      final totalAmount = updatedItems.fold<double>(0.0, (sum, item) {
        final itemPrice = (item.price_per_unit ?? 0) * (item.quantity ?? 0);
        final discount = (itemPrice * (item.discount ?? 0) / 100);
        return sum + (itemPrice - discount).toInt();
      });

      final updatedBill = Bill(
        id: bill.id,
        customerName: bill.customerName,
        date: bill.date,
        status: totalAmount == bill.payment
            ? "تم الدفع"
            : totalAmount > bill.payment ? "فاتورة مفتوحة" : "آجل",
        customer_type: bill.customer_type,
        payment: bill.payment,
        items: updatedItems,
        userId: bill.userId,
        total_price: totalAmount,
        vault_id: bill.vault_id,
        isFavorite: false,
        description: 'جاري التنفيذ',
      );

      await BillRepository().updateBill(updatedBill);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
        );
        Navigator.of(context).pop(updatedBill);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
        );
      }
    }
  }

  return showDialog<Bill>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('تعديل الفاتورة', textAlign: TextAlign.center),
        contentPadding: const EdgeInsets.all(12),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text('العميل: ${bill.customerName}'),
                        const SizedBox(height: 8),
                        Text('إجمالي الفاتورة: ${_formatCurrency(bill.total_price)}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Items List
                if (updatedItems.isEmpty)
                  const Center(child: Text('لا توجد أصناف مضافة'))
                else
                  ...updatedItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final itemTotal = item.total_Item_price;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.categoryName} / ${item.subcategoryName}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 20),
                                      onPressed: () async {
                                        final updated = await showEditItemDialogMobile(
                                          context: context,
                                          item: item,
                                          onUpdateItem: (updatedItem) {
                                            if (context.mounted) {
                                              updatedItems[index] = updatedItem;
                                              _formKey.currentState!.setState(() {});
                                            }
                                          },
                                        );
                                      },
                                    ),                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                      onPressed: () async {
                                        await _deleteItemFromDatabase(bill, item);
                                        if (context.mounted) {
                                          updatedItems.removeAt(index);
                                          _formKey.currentState!.setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (item.description?.isNotEmpty ?? false)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(item.description!),
                              ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Chip(
                                  label: Text('السعر: ${item.price_per_unit}'),
                                  visualDensity: VisualDensity.compact,
                                ),
                                Chip(
                                  label: Text('الكمية: ${item.quantity}'),
                                  visualDensity: VisualDensity.compact,
                                ),
                                Chip(
                                  label: Text('الخصم: ${item.discount}%'),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'الإجمالي: ${_formatCurrency(itemTotal)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة عنصر جديد'),
                    onPressed: () async {
                      await showAddItemDialogMobile(
                        context: context,
                        onAddItem: (newItem) {
                          if (context.mounted) {
                            updatedItems.add(newItem);
                            _formKey.currentState!.setState(() {});
                          }
                        },
                      );
                    },
                  ),
                ),              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: _updateBill,
            child: const Text('حفظ التعديلات'),
          ),
        ],
      );
    },
  );
}
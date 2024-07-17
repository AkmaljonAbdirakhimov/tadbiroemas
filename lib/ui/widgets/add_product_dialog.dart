import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiroemas/logic/blocs/products/products_bloc.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Mahsulot"),
      content: TextField(
        controller: titleController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Mahsulot nomi",
        ),
      ),
      actions: [
        BlocConsumer<ProductsBloc, ProductsState>(
          listener: (ctx, state) {
            if (state is LoadedProductsState) {
              Navigator.pop(context);
            }
          },
          builder: (ctx, state) {
            return Row(
              children: [
                TextButton(
                  onPressed: state is LoadingProductsState
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text("Bekor Qilish"),
                ),
                FilledButton(
                  onPressed: () {
                    context
                        .read<ProductsBloc>()
                        .add(AddProductEvent(titleController.text));
                  },
                  child: const Text("Qo'shish"),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

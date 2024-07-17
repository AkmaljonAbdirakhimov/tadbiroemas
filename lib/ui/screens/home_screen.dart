import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiroemas/logic/blocs/auth/auth_bloc.dart';
import 'package:tadbiroemas/logic/blocs/products/products_bloc.dart';
import 'package:tadbiroemas/ui/widgets/add_product_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        bloc: context.read<ProductsBloc>()..add(GetProductsEvent()),
        builder: (ctx, state) {
          if (state is LoadingProductsState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ErrorProductsState) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is LoadedProductsState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // TextField(
                  //   controller: searchController,
                  //   decoration: InputDecoration(
                  //     border: const OutlineInputBorder(),
                  //     labelText: "Mahsulot nomi",
                  //     suffixIcon: IconButton(
                  //       onPressed: () {},
                  //       icon: const Icon(Icons.search),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (ctx, index) {
                        final product = state.products[index];
                        return ListTile(
                          title: Text(product.title),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("Mahsulotlar mavjud emas"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return const AddProductDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Dog {
  late String name;
}

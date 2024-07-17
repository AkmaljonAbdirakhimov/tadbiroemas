import 'package:bloc/bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:tadbiroemas/data/repositories/product_repository.dart';

import '../../../data/models/product.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository _productRepository;

  ProductsBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(InitialProductsState()) {
    on<GetProductsEvent>(_getProducts);
    on<AddProductEvent>(
      _addProduct,
      // funkisyani ichga tushiradi va keyingi 5 soniya kutadi
      //  transformer: (events, mapper) =>
      //     events.throttle(const Duration(seconds: 5)).switchMap(mapper),

      // 5 soniyani kutadi va keyin funksiyani chaqiradi
      // transformer: (events, mapper) => events
      //     .debounce(const Duration(seconds: 5), leading: false, trailing: true)
      //     .switchMap(mapper),
    );
    on<EditProductEvent>(_editProduct);
    on<DeleteProductEvent>(_deleteProduct);
  }

  void _getProducts(
    GetProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(LoadingProductsState());

    try {
      // await emit.forEach(stream, onData: (data) {
      //   return LoadedProductsState(data);
      // });
      final products = await _productRepository.getProducts();
      emit(LoadedProductsState(products));
    } catch (e) {
      emit(ErrorProductsState(e.toString()));
    }
  }

  void _addProduct(
    AddProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    List<Product> existingProducts = [];
    if (state is LoadedProductsState) {
      existingProducts = (state as LoadedProductsState).products;
    }
    emit(LoadingProductsState());

    try {
      final product = await _productRepository.addProduct(event.title);
      existingProducts.add(product);
      emit(LoadedProductsState(existingProducts));
    } catch (e) {
      emit(ErrorProductsState(e.toString()));
    }
  }

  void _editProduct(
    EditProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    List<Product> existingProducts = [];
    if (state is LoadedProductsState) {
      existingProducts = (state as LoadedProductsState).products;
    }
    emit(LoadingProductsState());

    try {
      await _productRepository.editProduct(event.id, event.newTitle);
      for (var product in existingProducts) {
        if (product.id == event.id) {
          product.title = event.newTitle;
        }
      }
      emit(LoadedProductsState(existingProducts));
    } catch (e) {
      emit(ErrorProductsState(e.toString()));
    }
  }

  void _deleteProduct(
    DeleteProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    List<Product> existingProducts = [];
    if (state is LoadedProductsState) {
      existingProducts = (state as LoadedProductsState).products;
    }
    emit(LoadingProductsState());

    try {
      await _productRepository.deleteProduct(event.id);
      existingProducts.removeWhere((product) {
        return product.id == event.id;
      });
      emit(LoadedProductsState(existingProducts));
    } catch (e) {
      emit(ErrorProductsState(e.toString()));
    }
  }
}

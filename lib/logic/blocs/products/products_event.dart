part of 'products_bloc.dart';

sealed class ProductsEvent {}

final class AddProductEvent extends ProductsEvent {
  final String title;
  AddProductEvent(this.title);
}

final class EditProductEvent extends ProductsEvent {
  final String id;
  final String newTitle;

  EditProductEvent({required this.id, required this.newTitle});
}

final class DeleteProductEvent extends ProductsEvent {
  final String id;

  DeleteProductEvent({required this.id});
}

final class GetProductsEvent extends ProductsEvent {}

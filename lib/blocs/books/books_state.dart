part of 'books_bloc.dart';

abstract class BooksState extends Equatable {
  const BooksState();
}

class BooksMain extends BooksState {
  final List<String> books;

  BooksMain({@required this.books});
  @override
  List<Object> get props => [books];
}

class BooksLoading extends BooksState {
  final String caption;

  BooksLoading({@required this.caption});
  @override
  List<Object> get props => [caption];
}

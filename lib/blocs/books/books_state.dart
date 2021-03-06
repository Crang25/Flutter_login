part of 'books_bloc.dart';

abstract class BooksState extends Equatable {
  const BooksState();
}

class BooksMain extends BooksState {
  final bool showFav;
  final List<Book> books;

  BooksMain({@required this.books, this.showFav = false});
  @override
  List<Object> get props => [books];
}

class BooksLoading extends BooksState {
  final String caption;

  BooksLoading({@required this.caption});
  @override
  List<Object> get props => [caption];
}

class EmptyBookList extends BooksState {
  @override
  List<Object> get props => [];
}

class EmptyFavBookList extends BooksState {
  @override
  List<Object> get props => [];
}

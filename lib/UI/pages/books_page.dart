import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:less_projects/UI/style/decoration.dart';
import 'package:less_projects/UI/widgets/banner.dart';
import 'package:less_projects/UI/widgets/book_item.dart';
import 'package:less_projects/blocs/books/books_bloc.dart';
import 'package:less_projects/classes/book_and_film.dart';
import 'package:less_projects/classes/user.dart';

class Books extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Кнопошка получения большего списка
    Widget getMore() {
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.2,
        child: FloatingActionButton.extended(
          heroTag: "btn1",
          backgroundColor: buttonColor,
          label: Text(
            "Ещё!",
            style: style,
          ),
          onPressed: () => BlocProvider.of<BooksBloc>(context).add(MoreBooks()),
        ),
      );
    }

    Widget refresh() {
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.2,
        child: FloatingActionButton.extended(
          heroTag: "btn2",
          backgroundColor: buttonColor,
          label: Text(
            "Обновить",
            style: style,
          ),
          onPressed: () =>
              BlocProvider.of<BooksBloc>(context).add(RefreshBooks()),
        ),
      );
    }

    ///Выдает наполнение основного экрана
    List<Widget> getListOfItems({
      bool fav,
      List<Book> books,
      BuildContext context,
    }) {
      User user = BlocProvider.of<BooksBloc>(context).user;
      double width = MediaQuery.of(context).size.width * 0.6;
      double height = MediaQuery.of(context).size.height * 0.4;
      List<Widget> result = new List<Widget>();
      result.add(Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: MyBanner(caption: "Книги", book: true),
      ));
      books.forEach((book) => result.add(
            new BookItem(
              fav: fav,
              user: user,
              height: height,
              width: width,
              item: book,
            ),
          ));
      if (!fav) result.add(getMore());
      return result;
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
            decoration: backgroundGradient(),
            child: BlocConsumer<BooksBloc, BooksState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is EmptyBookList)
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Ой, кажется, вы всё просмотрели!",
                              style: style,
                            ),
                          ),
                          refresh(),
                        ],
                      ),
                    ),
                  );
                if (state is EmptyFavBookList)
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        MyBanner(caption: "Книги", book: true),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.2),
                        ),
                        Text(
                          "У вас пока что нет избранных книг.",
                          style: style,
                        ),
                      ],
                    ),
                  );
                if (state is BooksMain) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: getListOfItems(
                          fav: state.showFav,
                          books: state.books,
                          context: context,
                        ),
                      ),
                    ),
                  );
                }
                if (state is BooksLoading) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              state.caption,
                              style: style,
                            ),
                          ),
                          CircularProgressIndicator(
                            strokeWidth: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Center(child: Text("Что-то точно пошло не так..."));
              },
            )),
      ),
    );
  }
}

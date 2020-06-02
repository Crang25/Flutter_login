import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:less_projects/UI/nav_bar.dart';
import 'package:less_projects/UI/style/decoration.dart';
import 'package:less_projects/blocs/books/books_bloc.dart';
import 'package:less_projects/blocs/films/films_bloc.dart';
import 'package:less_projects/blocs/registry/registry_bloc.dart';

class RegistrationFormPage extends StatelessWidget {
  final _loginController = new TextEditingController();
  final _passController = new TextEditingController();
  final _emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: mainColor2,
      body: Builder(
        builder: (context) => new SafeArea(
          child: Container(
            decoration: new BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.png"),
                  fit: BoxFit.cover),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: new Container(
                    height: MediaQuery.of(context).size.height * 0.34,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: new BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/whitelogo.png"),
                            fit: BoxFit.fill)),
                  ),
                ),
                Align(
                    alignment: Alignment(0, 0.5),
                    child: BlocConsumer<RegistryBloc, RegistryState>(
                      listener: (context, state) {
                        if (state is RegistryInitial && state.failed)
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Не удалось войти в аккаунт. Пожалуйста, проверьте корректность данных и попробуйте снова"),
                          ));
                        if (state is RegistrySuccess) {
                          BlocProvider.of<BooksBloc>(context)
                              .add(FirstLoadBook(user: state.user));
                          BlocProvider.of<FilmsBloc>(context)
                              .add(FirstLoadFilm(user: state.user));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeWidget()));
                        }
                      },
                      builder: (context, state) {
                        if (state is RegistryLoading)
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                state.caption,
                                style: new TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              CircularProgressIndicator(
                                strokeWidth: 5,
                              ),
                            ],
                          );
                        if (state is RegistryInitial)
                          return new SingleChildScrollView(
                              child: new Form(
                            child: new Theme(
                              data: new ThemeData(
                                brightness: Brightness.dark,
                                accentColor: mainColor,
                              ),
                              //Loginfield
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                      margin: new EdgeInsets.fromLTRB(
                                          20.0, 0.0, 20.0, 10.0),
                                      child: new TextFormField(
                                        controller: _loginController,
                                        decoration: new InputDecoration(
                                          icon: new Icon(
                                            FontAwesomeIcons.user,
                                            color: Colors.blueGrey[900],
                                          ),
                                          hintText: 'Введите ваш логин',
                                        ),
                                        keyboardType: TextInputType.text,
                                      )),
                                  //Email adress
                                  new Container(
                                      margin: new EdgeInsets.fromLTRB(
                                          20.0, 0.0, 20.0, 10.0),
                                      child: new TextFormField(
                                        controller: _emailController,
                                        decoration: new InputDecoration(
                                          icon: new Icon(
                                            Icons.alternate_email,
                                            color: Colors.blueGrey[900],
                                          ),
                                          hintText: 'Введите электронную почту',
                                          labelText: 'Ваша электронная почта',
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      )),
                                  //Passsword
                                  new Container(
                                      margin: new EdgeInsets.fromLTRB(
                                          20.0, 0.0, 20.0, 10.0),
                                      child: new TextFormField(
                                        controller: _passController,
                                        obscureText: true,
                                        decoration: new InputDecoration(
                                          icon: new Icon(
                                            FontAwesomeIcons.key,
                                            color: Colors.blueGrey[900],
                                          ),
                                          hintText: 'Введите пароль',
                                          labelText: 'Ваш пароль',
                                        ),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 14),
                                    child: new Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.2,
                                      child: FloatingActionButton.extended(
                                        heroTag: "htag1",
                                        backgroundColor: buttonColor,
                                        label: Text("Зарегестрироваться",
                                            style: style),
                                        onPressed: () => BlocProvider.of<
                                                RegistryBloc>(context)
                                            .add(CheckRegistry(
                                                email: _emailController.text,
                                                login: _loginController.text,
                                                password:
                                                    _passController.text)),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: FloatingActionButton.extended(
                                      heroTag: "htag2",
                                      backgroundColor: buttonColor,
                                      label: Text("Назад", style: style),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

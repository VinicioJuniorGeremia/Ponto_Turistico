import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_md/pages/filtro_page.dart';
import 'package:gerenciador_tarefas_md/pages/lista_tarefas_page.dart';

void main() {
  runApp(const AppPontosTuristicos());
}

class AppPontosTuristicos extends StatelessWidget {
  const AppPontosTuristicos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pontos Turisticos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primaryColor: Colors.red,
        primarySwatch: Colors.green,
      ),
      home: ListaTarefasPage(),
      routes: {
        FiltroPage.routeName: (BuildContext context) => FiltroPage(),
      },
    );
  }
}
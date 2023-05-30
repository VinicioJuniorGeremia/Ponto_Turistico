import 'package:flutter/material.dart';
import '../model/tarefa.dart';

class DetalhesTarefaPage extends StatefulWidget {
  final Tarefa tarefa;

  const DetalhesTarefaPage({Key? key, required this.tarefa}) : super(key: key);


  @override
  _DetalhesTarefaPageState createState() => _DetalhesTarefaPageState();
}

class _DetalhesTarefaPageState extends State<DetalhesTarefaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes dos Pontos Turísticos'),
      ),
      body: _criarBody(),
    );
  }


  Widget _criarBody() => Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: [
            Campo(descricao: 'Código: '),
            Valor(valor: '${widget.tarefa.id}'),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Nome: '),
            Valor(valor: widget.tarefa.descricao),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Diferenciais: '),
            Valor(valor: widget.tarefa.descricao),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Detalhes: '),
            Valor(valor: widget.tarefa.descricao),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Localização: '),
            Valor(
              valor: 'Latitude: ${widget.pontoturistico.latitude}\nLongetude: ${widget.pontoturistico.longetude}',
            ),
            ElevatedButton(
                onPressed: _abrirCoordenadasNoMapaExterno,
                child: Icon(Icons.map)
            ),
            ElevatedButton(
                onPressed: _abrirCoordenadasNoMapaInterno,
                child: Icon(Icons.map)
            ),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Prazo: '),
            Valor(valor: widget.tarefa.prazoFormatado),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Finalizada: '),
            Valor(valor: widget.tarefa.finalizada ? 'Sim' : 'Não'),
          ],
        ),
      ],
    ),
  );
}


class Campo extends StatelessWidget {
  final String descricao;

  const Campo({Key? key, required this.descricao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text(
        descricao,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

void _abrirCoordenadasNoMapaExterno() {
  if (widget.pontoturistico.latitude.isEmpty || widget.pontoturistico.longetude.isEmpty ) {
    return;
  }
  MapsLauncher.launchCoordinates(double.parse(widget.pontoturistico.latitude), double.parse(widget.pontoturistico.longetude));
}

void _abrirCoordenadasNoMapaInterno(){
  if (widget.pontoturistico.latitude.isEmpty || widget.pontoturistico.longetude.isEmpty ){
    return;
  }
  Navigator.push(context,
    MaterialPageRoute(builder: (BuildContext context) => MapaPage(
        latitude: double.parse(widget.pontoturistico.latitude), longitude: double.parse(widget.pontoturistico.longetude)
    ),
    ),
  );
}
}

class Valor extends StatelessWidget {
  final String valor;

  const Valor({Key? key, required this.valor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Text(valor),
    );
  }
}

///fim



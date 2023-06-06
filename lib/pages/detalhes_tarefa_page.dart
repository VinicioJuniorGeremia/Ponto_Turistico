import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter/material.dart';
import '../model/tarefa.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gerenciador_tarefas_md/pages/mapa_interno.dart';


class DetalhestarefaPage extends StatefulWidget {
  final Tarefa tarefa;


  const DetalhestarefaPage({Key? key, required this.tarefa}) : super(key: key);


  @override
  _DetalhestarefaPageState createState() => _DetalhestarefaPageState();
}


class _DetalhestarefaPageState extends State<DetalhestarefaPage> {
  Position? _localizacaoAtual;
  var _distancia;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
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
            Valor(valor: widget.tarefa.nome),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Descrição: '),
            Valor(valor: widget.tarefa.descricao),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Diferenciais: '),
            Valor(valor: widget.tarefa.diferenciais),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Data de Inclusão: '),
            Valor(valor: widget.tarefa.prazoFormatado),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Latitude: '),
            Valor(valor: widget.tarefa.latitude),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Longitude: '),
            Valor(valor: widget.tarefa.longitude),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(
                Icons.map,
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Mapa Interno'),
              onPressed: _abrirCoordenadasMapaInterno,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.map_outlined,
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Mapa Externo'),
              onPressed: _abrirCoordenadasMapaExterno,
            )
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.route,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text('Cálculo da Distância'),
                  onPressed: _calcularDistancia,
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8), // Define um raio de borda para deixar os cantos arredondados
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  ' ${_localizacaoAtual == null ? "--" : _distancia}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )

          ],
        )

      ],
    ),
  );

  void _calcularDistancia(){
    _obterLocalizacaoAtual();


  }



  void _obterLocalizacaoAtual() async{
    bool servicoHabilitado = await _servicoHabilitado();
    if(!servicoHabilitado){
      return;
    }

    bool permissoesPermitidas = await _verificaPermissoes();
    if(!permissoesPermitidas){
      return;
    }

    Position posicao = await Geolocator.getCurrentPosition();
    setState(() {
      _localizacaoAtual = posicao;
      _distancia = Geolocator.distanceBetween(
          posicao!.latitude,
          posicao!.longitude,
          double.parse(widget.tarefa.latitude),
          double.parse(widget.tarefa.longitude));
      if(_distancia > 1000){
        var _distanciaKM = _distancia/1000;
        _distancia = "${double.parse((_distanciaKM).toStringAsFixed(2))}KM";
      }else{
        _distancia = "${_distancia.toStringAsFixed(2)}M";
      }
    });

  }


  Future<bool> _servicoHabilitado() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      await _mostrarMensagemDialog(
          'Para utilizar o recurso, necessita acessar as configurações para permitir o uso do serviço de localização.'
      );
      Geolocator.openAppSettings();
      return false;
    }

    return true;
  }


  Future<bool> _verificaPermissoes() async {
    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        await _mostrarMensagemDialog('Falta Permissão');
        return false;
      }

    }
    if (permissao == LocationPermission.deniedForever) {
      await _mostrarMensagemDialog(
          'Para utilizar o recurso, necessita acessar as configurações para permitir o uso do serviço de localização.'
      );
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }



  void _mostrarMensagem(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(mensagem)
        )
    );

  }


  Future<void> _mostrarMensagemDialog(String mensagem) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],

        );
      },

    );

  }


  void _abrirCoordenadasMapaInterno(){
    if(widget.tarefa.longitude == '' || widget.tarefa.latitude == ''){
      return;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MapaPage(
            latitue: double.parse(widget.tarefa.latitude),
            longitude: double.parse(widget.tarefa.longitude)))
    );

  }

  void _abrirCoordenadasMapaExterno(){
    if(widget.tarefa.longitude == '' || widget.tarefa.latitude == ''){
      return;
    }
    MapsLauncher.launchCoordinates(
        double.parse(widget.tarefa.latitude),
        double.parse(widget.tarefa.longitude)
    );

  }

}


class Campo extends StatelessWidget {
  final String descricao;

  const Campo({Key? key, required this.descricao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
      child: Text(
          descricao,
          style: TextStyle(fontWeight: FontWeight.bold)
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
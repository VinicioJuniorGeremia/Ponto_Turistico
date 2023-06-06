import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gerenciador_tarefas_md/pages/detalhes_tarefa_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dao/tarefa_dao.dart';
import '../model/tarefa.dart';
import 'conteudo_form_dialog.dart';
import 'filtro_page.dart';


class ListaTarefasPage extends StatefulWidget{
  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}


class _ListaTarefasPageState extends State<ListaTarefasPage>{


  static const ACAO_EDITAR = 'editar';
  static const ACAO_DELETAR = 'deletar';
  static const ACAO_VISUALIZAR = 'visualizar';


  final _tarefa = <Tarefa>[];
  final _dao = TarefaDao();
  var _carregando = false;
  Position? _localizacaoAtual;



  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Novo Ponto Turístico',
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      title: const Text(
        'Pontos Turísticos Cadastrados',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: _abrirPaginaFiltro,
          icon: const Icon(Icons.filter_list),
        ),
      ],

    );

  }


  void _abrirForm({Tarefa? pontoAtual, int? index}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                  pontoAtual == null ? 'Novo Ponto' : 'Ponto ID: ${pontoAtual.id}'
              ),
              content: ConteudoFormDialog(key: key, pontoAtual: pontoAtual),
              actions: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      TextButton(
                        onPressed: _obterLocalizacaoAtual,
                        child: Text('Obter Localização'),
                      ),
                      TextButton(
                        onPressed: () {
                          _salvar(key);
                        },
                        child: Text('Salvar'),
                      ),

                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancelar'),
                      ),
                    ],
                  ),

                ),

              ],
            ),

          );
        }
    );


  }

  void _salvar(key) {
    if (key.currentState?.dadosValidados() != true) {
      return;
    }
    Navigator.of(context).pop();
    final novaTarefa = key.currentState!.novoPonto;
    novaTarefa.latitude = _localizacaoAtual!.latitude.toString();
    novaTarefa.longitude = _localizacaoAtual!.longitude.toString();
    _dao.salvar(novaTarefa).then((success) {
      if (success) {
        _atualizarLista();
        _localizacaoAtual == null;
      }
    });

  }

  Widget _criarBody(){
    if (_carregando) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Carregando seus Pontos Turísticos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

          ),
        ],

      );
    }
    if(_tarefa.isEmpty){
      return const Center(
        child: Text('Não Existem Pontos Turísticos Cadastrados',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );

    }
    return ListView.separated(
      itemCount: _tarefa.length,
      itemBuilder: (BuildContext context, int index){
        final ponto = _tarefa[index];

        return Card(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      PopupMenuButton(
                          child: ListTile(
                            title: Text('${ponto.id} - ${ponto.nome}'),
                            subtitle: Text('Descrição: ${ponto.descricao}'),
                          ),
                          itemBuilder: (BuildContext context) => _criarItensMenu(),
                          onSelected: (String valorSelecionado){
                            if (valorSelecionado == ACAO_EDITAR){
                              _abrirForm(pontoAtual: ponto, index: index);
                            }else if(valorSelecionado == ACAO_VISUALIZAR) {
                              _abrirPaginaDetalhestarefa(ponto);
                            }else{
                              _excluir(ponto);
                            }
                          }
                      )

                    ],
                  ),

                ),
              ],

            )
        );

      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }


  void _excluir(Tarefa ponto){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Text('Atenção'),
                )
              ],
            ),
            content: Text("Esse registro será deletado permanentemente!!!"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    if (ponto.id == null) {
                      return;
                    }
                    _dao.remover(ponto.id!).then((success) {
                      if (success) {
                        _atualizarLista();
                      }
                    });
                  },
                  child: Text('Confirmar'))
            ],
          );

        }
    );

  }

  List<PopupMenuEntry<String>> _criarItensMenu(){
    return[
      PopupMenuItem(
        value: ACAO_EDITAR,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Editar'),
            )
          ],

        ),
      ),
      PopupMenuItem(
        value: ACAO_VISUALIZAR,
        child: Row(
          children: [
            Icon(Icons.remove_red_eye, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Visualizar'),
            )
          ],

        ),
      ),
      PopupMenuItem(
        value: ACAO_DELETAR,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Excluir'),
            )
          ],

        ),
      )
    ];
  }

  void _abrirPaginaFiltro() async {
    final navigator = Navigator.of(context);
    final alterouValores = await navigator.pushNamed(FiltroPage.routeName);
    if (alterouValores == true) {
      _atualizarLista();
    }
  }


  void _abrirPaginaDetalhestarefa(Tarefa tarefa) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalhestarefaPage(
            tarefa: tarefa,
          ),
        ));

  }


  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });
    // Carregar os valores do SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao =
        prefs.getString(FiltroPage.chaveCampoOrdenacao) ?? Tarefa.CAMPO_ID;
    final usarOrdemDecrescente =
        prefs.getBool(FiltroPage.chaveUsarOrdemDecresecente) == true;
    final filtroDescricao =
        prefs.getString(FiltroPage.chaveCampoDescricao) ?? '';
    final tarefa = await _dao.listar(
      filtro: filtroDescricao,
      campoOrdenacao: campoOrdenacao,
      usarOrdemDecrescente: usarOrdemDecrescente,
    );
    setState(() {
      _carregando = false;
      _tarefa.clear();
      if (tarefa.isNotEmpty) {
        _tarefa.addAll(tarefa);
      }
    });

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
    _localizacaoAtual = posicao;

  }

  Future<bool> _servicoHabilitado() async{
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if(!servicoHabilitado){
      await _mostrarMensagemDialog(
          'Para utilizar o recurso, necessita acessar as configurações para permitir o uso do serviço de localização'
      );
      Geolocator.openAppSettings();
      return false;
    }

    return true;
  }

  Future<bool> _verificaPermissoes() async{
    LocationPermission permissao = await Geolocator.checkPermission();

    if(permissao == LocationPermission.denied){
      permissao = await Geolocator.requestPermission();


      if(permissao == LocationPermission.denied){
        _mostrarMensagem('O recurso não pôde ser utilizado devido à falta de permissão. Por favor, verifique as configurações do dispositivo e conceda permissão para acessar o serviço de localização.');
        return false;
      }
    }
    if(permissao == LocationPermission.deniedForever){
      await _mostrarMensagemDialog(
          'Para utilizar o recurso, será necessário acessar as configurações do dispositivo para permitir o acesso ao serviço de localização..'
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

  Future<void> _mostrarMensagemDialog(String mensagem) async{
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Atenção'),
          content: Text(mensagem),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK')
            )
          ],

        )
    );

  }

}
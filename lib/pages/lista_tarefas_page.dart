import 'package:gerenciador_tarefas_md/pages/filtro_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'conteudo_form_dialog.dart';
import 'package:gerenciador_tarefas_md/model/tarefa.dart';



class ListaTarefaPage extends StatefulWidget {
  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}


class _ListaTarefasPageState extends State<ListaTarefaPage> {
  static const ACAO_VISUALIZAR = 'visualizar';
  static const ACAO_EXCLUIR = 'excluir';
  static const ACAO_EDITAR = 'editar';

  final tarefas = <Tarefa>[];
  var _ultimoId = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _abrirForm(tarefaAtual: null, index: null, readonly: false),
        tooltip: 'Novo ponto turístico',
        child: const Icon(Icons.add),
      ),
    );
  }


  void _abrirForm({Tarefa? tarefaAtual, int? index, bool? readonly}) {
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(tarefaAtual == null
                ? 'Novo ponto turístico'
                : 'Alterar ponto turístico ${tarefaAtual.id}'),
            content: ConteudoFormDialog(key: key, tarefaAtual: tarefaAtual),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              if (readonly == null || readonly == false)
                TextButton(
                  onPressed: () {
                    if (key.currentState != null &&
                        key.currentState!.dadosValidados()) {
                      setState(() {
                        final novaTarefa = key.currentState!.novaTarefa;
                        if (index == null) {
                          novaTarefa.id = ++_ultimoId;
                          tarefas.add(novaTarefa);
                        } else {
                          tarefas[index] = novaTarefa;
                        }
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('salvar'),
                ),
            ],
          );
        });
  }


  AppBar _criarAppBar() {
    return AppBar(
      title: const Text('Cadastro de pontos turísticos'),
      actions: [
        IconButton(
            onPressed: _abrirPaginaFiltro, icon: const Icon(Icons.filter_list)),
      ],
    );
  }


  Widget _criarBody() {
    if (tarefas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum ponto turístico cadastrado',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.separated(
      itemCount: tarefas.length,
      itemBuilder: (BuildContext context, int index) {
        final tarefa = tarefas[index];
        return PopupMenuButton<String>(
            child: ListTile(
              title: Text('${tarefa.id} - ${tarefa.descricao}'),
              subtitle: Text(tarefa.prazo == null
                  ? 'Tarefa sem prazo definido'
                  : 'Prazo - ${tarefa.prazoFormatado}'),
            ),
            itemBuilder: (BuildContext context) => _criarItensMenu(),
            onSelected: (String valorSelecinado) {
              if (valorSelecinado == ACAO_EDITAR) {
                _abrirForm(tarefaAtual: tarefa, index: index, readonly: false);
              } else if (valorSelecinado == ACAO_EXCLUIR) {
                _excluir(index);
              } else {
                _abrirForm(tarefaAtual: tarefa, index: index, readonly: true);
              }
            });
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }


  void _excluir(int indice) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Atenção'),
                )
              ],
            ),
            content: Text('O registro será deletado'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      tarefas.removeAt(indice);
                    });
                  },
                  child: Text('OK'))
            ],
          );
        });
  }


  List<PopupMenuEntry<String>> _criarItensMenu() {
    return [
      PopupMenuItem(
        value: ACAO_VISUALIZAR,
        child: Row(
          children: [
            Icon(Icons.visibility, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Visualizar'),
            )
          ],
        ),
      ),
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
        value: ACAO_EXCLUIR,
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


  void _visualizar() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.routeName).then((alterouValores) {
      if (alterouValores == true) {
      }
    });
  }


  void _abrirPaginaFiltro() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.routeName).then((alterouValores) {
      if (alterouValores == true) {
      }
    });
  }
}
///fim

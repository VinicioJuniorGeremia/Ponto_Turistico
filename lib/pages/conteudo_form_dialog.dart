import '../model/tarefa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:intl/intl.dart';

class ConteudoFormDialog extends StatefulWidget{
  final Tarefa? tarefaAtual;


  ConteudoFormDialog({Key? key, this.tarefaAtual}) : super (key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();

}
class ConteudoFormDialogState extends State<ConteudoFormDialog> {

  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final prazoController = TextEditingController();
  final diferenciaisController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.tarefaAtual != null) {
      descricaoController.text = widget.tarefaAtual!.descricao;
      prazoController.text = widget.tarefaAtual!.prazoFormatado;
      diferenciaisController.text = widget.tarefaAtual!.diferenciais;
    }
    prazoController.text = _dateFormat.format(DateTime.now());
  }
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Informe a descrição';
                }
                return null;
              },
            ),
            TextFormField(
              controller: diferenciaisController,
              decoration: InputDecoration(labelText: 'Diferenciais'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Informe os diferenciais';
                }
                return null;
              },
            ),
            TextFormField(
              controller: prazoController,
              decoration: InputDecoration(labelText: 'Prazo',
                prefixIcon: IconButton(
                  onPressed: _mostrarCalendario,
                  icon: Icon(Icons.calendar_today),
                ),
                suffixIcon: IconButton(
                  onPressed: () => prazoController.clear(),
                  icon: Icon(Icons.close),
                ),
              ),
              readOnly: true,
            ),
          ],
        )
    );
  }
  void _mostrarCalendario() {
    final dataFormatada = prazoController.text;
    var data = DateTime.now();
    if (dataFormatada.isNotEmpty) {
      data = _dateFormat.parse(dataFormatada);
    }
    showDatePicker(context: context,
      initialDate: data,
      lastDate: data.add(Duration(days: 365 * 5)),
      firstDate: data.subtract(Duration(days: 365 * 5)),
    ).then((DateTime? dataSElecionada) {
      if (dataSElecionada != null) {
        setState(() {
          prazoController.text = _dateFormat.format(dataSElecionada);
        });
      }
    });
  }


  bool dadosValidados()=> formKey.currentState?.validate() == true;

  Tarefa get novaTarefa => Tarefa(
    id: widget.tarefaAtual?.id ?? 0,
    diferenciais: diferenciaisController.text,
    descricao: descricaoController.text,
    prazo: !prazoController.text.isNotEmpty ? null : _dateFormat.parse(prazoController.text),
  );
}
///fim
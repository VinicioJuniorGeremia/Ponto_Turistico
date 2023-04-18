import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/tarefa.dart';
import 'dart:core';


class ConteudoFormDialog extends StatefulWidget{
  final Tarefa? tarefaAtual;


  ConteudoFormDialog({Key? key, this.tarefaAtual}) : super (key: key);



  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();


}
class ConteudoFormDialogState extends State<ConteudoFormDialog> {


  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final diferenciaisController = TextEditingController();
  final detalhesController = TextEditingController();
  final prazoController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');



  @override
  void initState() {
    super.initState();
    if (widget.tarefaAtual != null) {
      descricaoController.text = widget.tarefaAtual!.descricao;
      diferenciaisController.text = widget.tarefaAtual!.diferenciais!;
      detalhesController.text = widget.tarefaAtual!.detalhes!;
      prazoController.text = widget.tarefaAtual!.prazoFormatado;
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
              decoration: InputDecoration(labelText: 'Detalhes'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Informe os detalhes';
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
              controller: detalhesController,
              decoration: InputDecoration(labelText: 'Detalhes'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Informe os detalhes';
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
      firstDate: data.subtract(Duration(days: 365 * 5)),
      lastDate: data.add(Duration(days: 365 * 5)),
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
    descricao: descricaoController.text,
    diferenciais: diferenciaisController.text,
    detalhes: detalhesController.text,
    prazo: !prazoController.text.isNotEmpty ? null : _dateFormat.parse(prazoController.text),

  );

}
///fim




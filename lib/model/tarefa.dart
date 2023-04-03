

import 'package:intl/intl.dart';

class Tarefa{

    static const CAMPO_ID = 'id';
    static const CAMPO_DESCRICAO = 'descricao';
    static const CAMPO_DIFERENCIAIS = 'diferenciais';
    static const CAMPO_NOME = 'nome';
    static const CAMPO_DATA_INCLUSAO = 'prazo';
    static const CAMPO_PRAZO = 'prazo';

    int id;
    String descricao;
    DateTime? prazo;
    String diferenciais;



    Tarefa({required this.id, required this.descricao,required this.diferenciais, this.prazo});
    String get prazoFormatado{
        if (prazo == null){
            return ' ';
        }
        return DateFormat('dd/MM/yyy').format(prazo!);
    }
}
///fim
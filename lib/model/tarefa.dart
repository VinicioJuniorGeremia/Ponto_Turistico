import 'package:intl/intl.dart';

class Tarefa{
    static const NOME_TABELA = 'Tarefa';
    static const CAMPO_ID = '_id';
    static const CAMPO_NOME = 'nome';
    static const CAMPO_DESCRICAO = 'descricao';
    static const CAMPO_DIFERENCIAIS = 'diferenciais';
    static const CAMPO_INCLUSAO = 'inclusao';
    static const CAMPO_LATITUDE = 'latitude';
    static const CAMPO_LONGITUDE = 'longitude';
    static const CAMPO_CEP = 'cep';


    int id;
    String nome;
    String descricao;
    String diferenciais;
    DateTime? dataInclusao;
    bool finalizada;
    String latitude;
    String longitude;
    String cep;


    Tarefa({
        required this.id,
        required this.nome,
        required this.descricao,
        required this.diferenciais,
        this.dataInclusao,
        this.finalizada = false,
        required this.latitude,
        required this.longitude,
        required this.cep

    });

    String get prazoFormatado{
        if (dataInclusao == null){
            return '';
        }

        return DateFormat('dd/MM/yyyy').format(dataInclusao!);
    }


    Map<String, dynamic> toMap() => {
        CAMPO_ID: id == 0 ? null : id,
        CAMPO_NOME: nome,
        CAMPO_DIFERENCIAIS: diferenciais,
        CAMPO_DESCRICAO: descricao,
        CAMPO_INCLUSAO:
        dataInclusao == null ? null : DateFormat("yyyy-MM-dd").format(dataInclusao!),
        CAMPO_LATITUDE: latitude,
        CAMPO_LONGITUDE: longitude,
        CAMPO_CEP: cep


    };

    factory Tarefa.fromMap(Map<String, dynamic> map) => Tarefa(
        id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
        nome: map[CAMPO_NOME] is String ? map[CAMPO_NOME] : '',
        descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
        diferenciais: map[CAMPO_DIFERENCIAIS] is String ? map[CAMPO_DIFERENCIAIS] : '',
        dataInclusao: map[CAMPO_INCLUSAO] is String
            ? DateFormat("yyyy-MM-dd").parse(map[CAMPO_INCLUSAO])
            : null,
        latitude: map[CAMPO_LATITUDE] is String ? map[CAMPO_LATITUDE] : '',
        longitude: map[CAMPO_LONGITUDE] is String ? map[CAMPO_LONGITUDE] : '',
        cep: map[CAMPO_CEP] is String ? map[CAMPO_CEP] : ''
    );


}
///fim
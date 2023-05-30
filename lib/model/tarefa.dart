import 'package:intl/intl.dart';


class Tarefa {
    static const nomeTabela = 'tarefa';
    static const campoId = '_id';
    static const campoDescricao = 'descricao';
    static const campoDiferenciais = "diferenciais";
    static const campoDetalhes = "detalhes";
    static const campoPrazo = 'prazo';
    static const campoFinalizada = 'finalizada';
    static const campoLongetude = 'longetude';
    static const campoLatitude = 'latitude';


    int? id;
    String descricao;
    String diferenciais;
    String detalhes;
    DateTime? prazo;
    bool finalizada;
    String longetude;
    String latitude;


    Tarefa({
        this.id,
        required this.descricao,
        required this.diferenciais,
        required this.detalhes,
        this.prazo,
        this.finalizada = false,
        required this.latitude,
        required this.longetude
    });


    String get prazoFormatado {
        if (prazo == null) {
            return '';
        }
        return DateFormat('dd/MM/yyyy').format(prazo!);
    }


    Map<String, dynamic> toMap() => {
        campoId: id,
        campoDescricao: descricao,
        campoDiferenciais: diferenciais,
        campoDetalhes: detalhes,
        campoPrazo:
        prazo == null ? null : DateFormat("yyyy-MM-dd").format(prazo!),
        campoLatitude:latitude,
        campoLongetude:longetude,
        campoFinalizada: finalizada ? 1 : 0,
    };


    factory Tarefa.fromMap(Map<String, dynamic> map) => Tarefa(
        id: map[campoId] is int ? map[campoId] : null,
        descricao: map[campoDescricao] is String ? map[campoDescricao] : '',
        diferenciais: map[campoDiferenciais] is String ? map[campoDiferenciais] : '',
        latitude: map[campoLatitude] is String ? map[campoLatitude] : '',
        longetude: map[campoLongetude] is String ? map[campoLongetude] : '',
        detalhes: map[campoDetalhes] is String ? map[campoDetalhes] : '',
        prazo: map[campoPrazo] is String
            ? DateFormat("yyyy-MM-dd").parse(map[campoPrazo])
            : null,
        finalizada: map[campoFinalizada] == 1,
    );

}

///fim



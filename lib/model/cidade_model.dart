import 'dart:convert';



class Cidade{
  static const campoCodigo = 'codigo';
  static const campoUf = 'uf';
  static const campoNome = 'nome';




  int? codigo;
  String uf;
  String nome;



  Cidade({this.codigo,  required this.uf, required this.nome});

  factory Cidade.fromJson(Map<String, dynamic> json) => Cidade(
    codigo: int.tryParse(json[campoCodigo]?.toString() ?? ''),
    uf: json[campoUf]?.toString() ?? '',
    nome: json[campoNome]?.toString() ?? '',

  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    campoCodigo : codigo,
    campoUf : uf,
    campoNome : nome,

  };
}
import 'package:academia/models/exercicio_model.dart';
import 'package:academia/models/ficha_model.dart';
import 'package:academia/models/user_model.dart';
import 'package:academia/objectbox.g.dart';
import 'package:academia/services/user_service.dart';
import 'package:academia/services/user_session.dart';
import 'package:flutter/material.dart';
import '../services/ficha_service.dart';

class FichaViewmodel extends ChangeNotifier {
  final FichaService fichaService = FichaService();
  int id_user = UserSession().getId()!;

  List<Ficha> _fichas = [];
  List<Ficha> get fichas => _fichas;

  List<Exercicio> _exercicios = [];
  List<Exercicio> get exercicios => _exercicios;

  late int idFicha;
  late String nome;

  void criarFicha(String nome) {
    Ficha ficha = Ficha(titulo: nome);

    Usuario userLogado = UserService().buscaUsuarioPorId(id_user)!;
    fichaService.adicionarFicha(ficha, userLogado);
    carregarFichas();
  }

  void carregarFichas() {
    Usuario userLogado = UserService().buscaUsuarioPorId(id_user)!;
    _fichas = userLogado.fichas;
    notifyListeners();
  }

  void carregarExerciciosFicha(int idFicha) {
    this.idFicha = idFicha;

    if (idFicha > 0) {
      Ficha fichaAtual_ = fichaAtual(idFicha);
      _exercicios = fichaAtual_.exercicios;
      this.nome = fichaAtual_.titulo;
    }
    notifyListeners();
  }

  void salvaExercicio(
    int rep,
    int series,
    String exercicio,
    String musculo,
    int id,
  ) {
    Exercicio novoExercicio = criaExercicio(rep, series, exercicio, musculo);
    Ficha ficha = fichaAtual(id);
    ficha.exercicios.add(novoExercicio);
    fichaService.salvarExercicio(ficha, novoExercicio);
  }

  Exercicio criaExercicio(int rep, int series, exercicio, musculo) {
    return Exercicio(
      nome: exercicio,
      musculoAlvo: musculo,
      series: series,
      repeticoes: rep,
    );
  }

  Ficha fichaAtual(int idFicha) {
    return FichaService().buscaFichaPorId(idFicha);
  }
}

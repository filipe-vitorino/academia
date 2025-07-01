import 'package:academia/models/exercicio_model.dart';
import 'package:academia/models/ficha_model.dart';
import 'package:academia/models/user_model.dart';
import 'package:academia/services/user_service.dart';
import 'package:academia/services/user_session.dart';
import 'package:flutter/material.dart';
import '../services/ficha_service.dart';

class FichaViewmodel extends ChangeNotifier {
  // Instancia o nosso novo e robusto FichaService.
  final FichaService fichaService = FichaService();
  final UserService userService = UserService();

  int? get userId => UserSession().getId();

  List<Ficha> _fichas = [];
  List<Ficha> get fichas => _fichas;

  List<Exercicio> _exercicios = [];
  List<Exercicio> get exercicios => _exercicios;

  bool _isLoadingExercicios = false;
  bool get isLoadingExercicios => _isLoadingExercicios;

  late int idFicha;
  late String nome;

  /// Carrega os exercícios de forma segura, limpando o estado anterior para evitar "vazamento" de dados.
  /// ESTE MÉTODO CORRIGE O BUG DE UMA FICHA MOSTRAR EXERCÍCIOS DE OUTRA.
  Future<void> carregarExerciciosFicha(int fichaId) async {
    _isLoadingExercicios = true;
    _exercicios = []; // Limpa a lista antiga imediatamente.
    notifyListeners();

    this.idFicha = fichaId;

    if (idFicha > 0) {
      try {
        Ficha fichaAtual_ = fichaService.buscaFichaPorId(idFicha);
        _exercicios = fichaAtual_.exercicios;
        this.nome = fichaAtual_.titulo;
      } catch (e) {
        _exercicios = [];
        debugPrint("Erro ao carregar exercícios: $e");
      }
    }

    _isLoadingExercicios = false;
    notifyListeners();
  }

  /// Cria e salva um novo exercício usando o método correto do serviço.
  Future<void> salvaExercicio(
    int rep,
    int series,
    String nomeExercicio,
    String musculo,
    int fichaId,
  ) async {
    final novoExercicio = Exercicio(
      nome: nomeExercicio,
      musculoAlvo: musculo,
      series: series,
      repeticoes: rep,
    );

    // Chama o método correto e robusto do serviço.
    fichaService.addExercicioToFicha(fichaId, novoExercicio);

    // Após o serviço garantir o salvamento, recarrega o estado para a UI.
    await carregarExerciciosFicha(fichaId);
  }

  // --- O resto dos métodos não precisa de mudança ---
  void carregarFichas() {
    if (userId == null) return;
    Usuario? userLogado = userService.buscaUsuarioPorId(userId!);
    if (userLogado != null) {
      _fichas = userLogado.fichas;
      notifyListeners();
    }
  }

  int criarFicha(String nome) {
    int id_correto = 0;
    if (userId == null) return 0;
    final ficha = Ficha(titulo: nome);
    final userLogado = userService.buscaUsuarioPorId(userId!);
    if (userLogado != null) {
      id_correto = fichaService.adicionarFicha(ficha, userLogado);
      carregarFichas();
    }
    return id_correto;
  }
}

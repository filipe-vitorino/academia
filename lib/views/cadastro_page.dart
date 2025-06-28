import '../viewmodels/cadastro_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  void _voltar() {
    Navigator.pop(context); // Retorna para a tela anterior
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CadastroViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (viewModel.sucessoCadastro) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        viewModel.resetarEstado(); // evita mostrar de novo se voltar
        Navigator.pop(context);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextField(
                key: const Key('cadastro_nome_field'),
                onChanged: viewModel.setNome,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  errorText: viewModel.erroNome,
                ),
              ),

              const SizedBox(height: 16),
              TextField(
                key: const Key('cadastro_email_field'),
                onChanged: viewModel.setEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: viewModel.erroEmail,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('cadastro_senha_field'),
                controller: _senhaController,
                obscureText: true,
                onChanged: viewModel.setSenha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  errorText: viewModel.erroSenha,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('cadastro_confirmar_senha_field'),
                controller: _confirmarSenhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirme sua senha',
                ),
                validator:
                    (value) =>
                        value == _senhaController.text
                            ? null
                            : 'As senhas não coincidem',
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                key: const Key('cadastro_submit_button'),
                onPressed:
                    viewModel.formularioValido
                        ? viewModel.cadastrarUsuario
                        : null,
                child: const Text('Cadastrar'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: _voltar, child: const Text('Voltar')),
            ],
          ),
        ),
      ),
    );
  }
}

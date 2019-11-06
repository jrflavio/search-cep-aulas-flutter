import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:search_cep/services/via_cep_service.dart';
import 'package:search_cep/themes/orange_theme.dart';
import 'package:search_cep/themes/dark_theme.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _searchCepController = TextEditingController();
  TextEditingController _logradouroController = TextEditingController();
  TextEditingController _complementoController = TextEditingController();
  TextEditingController _bairroController = TextEditingController();
  TextEditingController _localidadeController = TextEditingController();
  TextEditingController _ufController = TextEditingController();
  TextEditingController _unidadeCepController = TextEditingController();
  TextEditingController _ibgeCepController = TextEditingController();
  TextEditingController _giaController = TextEditingController();

  bool _loading = false;
  bool _enableField = true;

  String _result;
  String _logradouro;
  String _complemento;
  String _bairro;
  String _localidade;
  String _uf;
  String _unidade;
  String _ibge;
  String _gia;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar CEP'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(
                  "CEP: ${_searchCepController.text}\nLocalidade: ${_localidadeController.text}\nBairro: ${_bairroController.text}\nLogradouro: ${_logradouroController.text}\nComplemento: ${_complementoController.text}\nIbge: ${_ibgeCepController.text}\nEstado: ${_ufController.text}\nGia: ${_giaController.text}" ??'');
            },
          ),
          IconButton(
            icon: Icon(Icons.lightbulb_outline),
            onPressed: () {
              if (Theme.of(context).brightness == Brightness.light) {
                DynamicTheme.of(context).setThemeData(myDarkTheme);
              } else {
                DynamicTheme.of(context).setThemeData(myLightTheme);
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
            ),
            onPressed: () {
              _resetFields();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildSearchCepTextField(),
              _buildResultsForm(),
              _buildSearchCepButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _resetFields() {
    _searchCepController.text = '';
    _logradouroController.text = '';
    _complementoController.text = '';
    _bairroController.text = '';
    _ufController.text = '';
    _ibgeCepController.text = '';
    _giaController.text = '';
    _localidadeController.text = '';
  }

  Widget _buildSearchCepTextField({String error}) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Cep'),
      keyboardType: TextInputType.number,
      controller: _searchCepController,
      validator: (value) {
        if(value.length != 8){
          return 'Cep Inválido!';
        }else if (value.isEmpty) {
          return 'Insira o cep!';
        }
        return null;
      },
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        onPressed: () {
          if(_formKey.currentState.validate()){
            _searchCep();
          }
        },
        child: Text('Consultar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _logradouro = enable ? '' : _logradouro;
      _complemento = enable ? '' : _complemento;
      _bairro = enable ? '' : _bairro;
      _localidade = enable ? '' : _localidade;
      _uf = enable ? '' : _uf;
      _unidade = enable ? '' : _unidade;
      _ibge = enable ? '' : _ibge;
      _gia = enable ? '' : _gia;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;

    final resultCep = await ViaCepService.fetchCep(cep: cep);

    setState(() {
      _result = resultCep.cep;
      _logradouroController.text = resultCep.logradouro;
      _complementoController.text = resultCep.complemento;
      _bairroController.text = resultCep.bairro;
      _localidadeController.text = resultCep.localidade;
      _ufController.text = resultCep.uf;
      _unidadeCepController.text = resultCep.unidade;
      _ibgeCepController.text = resultCep.ibge;
      _giaController.text = resultCep.gia;
    });

    _searching(false);
  }

  Widget _buildResultsForm() {
    return Form(
      child: Column(
        children: <Widget>[
          _buildResultsList('Logradouro', _logradouroController),
          _buildResultsList('Localidade', _localidadeController),
          _buildResultsList('Complemento', _complementoController),
          _buildResultsList('UF', _ufController),
          _buildResultsList('Unidade', _unidadeCepController),
          _buildResultsList('Gia', _giaController),
          _buildResultsList('Bairro', _bairroController),
          _buildResultsList('Ibge', _ibgeCepController),
        ],
      ),
    );
  }

  Widget _buildResultsList(String label, TextEditingController controller) {
    return TextField(
      enabled: false,
      decoration: InputDecoration(labelText: label),
      controller: controller,
    );
  }
}

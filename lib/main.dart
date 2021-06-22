import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    var bd = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sql =
          "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
      db.execute(sql);
    });
    return bd;
    //print("aberto: " + retorno.isOpen.toString());
  }

  _salvar() async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {"nome": "Jose Roberto", "idade": 28};
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo: $id");
  }

  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios";
    // "SELECT * FROM usuarios WHERE id = 5";
    // "SELECT * FROM usuarios WHERE idade >= 30 AND idade <= 58";
    // "SELECT * FROM usuarios WHERE idade BETWEEN 18 AND 46"
    // "SELECT * FROM usuarios WHERE idade IN (18,30)"
    // "SELECT * FROM usuarios WHERE nome LIKE 'Peterson Scaramussi'"
    // "SELECT * FROM usuarios WHERE nome LIKE 'Peterson%'"
    // "SELECT * FROM usuarios WHERE 1=1 ORDER BY nome ASC" ASC ou DESC
    // "SELECT * FROM usuarios WHERE 1=1 ORDER BY idade DESC"
    // "SELECT * FROM usuarios WHERE 1=1 ORDER BY idade DESC LIMIT 3"

    List usuarios = await bd.rawQuery(sql);

    for (var usuario in usuarios) {
      print("iitem id: " +
          usuario['id'].toString() +
          " nome: " +
          usuario['nome'] +
          " idade: " +
          usuario['idade'].toString());
    }
    //print("usuarios: " + usuarios.toString());
  }

  _listarUsuarioPeloId(int id) async {
    Database bd = await _recuperarBancoDados();
    //CRUD -> Create, Read, Update and Delete
    List usuarios = await bd.query("usuarios",
        columns: ["id", "nome", "idade"], where: "id = ? ", whereArgs: [id]);

    for (var usuario in usuarios) {
      print("iitem id: " +
          usuario['id'].toString() +
          " nome: " +
          usuario['nome'] +
          " idade: " +
          usuario['idade'].toString());
    }
  }

  _excluirUsuario(int id) async {
    Database bd = await _recuperarBancoDados();

    int retorno = await bd.delete("usuarios", where: "id = ?", whereArgs: [id]);

    print("item qtde removida:  $retorno");
  }

  _atualizarUsuario(int id) async {
    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {"nome": "José", "idade": 67};

    int retorno = await bd
        .update("usuarios", dadosUsuario, where: "id = ?", whereArgs: [id]);

    print("item qtde atualizada: $retorno");
  }

  @override
  Widget build(BuildContext context) {
    //_salvar();
    //_excluirUsuario(5);
    // _listarUsuarioPeloId(1);
    _atualizarUsuario(3);
    _listarUsuarios();
    return Container();
  }
}

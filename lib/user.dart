class User{

  final String uid;

  User ({this.uid});
}

class UserData{
  final String uid;
  final bool autorizacao;
  final String morador;
  final String residencia;
  final String condominio;

  UserData({this.uid, this.autorizacao, this.morador, this.residencia, this.condominio});

}
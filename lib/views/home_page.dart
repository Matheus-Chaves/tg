import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tg/views/cliente_home_page.dart';
import 'package:tg/views/meu_perfil.dart';
import 'package:tg/views/prestador_home_page.dart';
import 'package:tg/views/cliente_requests.dart';
import 'package:tg/views/prestador_requests.dart';

import '../auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.tipoUsuario}) : super(key: key);
  String? tipoUsuario;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  int _selectedIndex = 0;
  List<Widget>? routes;
  List<GButton>? tabs;

  getTipoUsuario(User? user) async {
    var userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    return userData.data()!['tipoUsuario'];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.tipoUsuario == "prestador") {
        debugPrint("prestador");
        prestadorVariables();
        return;
      }

      if (widget.tipoUsuario == "cliente") {
        debugPrint("cliente");
        clienteVariables();
        return;
      }

      getTipoUsuario(user).then((value) {
        if (value.contains("prestador")) {
          debugPrint("firebase prestador");
          prestadorVariables();
        } else {
          debugPrint("firebase cliente");
          clienteVariables();
        }
      });
    });
  }

  void clienteVariables() {
    setState(() {
      routes = <Widget>[
        const ClienteHomePage(),
        const ClienteRequests(),
        const MeuPerfil(tipoUsuario: "cliente"),
      ];
      tabs = [
        const GButton(
          icon: Icons.home,
          text: 'Início',
        ),
        const GButton(
          icon: Icons.list,
          text: 'Solicitações',
        ),
        const GButton(
          icon: Icons.person,
          text: 'Meu perfil',
        )
      ];
    });
  }

  void prestadorVariables() {
    setState(() {
      routes = <Widget>[
        const PrestadorHomePage(),
        const PrestadorRequests(),
        const MeuPerfil(tipoUsuario: "prestador"),
      ];

      tabs = [
        const GButton(
          icon: Icons.home,
          text: 'Meus serviços',
        ),
        const GButton(
          icon: Icons.list,
          text: 'Requisições',
        ),
        const GButton(
          icon: Icons.person,
          text: 'Meu perfil',
        )
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: routes?[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.green.shade800,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GNav(
              hoverColor: Colors.green,
              haptic: true,
              tabBorderRadius: 15,
              gap: 8,
              color: Colors.grey[300],
              activeColor: Colors.green.shade800,
              iconSize: 24,
              backgroundColor: Colors.green.shade800,
              tabBackgroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              tabs: tabs ??
                  [
                    const GButton(
                      icon: Icons.home,
                      text: '-',
                    ),
                    const GButton(
                      icon: Icons.list,
                      text: '-',
                    ),
                    const GButton(
                      icon: Icons.person,
                      text: '-',
                    )
                  ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

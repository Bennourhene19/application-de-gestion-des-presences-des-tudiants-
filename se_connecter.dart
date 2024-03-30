import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String _validUsername = 'utilisateur';
  final String _validPassword = 'motdepasse';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50.0),
                Image.asset(
                  'assets/logo.jpeg',
                  height: 150.0,
                ),
                const SizedBox(height: 30.0),
                Text(
                  'PROGRES',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  'Ministère de l Enseignement Supérieur et de la Recherche Scientifique',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 50.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom d\'utilisateur',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _handleLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    final String enteredUsername = _usernameController.text.trim();
    final String enteredPassword = _passwordController.text.trim();

    if (enteredUsername == _validUsername &&
        enteredPassword == _validPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur de connexion'),
            content:
                const Text('Nom d\'utilisateur ou mot de passe incorrect.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.green,
                    width: 4.0,
                  ),
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScannerPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 200, 230, 201),
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.scanner, color: Colors.black),
                ),
                label: const Text(
                  'Scanner',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentsListPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 200, 230, 201),
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.list, color: Colors.black),
                ),
                label: const Text(
                  'Liste des étudiants',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.green,
                    width: 4.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatisticsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 200, 230, 201),
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.bar_chart, color: Colors.black),
                ),
                label: const Text(
                  'Statistiques',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.green,
                    width: 4.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 200, 230, 201),
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    icon: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.account_circle, color: Colors.black),
                    ),
                    label: Text(
                      'Mon compte',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.green,
                        width: 4.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String _scanResult = 'Aucun résultat';

  Future<void> _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        _scanResult = qrResult;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          _scanResult = 'Accès à la caméra refusé';
        });
      } else {
        setState(() {
          _scanResult = 'Erreur inconnue: $e';
        });
      }
    } on FormatException {
      setState(() {
        _scanResult = 'Vous avez annulé le scan';
      });
    } catch (e) {
      setState(() {
        _scanResult = 'Erreur inattendue: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _scanQR,
              child: Text('Scanner une carte étudiante'),
            ),
            SizedBox(height: 20),
            Text(_scanResult),
          ],
        ),
      ),
    );
  }
}

class StudentsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des étudiants'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text('Page de la liste des étudiants'),
      ),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text('Page des statistiques'),
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon compte'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text('Page du compte'),
      ),
    );
  }
}

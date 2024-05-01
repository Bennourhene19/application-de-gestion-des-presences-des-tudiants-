import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'bdd.dart'; // Importer la liste des utilisateurs autorisés
import 'package:provider/provider.dart';
//import 'package:http/http.dart' as http; // Importer le package HTTP
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Importer pour utiliser jsonEncode

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          MyAppState(), // Fournir l'état global de l'application
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green, // Couleur principale de votre application
          // Définir d'autres attributs de thème ici selon votre application
        ),
        home: Consumer<MyAppState>(
          builder: (context, appState, _) {
            if (appState.currentUser != null) {
              return const HomePage(); // Si l'utilisateur est connecté, afficher la page d'accueil
            } else {
              return const LoginPage(); // Sinon, afficher la page de connexion
            }
          },
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GestionnaireDonnees gestionnaire = GestionnaireDonnees();

  @override
  Widget build(BuildContext context) {
    gestionnaire
        .chargerSeances(); // Charger les séances lors du démarrage de l'application
    return const MaterialApp(
        // ...
        );
  }
}

class MyAppState extends ChangeNotifier {
  User? currentUser; // Utilisateur actuellement connecté
  int presenceCount = 0;
  int absenceCount = 0;
  GestionnaireDonnees gestionnaire = GestionnaireDonnees();
  final ValueNotifier<int> seancesNotifier =
      ValueNotifier<int>(0); // Ajoutez cette ligne

  void updateAttendanceCounts(int presence, int absence) {
    presenceCount = presence;
    absenceCount = absence;
    notifyListeners();
  }

  bool loginUser(String username, String password) {
    // Recherchez l'utilisateur dans la liste des utilisateurs valides
    for (var user in validUsers) {
      if (user.username == username && user.password == password) {
        currentUser = user;
        notifyListeners(); // Notifiez les écouteurs du changement d'utilisateur
        return true;
      }
    }
    return false;
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
  bool _isLoading = false;

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
                //Image.asset('assets/logo.jpeg',height: 150.0,),

                const SizedBox(height: 100.0),
                Text(
                  'PFE',
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
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Se connecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    setState(() {
      _isLoading = true;
    });

    // Simuler le processus de connexion
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      final String enteredUsername = _usernameController.text.trim();
      final String enteredPassword = _passwordController.text.trim();

      // Vérifier si les informations de connexion sont valides
      bool isValidUser = Provider.of<MyAppState>(context, listen: false)
          .loginUser(enteredUsername, enteredPassword);

      if (isValidUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomePage()), // Passer à la page d'accueil
        );
      } else {
        // Afficher une boîte de dialogue en cas d'échec de la connexion
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
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                    color: Colors.green, // Couleur de la bordure
                    width: 4.0, // Largeur de la bordure
                  ),
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScannerPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 200, 230, 201)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical: 40.0)),
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                ),
                icon: const Padding(
                  padding:
                      EdgeInsets.only(left: 8.0), // Ajout de padding à gauche
                  child: Icon(Icons.scanner,
                      color: Colors.black), // icône pour le bouton Scanner
                ),
                label: const Text(
                  'Scanner',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            //---------------------------------------
            const SizedBox(height: 20),
            //---------------------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.green, // Couleur de la bordure
                    width: 4.0, // Largeur de la bordure
                  ),
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SessionsPage(gestionnaire: GestionnaireDonnees())),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 200, 230, 201)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical: 40.0)),
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                ),
                icon: const Padding(
                  padding:
                      EdgeInsets.only(left: 8.0), // Ajout de padding à gauche
                  child: Icon(Icons.book,
                      color: Colors.black), // icône pour le bouton Scanner
                ),
                label: const Text(
                  'Scéances',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            const SizedBox(height: 20),

            //-------------------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.green, // Couleur de la bordure
                    width: 4.0, // Largeur de la bordure
                  ),
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentsListPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 200, 230, 201)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical: 40.0)),
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                ),
                icon: const Padding(
                  padding:
                      EdgeInsets.only(left: 8.0), // Ajout de padding à gauche
                  child: Icon(Icons.list,
                      color: Colors
                          .black), // icône pour le bouton Liste des étudiants
                ),
                label: const Text(
                  'Listes des étudiants',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
//-------------------------------------
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.green, // Couleur de la bordure
                    width: 4.0, // Largeur de la bordure
                  ),
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StatisticsPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 200, 230, 201)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical: 40.0)),
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                ),
                icon: const Padding(
                  padding:
                      EdgeInsets.only(left: 8.0), // Ajout de padding à gauche
                  child: Icon(Icons.bar_chart,
                      color: Colors.black), // icône pour le bouton Statistiques
                ),
                label: const Text(
                  'Statistiques',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //-------------------------------------
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.green, // Couleur de la bordure
                        width: 4.0, // Largeur de la bordure
                      ),
                    ),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AccountPage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 200, 230, 201)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(vertical: 40.0)),
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(double.infinity, 50)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                    ),
                    icon: const Padding(
                      padding: EdgeInsets.only(
                          left: 8.0), // Ajout de padding à gauche
                      child: Icon(Icons.account_circle,
                          color:
                              Colors.black), // icône pour le bouton Mon compte
                    ),
                    label: const Text(
                      'Mon compte',
                      style: TextStyle(color: Colors.black),
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

//--------------------------

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String _scanResult = '';

  Future<void> _scanQRCode() async {
    String scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Annuler', true, ScanMode.QR);
    setState(() {
      _scanResult = scanResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _scanQRCode,
              child: const Text('Scanner un code QR'),
            ),
            const SizedBox(height: 20),
            Text(
              'Résultat du scan : $_scanResult',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

//--------------------------

class GestionnaireDonnees {
  List<Seance> listeSeances = [];
  List<Student> listeEtudiants = [];
  ValueNotifier<int> seancesNotifier = ValueNotifier<int>(0);
  static const String _kSeancesKey = 'seances'; // Déclaration de la constante

  List<Student> getStudentsByGroup(String groupName) {
    return listeEtudiants
        .where((student) => student.group == groupName)
        .toList();
  }

  GestionnaireDonnees() {
    // Initialisez la liste d'étudiants avec les données souhaitées
    listeEtudiants = students;
  }

  void ajouterSeance(
      DateTime date, String sujet, List<Student> etudiants, String salle,
      {required String groupe,
      required String matiere,
      required String typeSeance}) {
    // Vérifier si une séance similaire existe déjà dans la liste
    bool existingSession = listeSeances.any((seance) =>
        seance.date == date &&
        seance.groupe == groupe &&
        seance.salle == salle &&
        seance.matiere == matiere &&
        seance.typeSeance == typeSeance);

    if (!existingSession) {
      var nouvelleSeance = Seance(
        date: date,
        sujet: sujet,
        etudiants: etudiants,
        salle: salle,
        groupe: groupe,
        matiere: matiere,
        typeSeance: typeSeance,
      );
      listeSeances.add(nouvelleSeance);
      seancesNotifier.value++; // Notifier les écouteurs du changement
      print(
          'Séance ajoutée : $nouvelleSeance'); // Ajout du message de journalisation
      print('Nombre total de séances : ${listeSeances.length}');
    } else {
      print('La séance existe déjà dans la liste.');
    }
  }

  Future<void> chargerSeances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? seancesJsonList = prefs.getStringList(_kSeancesKey);
    if (seancesJsonList != null) {
      listeSeances = seancesJsonList
          .map(
              (seanceJson) => Seance.fromJson(jsonDecode(seanceJson)) as Seance)
          .toList();

      seancesNotifier.value = listeSeances.length;
    }
  }

  void afficherVecteursNotesGroupe2() {
    // Filtrer les étudiants du groupe 2
    List<Student> etudiantsGroupe2 =
        listeEtudiants.where((student) => student.group == 'Groupe 2').toList();

    // Afficher les vecteurs de notes des étudiants du groupe 2
    print('Vecteurs de notes des étudiants du Groupe 2 :');
    for (var etudiant in etudiantsGroupe2) {
      print('${etudiant.firstName} ${etudiant.lastName}: ${etudiant.grades}');
    }
  }
}

class SessionsPage extends StatefulWidget {
  final GestionnaireDonnees gestionnaire;

  const SessionsPage({Key? key, required this.gestionnaire}) : super(key: key);

  @override
  _SessionsPageState createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Séances'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          },
        ),
      ),
      body: FutureBuilder<List<Seance>>(
        future: _getStoredSeances(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            final seances = snapshot.data ?? [];
            if (seances.isEmpty) {
              return const Center(child: Text('Aucune séance'));
            } else {
              return ListView.builder(
                itemCount: seances.length,
                itemBuilder: (context, index) {
                  final seance = seances[index];
                  return ListTile(
                    title: Text(
                        'Séance le ${seance.date} - ${seance.sujet} -     ${seance.groupe}'),
                    subtitle: Text(
                        'Nombre d\'étudiants : ${seance.etudiants.length}, Salle : ${seance.salle}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _supprimerSeance(context, index);
                      },
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewSessionPage(
                gestionnaire: widget.gestionnaire,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Seance>> _getStoredSeances() async {
    await widget.gestionnaire.chargerSeances();
    return widget.gestionnaire.listeSeances;
  }

  void _supprimerSeance(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer cette séance ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Supprimer la séance de la liste
                widget.gestionnaire.listeSeances.removeAt(index);
                // Mettre à jour le nombre de séances
                widget.gestionnaire.seancesNotifier.value--;
                // Enregistrer les modifications
                _enregistrerSeances();
                // Rafraîchir la page
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Oui'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Non'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _enregistrerSeances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> seancesJson = widget.gestionnaire.listeSeances
        .map((seance) => jsonEncode(seance.toJson()))
        .toList();
    prefs.setStringList('seances', seancesJson);
  }
}

class NewSessionPage extends StatefulWidget {
  final GestionnaireDonnees gestionnaire;

  const NewSessionPage({Key? key, required this.gestionnaire})
      : super(key: key);

  @override
  _NewSessionPageState createState() => _NewSessionPageState();
}

class _NewSessionPageState extends State<NewSessionPage> {
  late TextEditingController _dateController;
  late TextEditingController _groupeController;
  late TextEditingController _salleController;
  late TextEditingController _matiereController;
  late String _typeSeance = 'TP';
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _groupeController = TextEditingController();
    _salleController = TextEditingController();
    _matiereController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _groupeController.dispose();
    _salleController.dispose();
    _matiereController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Séance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _groupeController,
              decoration: const InputDecoration(labelText: 'Groupe'),
            ),
            TextField(
              controller: _salleController,
              decoration: const InputDecoration(labelText: 'Salle'),
            ),
            TextField(
              controller: _matiereController,
              decoration: const InputDecoration(labelText: 'Matière'),
            ),
            Row(
              children: [
                const Text('Type de Séance: '),
                Radio(
                  value: 'TP',
                  groupValue: _typeSeance,
                  onChanged: (value) {
                    setState(() {
                      _typeSeance = value.toString();
                    });
                  },
                ),
                const Text('TP'),
                Radio(
                  value: 'TD',
                  groupValue: _typeSeance,
                  onChanged: (value) {
                    setState(() {
                      _typeSeance = value.toString();
                    });
                  },
                ),
                const Text('TD'),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _createSession(context);
              },
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }

  void _createSession(BuildContext context) {
    DateTime date = DateTime.parse(_dateController.text);
    String groupe = _groupeController.text;
    String salle = _salleController.text;
    String matiere = _matiereController.text;
    String typeSeance = _typeSeance;

    // Obtenez la liste d'étudiants du groupe
    students = widget.gestionnaire.getStudentsByGroup(groupe);

    // Créer une nouvelle séance avec les informations fournies
    widget.gestionnaire.ajouterSeance(
      date,
      '$matiere ($typeSeance)',
      students,
      salle,
      groupe: groupe,
      matiere: matiere,
      typeSeance: typeSeance,
    );
    widget.gestionnaire.afficherVecteursNotesGroupe2();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionDetailsPage(
          date: date,
          groupe: groupe,
          salle: salle,
          matiere: matiere,
          typeSeance: typeSeance,
          students: students,
          gestionnaire: widget.gestionnaire,
        ),
      ),
    );
  }
}

class SessionDetailsPage extends StatelessWidget {
  final DateTime date;
  final String groupe;
  final String salle;
  final String matiere;
  final String typeSeance;
  final List<Student> students;
  final GestionnaireDonnees gestionnaire;

  SessionDetailsPage({
    required this.date,
    required this.groupe,
    required this.salle,
    required this.matiere,
    required this.typeSeance,
    required this.students,
    required this.gestionnaire,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Séance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Séance le $date - $matiere ($typeSeance), Salle : $salle',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Liste des Étudiants du $groupe:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index) {
                Student student = students[index];
                return ListTile(
                  title: Text(student.firstName),
                  subtitle: Row(
                    children: [
                      const Text('Note: '),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            students[index].grades[0] = (int.tryParse(value))!;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateSeance(context);
              },
              child: const Text('Terminer'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSeance(BuildContext context) async {
    // Parcourir tous les étudiants et mettre à jour leurs notes dans la liste
    for (int i = 0; i < students.length; i++) {
      // Vérifier si l'utilisateur a saisi une note valide
      String? note = students[i].grades[0].toString();
      if (note.isEmpty || int.tryParse(note) == null) {
        // Si la note est vide ou n'est pas un nombre, la remplacer par 0
        students[i].grades[0] = 0;
      }
      // Ajouter la note à la liste des notes de l'étudiant
      students[i].grades.add(int.parse(note));
    }

    // Créer une nouvelle séance avec les informations fournies

    // Ajouter la nouvelle séance à la liste des séances dans le gestionnaire de données
    //gestionnaire.listeSeances.add(nouvelleSeance);

    // Enregistrer les séances mises à jour dans le stockage local
    await _enregistrerSeances();

    // Naviguer vers la page de liste des séances et retirer les autres pages de la pile
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => SessionsPage(gestionnaire: gestionnaire),
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _enregistrerSeances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> seancesJson = gestionnaire.listeSeances
        .map((seance) => jsonEncode(seance.toJson()))
        .toList();
    prefs.setStringList('seances', seancesJson);
  }
}

//-------------------------
class StudentsListPage extends StatelessWidget {
  const StudentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Comptage des présences et des absences
    int presenceCount = students.where((student) => student.isPresent).length;
    int absenceCount = students.length - presenceCount;

    // Mise à jour des compteurs dans MyAppState
    Provider.of<MyAppState>(context, listen: false)
        .updateAttendanceCounts(presenceCount, absenceCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listes des étudiants'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStudentList(
              context,
              section: 'Section A',
              group: 'Groupe 1',
              students: students
                  .where((student) => student.group == 'Groupe 1')
                  .toList(),
            ),
            _buildStudentList(
              context,
              section: 'Section A',
              group: 'Groupe 2',
              students: students
                  .where((student) => student.group == 'Groupe 2')
                  .toList(),
            ),
            _buildStudentList(
              context,
              section: 'Section A',
              group: 'Groupe 3',
              students: students
                  .where((student) => student.group == 'Groupe 3')
                  .toList(),
            ),
            _buildStudentList(
              context,
              section: 'Section A',
              group: 'Groupe 4',
              students: students
                  .where((student) => student.group == 'Groupe 4')
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList(BuildContext context,
      {required String section,
      required String group,
      required List<Student> students}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$section - $group',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          SingleChildScrollView(
            scrollDirection:
                Axis.horizontal, // Permet de faire défiler horizontalement
            child: DataTable(
              columns: const [
                DataColumn(label: SizedBox(width: 55, child: Text('Présent'))),
                DataColumn(label: SizedBox(width: 70, child: Text('Nom'))),
                DataColumn(label: SizedBox(width: 70, child: Text('Prénom'))),
                DataColumn(label: SizedBox(width: 80, child: Text('Matière'))),
                DataColumn(label: SizedBox(width: 80, child: Text('Section'))),
                DataColumn(label: SizedBox(width: 80, child: Text('Groupe'))),
                DataColumn(label: SizedBox(width: 50, child: Text('Note'))),
              ],
              rows: students.map((student) {
                return DataRow(cells: [
                  DataCell(
                    Checkbox(
                      value: student.isPresent,
                      onChanged: (bool? value) {
                        // Mettre à jour l'état de présence de l'étudiant
                        // Vous pouvez ajouter ici la logique pour mettre à jour l'état de présence de l'étudiant
                      },
                    ),
                  ),
                  DataCell(Text(student.firstName)),
                  DataCell(Text(student.lastName)),
                  DataCell(Text(student.subject)),
                  DataCell(Text(student.section)),
                  DataCell(Text(student.group)),
                  DataCell(Text(student.grades.isNotEmpty
                      ? ((student.grades.reduce((a, b) => a + b)) /
                              student.grades.length)
                          .toStringAsFixed(
                              1) // Formatage avec deux décimales après la virgule
                      : 'N/A')),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

//----------------------

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myAppState = Provider.of<MyAppState>(context);
    final totalStudents = myAppState.presenceCount + myAppState.absenceCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Statistiques des présences',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: PieChartPainter(
                  presencePercentage:
                      (myAppState.presenceCount / totalStudents) * 100,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Présences', Colors.green),
                const SizedBox(width: 20),
                _buildLegendItem('Absences', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double presencePercentage;

  PieChartPainter({required this.presencePercentage});

  @override
  void paint(Canvas canvas, Size size) {
    final double presenceAngle = (presencePercentage / 100) * 2 * pi;

    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2),
      -pi / 2, // Start angle
      presenceAngle,
      true,
      paint,
    );

    final paint2 = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2),
      presenceAngle - pi / 2, // Start angle
      2 * pi - presenceAngle,
      true,
      paint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//--------------------

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<MyAppState>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon compte'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/logos/user.jpeg'),
            ),
            const SizedBox(height: 20),
            _buildUserInfoRow('Nom:', currentUser?.lastName ?? ''),
            _buildUserInfoRow('Prénom:', currentUser?.name ?? ''),
            _buildUserInfoRow(
                'Niveau scolaire:', currentUser?.schoolLevel ?? ''),
            //   _buildUserInfoRow('Specialite:', currentUser?.id ?? ''),
            _buildUserInfoRow('Section:', currentUser?.section ?? ''),
            _buildUserInfoRow('Groupe:', currentUser?.group ?? ''),
            _buildUserInfoRow('Année scolaire:', currentUser?.schoolYear ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

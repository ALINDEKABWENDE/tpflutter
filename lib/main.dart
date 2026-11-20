import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

// ====== A PERSONNALISER ======
const kNom = 'Jean Alinde';
const kTitre = 'Étudiant en Informatique • Développeur Mobile';
const kPhoto = 'assets/images/moi.jpg';
const kLogin = 'admin';
const kPassword = '1234';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mon CV',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF7657FF),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8F7FF),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: const Color(0xFFE2DEF3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF7657FF), width: 1.8),
        ),
      ),
    ),
    home: const LoginPage(),
  );
}

/// Avatar : affiche la photo, ou une icône si l'image est absente.
class Avatar extends StatelessWidget {
  final String path;
  final double radius;
  const Avatar(this.path, {super.key, this.radius = 30});
  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: radius,
    backgroundColor: Colors.indigo.shade100,
    child: ClipOval(
      child: Image.asset(
        path,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.person, size: radius, color: Colors.indigo),
      ),
    ),
  );
}

// ================= PAGE 1 : CONNEXION =================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _pwd = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _id.dispose();
    _pwd.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    if (_id.text.trim() == kLogin && _pwd.text == kPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeShell()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Identifiant ou mot de passe incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFBF9FF),
    body: LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 980;

        Widget formPanel() => Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEAF2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Color(0xFFEC3D85),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF9FB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'ESPACE PERSONNEL',
                      style: TextStyle(
                        color: Color(0xFF087F92),
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              const Text(
                'Connexion',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 38,
                  height: 1,
                  letterSpacing: -1.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Connectez-vous pour consulter le portfolio.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _id,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Identifiant',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pwd,
                obscureText: _hide,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _login(),
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    tooltip: _hide
                        ? 'Afficher le mot de passe'
                        : 'Masquer le mot de passe',
                    icon: Icon(
                      _hide
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _hide = !_hide),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 54,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF7657FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _login,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Se connecter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        if (!wide) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 520),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7657FF),
                          Color(0xFFE84A89),
                          Color(0xFFFF9A62),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: Color(0xFFFFE6F0),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Portfolio',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Profil, parcours et compétences',
                          style: TextStyle(color: Color(0xFFCBD5E1)),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 520),
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x140F172A),
                            blurRadius: 30,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: formPanel(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Row(
          children: [
            Expanded(
              flex: 48,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF7657FF),
                      Color(0xFF9A4DFF),
                      Color(0xFFE84A89),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(64, 56, 64, 56),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 40,
                      color: Color(0xFFA5B4FC),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Portfolio',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 52,
                            height: 1,
                            letterSpacing: -2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          'Découvrez mon parcours,\nmes projets et mes compétences.',
                          style: TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 19,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'CV NUMÉRIQUE',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        letterSpacing: 2,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 52,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 520,
                    maxHeight: 610,
                  ),
                  margin: const EdgeInsets.all(48),
                  padding: const EdgeInsets.fromLTRB(54, 48, 54, 48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x140F172A),
                        blurRadius: 40,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: formPanel(),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

// ================= NAVIGATION =================
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _i = 0;
  static const _titles = ['Accueil', 'Famille', 'Contact'];
  final _pages = const [AccueilPage(), FamillePage(), ContactPage()];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      title: Text(
        _titles[_i],
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      actions: [
        IconButton(
          tooltip: 'Déconnexion',
          icon: const Icon(Icons.logout_rounded),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          ),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: IndexedStack(index: _i, children: _pages),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _i,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 3,
      indicatorColor: const Color(0xFFFFE5F0),
      height: 72,
      onDestinationSelected: (v) => setState(() => _i = v),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.family_restroom_outlined),
          selectedIcon: Icon(Icons.family_restroom_rounded),
          label: 'Famille',
        ),
        NavigationDestination(
          icon: Icon(Icons.alternate_email_rounded),
          selectedIcon: Icon(Icons.contact_mail_rounded),
          label: 'Contact',
        ),
      ],
    ),
  );
}

// ================= PAGE 2 : ACCUEIL (CV) =================
class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  Widget _section(
    BuildContext c,
    String titre,
    IconData icon,
    List<Widget> items,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFEEEAF8)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDF4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFFEC3D85)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  titre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(c).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE7ECF5)),
          const SizedBox(height: 10),
          ...items,
        ],
      ),
    ),
  );

  Widget _item(String titre, String sous) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titre,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF26354D),
          ),
        ),
        const SizedBox(height: 3),
        Text(sous, style: TextStyle(color: Colors.grey.shade600)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 800;
      final hero = Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7657FF), Color(0xFFEC3D85), Color(0xFFFF9A62)],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Avatar(kPhoto, radius: 48),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kNom,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    kTitre,
                    style: const TextStyle(
                      color: Color(0xFFE1E8F7),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      final sections = [
        _section(context, 'Formation', Icons.school_rounded, [
          _item('Etudian en Informatique', 'ISIG GOMA Depuis 2023'),
          _item('Baccalauréat ', '2023'),
        ]),
        _section(context, 'Expériences', Icons.work_outline_rounded, [
          _item(
            'Stage – Telecommunication',
            'Entreprise hayatcom • juin 2026',
          ),
          _item('Projet – Application de gestion', 'Flutter & Firebase • 2025'),
          _item('Job étudiant – Assistant informatique', 'Cybercafé Y • 2024'),
        ]),
        _section(context, 'Compétences techniques', Icons.code_rounded, [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in [
                'Flutter',
                'Dart',
                'Java',
                'Python',
                'SQL',
                'Git/GitHub',
              ])
                Chip(
                  side: BorderSide.none,
                  backgroundColor:
                      const [
                        Color(0xFFFFEAF2),
                        Color(0xFFE8F8FB),
                        Color(0xFFFFF1DC),
                      ][[
                            'Flutter',
                            'Dart',
                            'Java',
                            'Python',
                            'SQL',
                            'Git/GitHub',
                          ].indexOf(s) %
                          3],
                  labelStyle: const TextStyle(
                    color: Color(0xFF4C3BA7),
                    fontWeight: FontWeight.w700,
                  ),
                  label: Text(s),
                ),
            ],
          ),
        ]),
        _section(context, 'Langues', Icons.language_rounded, [
          _item('Français', 'Langue maternelle'),
          _item('Anglais', 'Intermédiaire (B1)'),
        ]),
        _section(context, "Centres d'intérêt", Icons.favorite_outline_rounded, [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in ['Football', 'Musique', 'Lecture', 'Technologie'])
                Chip(
                  side: BorderSide.none,
                  backgroundColor: const Color(0xFFF1F5F9),
                  label: Text(s),
                ),
            ],
          ),
        ]),
      ];

      return ListView(
        padding: EdgeInsets.fromLTRB(wide ? 32 : 16, 16, wide ? 32 : 16, 28),
        children: [
          if (wide)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: hero,
            )
          else
            hero,
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(children: sections.take(3).toList())),
                const SizedBox(width: 16),
                Expanded(child: Column(children: sections.skip(3).toList())),
              ],
            )
          else
            ...sections,
        ],
      );
    },
  );
}

// ================= PAGE 3 : FAMILLE =================
class Membre {
  final String nom, lien, profession, photo;
  const Membre(this.nom, this.lien, this.profession, this.photo);
}

class FamillePage extends StatelessWidget {
  const FamillePage({super.key});

  static const membres = [
    Membre('DIEUDONNE', 'Père', 'Ingénieur', 'assets/images/pere.jpg'),
    Membre('VIVIANNE', 'Mère', 'Enseignante', 'assets/images/mere.jpg'),
    Membre('JEROME', 'Frère', 'Étudiant', 'assets/images/frere.jpg'),
    Membre('INES', 'Sœur', 'Élève', 'assets/images/soeur.jpg'),
  ];

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final crossAxisCount = constraints.maxWidth >= 900
          ? 3
          : constraints.maxWidth >= 520
          ? 2
          : 1;
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 118,
        ),
        itemCount: membres.length,
        itemBuilder: (_, i) {
          final m = membres[i];
          const colors = [
            Color(0xFFFFE5EE),
            Color(0xFFE5F7F8),
            Color(0xFFFFEDD8),
            Color(0xFFECE7FF),
          ];
          final accent = colors[i % colors.length];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: accent),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.45),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const [
                        Color(0xFFEC3D85),
                        Color(0xFF15A4B7),
                        Color(0xFFFF9A62),
                        Color(0xFF7657FF),
                      ][i % 4],
                      width: 2,
                    ),
                  ),
                  child: Avatar(m.photo, radius: 31),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.nom,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          m.lien,
                          style: TextStyle(
                            color: [
                              Color(0xFFB91C55),
                              Color(0xFF087F92),
                              Color(0xFFC26724),
                              Color(0xFF5B47C7),
                            ][i % 4],
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        m.profession,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// ================= PAGE 4 : CONTACT =================
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _open(BuildContext c, String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && c.mounted) {
      ScaffoldMessenger.of(c).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir le lien")),
      );
    }
  }

  Widget _tile(
    BuildContext c,
    IconData icon,
    String titre,
    String valeur,
    String url,
    Color accent,
    Color softColor,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: softColor),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: softColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: accent),
      ),
      title: Text(titre, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(valeur, style: TextStyle(color: Colors.grey.shade600)),
      trailing: Icon(Icons.arrow_outward_rounded, size: 20, color: accent),
      onTap: () => _open(c, url),
    ),
  );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final content = [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7657FF), Color(0xFFEC3D85), Color(0xFFFF9A62)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.mark_unread_chat_alt_outlined,
                color: Colors.white,
                size: 34,
              ),
              SizedBox(height: 12),
              Text(
                'Restons en contact',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Une opportunité, un projet ou simplement envie d’échanger ?',
                style: TextStyle(color: Color(0xFFE1E8F7)),
              ),
            ],
          ),
        ),
        _tile(
          context,
          Icons.phone_rounded,
          'Téléphone',
          '+243 971 185 261',
          'tel:+243971185261',
          const Color(0xFF7657FF),
          const Color(0xFFECE7FF),
        ),
        _tile(
          context,
          Icons.email_outlined,
          'E-mail',
          'jeanalindekabwende@gemail.com',
          'mailto:jeanalindekabwende@gemail.com',
          const Color(0xFFEC3D85),
          const Color(0xFFFFE5EE),
        ),
        _tile(
          context,
          Icons.location_on_outlined,
          'Adresse',
          'Goma, RDC',
          'https://www.google.com/maps/search/?api=1&query=Goma',
          const Color(0xFF15A4B7),
          const Color(0xFFE5F7F8),
        ),
        _tile(
          context,
          Icons.business_center_outlined,
          'LinkedIn',
          'linkedin.com/in/votreprenom',
          'https://www.linkedin.com/in/votreprenom',
          const Color(0xFF3975D9),
          const Color(0xFFE5EEFF),
        ),
        _tile(
          context,
          Icons.code_rounded,
          'GitHub',
          'github.com/ALINDEKABWENDE',
          'https://github.com/ALINDEKABWENDE',
          const Color(0xFF4C3BA7),
          const Color(0xFFECE7FF),
        ),
      ];

      return ListView(
        padding: EdgeInsets.fromLTRB(
          constraints.maxWidth >= 800 ? 32 : 16,
          16,
          constraints.maxWidth >= 800 ? 32 : 16,
          28,
        ),
        children: content,
      );
    },
  );
}


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BooklyApp());
}

// ==========================================
// IDENTIDADE VISUAL
// ==========================================

const Color coffee = Color(0xFF49372F);
const Color terracotta = Color(0xFFA66D52);
const Color beige = Color(0xFFD8BFA0);
const Color cream = Color(0xFFF3EBDD);
const Color sage = Color(0xFF78816A);
const Color muted = Color(0xFF8B786B);
const Color whiteCream = Color(0xFFFFFBF5);

// ==========================================
// APLICATIVO
// ==========================================

class BooklyApp extends StatelessWidget {
  const BooklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: terracotta,
          primary: coffee,
          secondary: terracotta,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}

// ==========================================
// LOGO
// ==========================================

class BooklyLogo extends StatelessWidget {
  final double size;
  final bool showName;

  const BooklyLogo({
    super.key,
    this.size = 110,
    this.showName = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.auto_stories_rounded,
                size: size * 0.85,
                color: coffee,
              ),
              Positioned(
                top: size * 0.02,
                child: Icon(
                  Icons.spa_rounded,
                  color: sage,
                  size: size * 0.34,
                ),
              ),
              Positioned(
                top: size * 0.05,
                right: size * 0.12,
                child: Icon(
                  Icons.auto_awesome,
                  color: terracotta,
                  size: size * 0.17,
                ),
              ),
            ],
          ),
        ),
        if (showName) ...[
          Text(
            'Bookly',
            style: GoogleFonts.playfairDisplay(
              fontSize: size * 0.43,
              fontWeight: FontWeight.bold,
              color: coffee,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'MAIS QUE LIVROS, NOVAS PERSPECTIVAS.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: size * 0.075,
              letterSpacing: 1.5,
              color: muted,
            ),
          ),
        ],
      ],
    );
  }
}

// ==========================================
// SPLASH SCREEN - INICIALIZAÇÃO CORRIGIDA
// ==========================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    // Aguarda a primeira renderização antes de iniciar a animação.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      iniciarSplash();
    });
  }

  Future<void> iniciarSplash() async {
    if (!mounted) return;

    // Animação de entrada da logo.
    await controller.forward();

    // Mantém a logo visível por mais 2 segundos.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Só depois da exibição da logo abre a página inicial.
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, routeAnimation, __, child) {
          return FadeTransition(
            opacity: routeAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: FadeTransition(
        opacity: animation,
        child: Stack(
          children: [
            Positioned(
              top: -75,
              left: -70,
              child: circle(220, terracotta.withOpacity(0.20)),
            ),
            Positioned(
              bottom: -85,
              right: -65,
              child: circle(250, sage.withOpacity(0.22)),
            ),
            const Positioned(
              top: 130,
              right: 45,
              child: Icon(
                Icons.auto_awesome,
                size: 28,
                color: terracotta,
              ),
            ),
            const Center(
              child: BooklyLogo(size: 190),
            ),
            Positioned(
              bottom: 65,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [terracotta, sage],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'UM UNIVERSO DE HISTÓRIAS ESPERA POR VOCÊ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: muted,
                      fontSize: 9,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ==========================================
// TELA PRINCIPAL
// ==========================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  String search = '';
  String selectedCategory = 'Todos';
  String searchCategory = 'Todos';
  String libraryFilter = 'Salvos';
  String profileName = 'Leitora';

  final Set<String> savedBooks = {};
  final Set<String> readingBooks = {};
  final Set<String> readBooks = {};

  final List<String> categories = [
    'Todos',
    'Ficção',
    'Romance',
    'Fantasia',
    'Suspense',
    'Clássico',
    'Drama',
    'Aventura',
  ];

  final List<Map<String, dynamic>> books = [
    {
      'title': 'A biblioteca da meia-noite',
      'author': 'Matt Haig',
      'rating': '4,8',
      'category': 'Ficção',
      'color': const Color(0xFF795744),
      'icon': Icons.nightlight_round,
      'review': 'Uma leitura que faz a gente refletir sobre escolhas e recomeços.',
      'description': 'Entre a vida e a morte existe uma biblioteca. Em suas prateleiras, Nora encontra diferentes versões de sua vida e descobre como pequenas escolhas podem transformar tudo.',
    },
    {
      'title': 'O jardim secreto',
      'author': 'Frances Hodgson Burnett',
      'rating': '4,7',
      'category': 'Fantasia',
      'color': const Color(0xFF78816A),
      'icon': Icons.local_florist,
      'review': 'Uma história delicada, cheia de descobertas e afeto.',
      'description': 'Mary Lennox descobre um jardim escondido e, ao cuidar dele, começa também a transformar sua própria vida e a das pessoas ao seu redor.',
    },
    {
      'title': 'Orgulho e preconceito',
      'author': 'Jane Austen',
      'rating': '4,9',
      'category': 'Romance',
      'color': const Color(0xFFA66D52),
      'icon': Icons.favorite_border,
      'review': 'Um clássico encantador sobre amor, escolhas e sociedade.',
      'description': 'Elizabeth Bennet e Mr. Darcy precisam superar julgamentos e diferenças sociais para compreender seus sentimentos.',
    },
    {
      'title': 'A hipótese do amor',
      'author': 'Ali Hazelwood',
      'rating': '4,6',
      'category': 'Romance',
      'color': const Color(0xFFB77F78),
      'icon': Icons.favorite,
      'review': 'Uma comédia romântica divertida e envolvente.',
      'description': 'Uma estudante de doutorado acaba envolvida em um relacionamento de mentira com um professor bastante reservado.',
    },
    {
      'title': 'Harry Potter e a pedra filosofal',
      'author': 'J.K. Rowling',
      'rating': '4,9',
      'category': 'Fantasia',
      'color': const Color(0xFF6C644A),
      'icon': Icons.auto_awesome,
      'review': 'Uma aventura mágica que desperta a imaginação.',
      'description': 'Harry descobre que é um bruxo e começa uma jornada extraordinária na Escola de Magia e Bruxaria de Hogwarts.',
    },
    {
      'title': 'O pequeno príncipe',
      'author': 'Antoine de Saint-Exupéry',
      'rating': '4,9',
      'category': 'Clássico',
      'color': const Color(0xFF8394A0),
      'icon': Icons.star,
      'review': 'Uma história simples que traz reflexões profundas.',
      'description': 'Um pequeno príncipe viaja por diferentes planetas e encontra personagens que o fazem refletir sobre amizade, amor e humanidade.',
    },
    {
      'title': 'A paciente silenciosa',
      'author': 'Alex Michaelides',
      'rating': '4,7',
      'category': 'Suspense',
      'color': const Color(0xFF56565B),
      'icon': Icons.visibility,
      'review': 'Um suspense cheio de mistérios e reviravoltas.',
      'description': 'Uma pintora é acusada de assassinar o marido e, desde então, permanece em silêncio. Um psicoterapeuta tenta descobrir o que aconteceu.',
    },
    {
      'title': 'É assim que acaba',
      'author': 'Colleen Hoover',
      'rating': '4,6',
      'category': 'Drama',
      'color': const Color(0xFF956B72),
      'icon': Icons.local_florist,
      'review': 'Uma narrativa emocionante sobre escolhas e recomeços.',
      'description': 'Lily enfrenta decisões difíceis ao revisitar seu passado e construir um futuro diferente.',
    },
    {
      'title': 'Percy Jackson e o ladrão de raios',
      'author': 'Rick Riordan',
      'rating': '4,8',
      'category': 'Aventura',
      'color': const Color(0xFF567C91),
      'icon': Icons.bolt,
      'review': 'Mitologia e aventura em uma leitura eletrizante.',
      'description': 'Percy descobre que é filho de um deus grego e precisa embarcar em uma missão para evitar uma guerra entre os deuses.',
    },
    {
      'title': 'Dom Casmurro',
      'author': 'Machado de Assis',
      'rating': '4,5',
      'category': 'Clássico',
      'color': const Color(0xFF785C49),
      'icon': Icons.menu_book,
      'review': 'Um clássico brasileiro que provoca diferentes interpretações.',
      'description': 'Bentinho relembra sua história com Capitu, levantando dúvidas sobre memória, ciúme e confiança.',
    },
    {
      'title': 'Extraordinário',
      'author': 'R. J. Palacio',
      'rating': '4,8',
      'category': 'Drama',
      'color': const Color(0xFF7E987D),
      'icon': Icons.emoji_emotions_outlined,
      'review': 'Uma história sensível sobre empatia e respeito.',
      'description': 'August Pullman começa a frequentar uma escola regular e precisa enfrentar os desafios de ser diferente.',
    },
    {
      'title': 'O Hobbit',
      'author': 'J. R. R. Tolkien',
      'rating': '4,8',
      'category': 'Fantasia',
      'color': const Color(0xFF7A7653),
      'icon': Icons.landscape,
      'review': 'Uma aventura fantástica repleta de descobertas.',
      'description': 'Bilbo Bolseiro deixa sua vida tranquila para acompanhar um grupo de anões em uma jornada inesperada.',
    },
  ];

  // ========================================
  // CONSTRUÇÃO DA TELA
  // ========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedTab,
          children: [
            homeContent(),
            searchScreen(),
            libraryScreen(),
            profileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        backgroundColor: whiteCream,
        indicatorColor: beige.withOpacity(0.55),
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            selectedTab = index;
            search = '';
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.manage_search),
            label: 'Pesquisa',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Biblioteca',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  // ========================================
  // CABEÇALHO
  // ========================================

  Widget header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 15, 22, 10),
      child: Row(
        children: [
          Text(
            'Bookly',
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: coffee,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => message('Você está em dia com as novidades!'),
            icon: const Icon(
              Icons.notifications_none,
              color: coffee,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = 3;
              });
            },
            child: CircleAvatar(
              radius: 19,
              backgroundColor: beige,
              child: const Icon(Icons.person, color: coffee),
            ),
          ),
        ],
      ),
    );
  }

  // ========================================
  // INÍCIO
  // ========================================

  Widget homeContent() {
    final filteredBooks = books.where((book) {
      final matchesSearch =
          book['title'].toString().toLowerCase().contains(search.toLowerCase()) ||
          book['author'].toString().toLowerCase().contains(search.toLowerCase());

      final matchesCategory = selectedCategory == 'Todos' ||
          book['category'] == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: header()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.spa_outlined, size: 32, color: sage),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, $profileName!',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: coffee,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Que bom ter você por aqui. Vamos encontrar sua próxima leitura?',
                        style: TextStyle(
                          fontSize: 14,
                          color: muted,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: TextField(
              readOnly: true,
              onTap: () {
                setState(() {
                  selectedTab = 1;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por gênero...',
                hintStyle: const TextStyle(color: muted, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: coffee),
                filled: true,
                fillColor: whiteCream,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 12),
            child: sectionTitle('Destaque da semana'),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: featuredBook(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 12),
            child: sectionTitle('Explore por categoria'),
          ),
        ),
        SliverToBoxAdapter(child: categoryList()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 12),
            child: sectionTitle('Livros da comunidade'),
          ),
        ),
        if (filteredBooks.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Text(
                'Nenhum livro encontrado.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 25),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 13),
                    child: reviewCard(filteredBooks[index]),
                  );
                },
                childCount: filteredBooks.length,
              ),
            ),
          ),
      ],
    );
  }

  // ========================================
  // TÍTULOS DAS SEÇÕES
  // ========================================

  Widget sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: coffee,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              selectedTab = 1;
              search = '';
              searchCategory = 'Todos';
            });
          },
          child: const Text(
            'Ver todos',
            style: TextStyle(color: terracotta, fontSize: 12),
          ),
        ),
      ],
    );
  }

  // ========================================
  // DESTAQUE
  // ========================================

  Widget featuredBook() {
    final book = books[0];

    return GestureDetector(
      onTap: () => showBookDetails(book),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF795744), Color(0xFF9A755B)],
          ),
          boxShadow: [
            BoxShadow(
              color: coffee.withOpacity(0.13),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            bookCover(
              'A BIBLIOTECA\nDA MEIA-NOITE',
              book['color'],
              book['icon'],
              width: 85,
              height: 125,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ESCOLHA DA COMUNIDADE',
                    style: TextStyle(
                      color: Color(0xFFF0DCC2),
                      fontSize: 9,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    book['title'],
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book['author'],
                    style: const TextStyle(
                      color: Color(0xFFF1E3D3),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFFF1C27D), size: 17),
                      SizedBox(width: 4),
                      Text(
                        '4,8  •  Destaque da semana',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Conhecer livro  →',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================
  // CAPAS ILUSTRATIVAS
  // ========================================

  Widget bookCover(
    String title,
    Color color,
    IconData icon, {
    double width = 65,
    double height = 90,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFEAD8C6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: coffee.withOpacity(0.12),
            blurRadius: 5,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icon, color: beige, size: width * 0.35),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.playfairDisplay(
              fontSize: width * 0.105,
              fontWeight: FontWeight.bold,
              color: cream,
            ),
          ),
        ],
      ),
    );
  }

  // ========================================
  // CATEGORIAS DA HOME
  // ========================================

  Widget categoryList() {
    final icons = [
      Icons.auto_stories_outlined,
      Icons.menu_book_outlined,
      Icons.favorite_border,
      Icons.park_outlined,
      Icons.nights_stay_outlined,
      Icons.history_edu,
      Icons.theater_comedy_outlined,
      Icons.explore_outlined,
    ];

    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final selected = selectedCategory == categories[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = categories[index];
              });
            },
            child: Container(
              width: 75,
              margin: const EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: selected ? beige : const Color(0xFFEAD8C6),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Icon(
                      icons[index],
                      size: 27,
                      color: index == 3 ? sage : terracotta,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    categories[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? coffee : muted,
                      fontSize: 10,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ========================================
  // AVALIAÇÕES NA HOME
  // ========================================

  Widget reviewCard(Map<String, dynamic> book) {
    return GestureDetector(
      onTap: () => showBookDetails(book),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: whiteCream,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: beige.withOpacity(0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bookCover(
              book['title'].toString().toUpperCase(),
              book['color'],
              book['icon'],
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'],
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: coffee,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book['author'],
                    style: const TextStyle(color: muted, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: terracotta, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        book['rating'],
                        style: const TextStyle(
                          color: coffee,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 7),
                      const Text(
                        '• Comunidade',
                        style: TextStyle(color: muted, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '“${book['review']}”',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF6D5B50),
                      fontSize: 11,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => toggleSaved(book),
              icon: Icon(
                savedBooks.contains(book['title'])
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: terracotta,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================
  // PESQUISA - FILTROS DE GÊNEROS
  // ========================================

  Widget searchScreen() {
    final icons = [
      Icons.auto_stories_outlined,
      Icons.menu_book_outlined,
      Icons.favorite_border,
      Icons.park_outlined,
      Icons.nights_stay_outlined,
      Icons.history_edu,
      Icons.theater_comedy_outlined,
      Icons.explore_outlined,
    ];

    final descriptions = {
      'Todos': 'Explore todos os gêneros literários.',
      'Ficção': 'Histórias imaginativas e narrativas envolventes.',
      'Romance': 'Histórias de amor, relacionamentos e sentimentos.',
      'Fantasia': 'Mundos mágicos, criaturas e aventuras extraordinárias.',
      'Suspense': 'Mistérios, investigação e reviravoltas.',
      'Clássico': 'Obras marcantes da literatura.',
      'Drama': 'Narrativas emocionantes e reflexivas.',
      'Aventura': 'Jornadas, descobertas e grandes desafios.',
    };

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 30, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pesquisa',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: coffee,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Encontre seu próximo gênero favorito.',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                const SizedBox(height: 30),
                Text(
                  'Explore por gênero',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: coffee,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Escolha uma categoria para personalizar sua experiência.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = categories[index];
                final selected = searchCategory == category;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      searchCategory = category;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected
                          ? beige.withOpacity(0.65)
                          : whiteCream,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                        color: selected ? terracotta : beige.withOpacity(0.6),
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: selected
                                ? terracotta.withOpacity(0.15)
                                : cream,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            icons[index],
                            size: 27,
                            color: selected ? coffee : terracotta,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: coffee,
                          ),
                        ),
                        if (selected) ...[
                          const SizedBox(height: 5),
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: sage,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
              childCount: categories.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 13,
              crossAxisSpacing: 13,
              childAspectRatio: 1.15,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 30),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(19),
              decoration: BoxDecoration(
                color: whiteCream,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: beige.withOpacity(0.6)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: terracotta,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          searchCategory == 'Todos'
                              ? 'Todos os gêneros'
                              : searchCategory,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: coffee,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          descriptions[searchCategory]!,
                          style: const TextStyle(
                            color: muted,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ========================================
  // BIBLIOTECA
  // ========================================

  Widget libraryScreen() {
    List<Map<String, dynamic>> libraryBooks;

    if (libraryFilter == 'Salvos') {
      libraryBooks = books.where((book) {
        return savedBooks.contains(book['title']);
      }).toList();
    } else if (libraryFilter == 'Lendo') {
      libraryBooks = books.where((book) {
        return readingBooks.contains(book['title']);
      }).toList();
    } else {
      libraryBooks = books.where((book) {
        return readBooks.contains(book['title']);
      }).toList();
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minha biblioteca',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: coffee,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Um espaço para organizar suas histórias.',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    libraryStat(
                      Icons.bookmark,
                      savedBooks.length.toString(),
                      'Salvos',
                    ),
                    const SizedBox(width: 10),
                    libraryStat(
                      Icons.menu_book,
                      readingBooks.length.toString(),
                      'Lendo',
                    ),
                    const SizedBox(width: 10),
                    libraryStat(
                      Icons.check_circle_outline,
                      readBooks.length.toString(),
                      'Lidos',
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Text(
                  'Suas coleções',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: coffee,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Salvos', 'Lendo', 'Concluídos'].map((filter) {
                      final selected = libraryFilter == filter;

                      return Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: selected,
                          selectedColor: beige,
                          backgroundColor: whiteCream,
                          labelStyle: TextStyle(
                            color: selected ? coffee : muted,
                            fontSize: 12,
                          ),
                          onSelected: (_) {
                            setState(() => libraryFilter = filter);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '${libraryBooks.length} livro(s) nesta coleção',
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        if (libraryBooks.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      libraryFilter == 'Salvos'
                          ? Icons.bookmark_border
                          : libraryFilter == 'Lendo'
                              ? Icons.menu_book_outlined
                              : Icons.auto_stories_outlined,
                      size: 65,
                      color: beige,
                    ),
                    const SizedBox(height: 17),
                    Text(
                      libraryFilter == 'Salvos'
                          ? 'Sua coleção está esperando por você!'
                          : libraryFilter == 'Lendo'
                              ? 'Nenhuma leitura em andamento.'
                              : 'Você ainda não concluiu livros.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: coffee,
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      'Explore os livros e adicione suas próximas leituras.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: muted,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => selectedTab = 1);
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Descobrir livros'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: coffee,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 30),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 13),
                    child: catalogBookCard(
                      libraryBooks[index],
                      showStatus: true,
                    ),
                  );
                },
                childCount: libraryBooks.length,
              ),
            ),
          ),
      ],
    );
  }

  // ========================================
  // ESTATÍSTICAS
  // ========================================

  Widget libraryStat(IconData icon, String number, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: whiteCream,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: beige.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: terracotta, size: 22),
            const SizedBox(height: 7),
            Text(
              number,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: coffee,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: muted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================
  // CARD DO CATÁLOGO
  // ========================================

  Widget catalogBookCard(
    Map<String, dynamic> book, {
    bool showStatus = false,
  }) {
    final title = book['title'].toString();
    final isSaved = savedBooks.contains(title);
    final isReading = readingBooks.contains(title);
    final isRead = readBooks.contains(title);

    return GestureDetector(
      onTap: () => showBookDetails(book),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: whiteCream,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: beige.withOpacity(0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bookCover(
              title.toUpperCase(),
              book['color'],
              book['icon'],
              width: 70,
              height: 100,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: coffee,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book['author'],
                    style: const TextStyle(color: muted, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: terracotta, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        book['rating'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: coffee,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        book['category'],
                        style: const TextStyle(
                          fontSize: 10,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                  if (showStatus) ...[
                    const SizedBox(height: 7),
                    Text(
                      isRead
                          ? 'Leitura concluída'
                          : isReading
                              ? 'Em andamento'
                              : 'Na sua lista de desejos',
                      style: const TextStyle(
                        fontSize: 10,
                        color: sage,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 7,
                    children: [
                      if (!isRead && !isReading)
                        actionText(
                          'Começar leitura',
                          () => updateReading(book),
                        ),
                      if (isReading)
                        actionText(
                          'Concluir leitura',
                          () => updateFinished(book),
                        ),
                      if (isRead)
                        actionText(
                          'Ler novamente',
                          () => updateReading(book),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: isSaved ? 'Remover dos salvos' : 'Salvar livro',
              onPressed: () => toggleSaved(book),
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: terracotta,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionText(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: terracotta,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ========================================
  // AÇÕES DA BIBLIOTECA
  // ========================================

  void toggleSaved(Map<String, dynamic> book) {
    final title = book['title'].toString();
    final wasSaved = savedBooks.contains(title);

    setState(() {
      if (wasSaved) {
        savedBooks.remove(title);
      } else {
        savedBooks.add(title);
      }
    });

    message(
      wasSaved
          ? 'Livro removido dos salvos.'
          : 'Livro adicionado à biblioteca!',
    );
  }

  void updateReading(Map<String, dynamic> book) {
    final title = book['title'].toString();

    setState(() {
      readBooks.remove(title);
      readingBooks.add(title);
      savedBooks.add(title);
    });

    message('Leitura iniciada: $title');
  }

  void updateFinished(Map<String, dynamic> book) {
    final title = book['title'].toString();

    setState(() {
      readingBooks.remove(title);
      readBooks.add(title);
      savedBooks.add(title);
    });

    message('Parabéns! Você concluiu "$title".');
  }

  // ========================================
  // DETALHES DO LIVRO
  // ========================================

  void showBookDetails(Map<String, dynamic> book) {
    final title = book['title'].toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            final saved = savedBooks.contains(title);
            final reading = readingBooks.contains(title);
            final finished = readBooks.contains(title);

            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 25, 24, 35),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: beige,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: bookCover(
                        title.toUpperCase(),
                        book['color'],
                        book['icon'],
                        width: 115,
                        height: 165,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: coffee,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      book['author'],
                      style: const TextStyle(
                        color: muted,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: terracotta,
                          size: 19,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${book['rating']} • ${book['category']}',
                          style: const TextStyle(
                            color: coffee,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Sinopse',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: coffee,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book['description'],
                      style: const TextStyle(
                        color: muted,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'O que deseja fazer?',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: coffee,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            if (saved) {
                              savedBooks.remove(title);
                            } else {
                              savedBooks.add(title);
                            }
                          });
                          modalSetState(() {});
                        },
                        icon: Icon(
                          saved
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                        ),
                        label: Text(
                          saved ? 'Remover dos salvos' : 'Salvar na biblioteca',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: terracotta,
                          side: const BorderSide(color: terracotta),
                          padding: const EdgeInsets.all(13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    if (!reading && !finished)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            updateReading(book);
                            modalSetState(() {});
                          },
                          icon: const Icon(Icons.menu_book),
                          label: const Text('Começar leitura'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: coffee,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(13),
                          ),
                        ),
                      ),
                    if (reading)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            updateFinished(book);
                            modalSetState(() {});
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Marcar como concluído'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: sage,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(13),
                          ),
                        ),
                      ),
                    if (finished)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            updateReading(book);
                            modalSetState(() {});
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Ler novamente'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: coffee,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(13),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ========================================
  // PERFIL
  // ========================================

  Widget profileScreen() {
    final progress = (readBooks.length / 12).clamp(0.0, 1.0).toDouble();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meu perfil',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: coffee,
                  ),
                ),
                const SizedBox(height: 23),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 48,
                            backgroundColor: beige,
                            child: Icon(
                              Icons.person,
                              size: 55,
                              color: coffee,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: coffee,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: editProfile,
                                icon: const Icon(
                                  Icons.edit,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Text(
                        profileName,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: coffee,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Apaixonada por histórias e novas perspectivas.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(height: 13),
                      OutlinedButton.icon(
                        onPressed: editProfile,
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Editar perfil'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: terracotta,
                          side: const BorderSide(color: terracotta),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Minha jornada literária',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: coffee,
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    libraryStat(
                      Icons.menu_book,
                      readingBooks.length.toString(),
                      'Lendo',
                    ),
                    const SizedBox(width: 9),
                    libraryStat(
                      Icons.bookmark,
                      savedBooks.length.toString(),
                      'Salvos',
                    ),
                    const SizedBox(width: 9),
                    libraryStat(
                      Icons.check_circle,
                      readBooks.length.toString(),
                      'Concluídos',
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: whiteCream,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: beige.withOpacity(0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.flag_outlined,
                            color: terracotta,
                          ),
                          const SizedBox(width: 9),
                          Text(
                            'Meta de leitura',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: coffee,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${readBooks.length} de 12 livros concluídos',
                        style: const TextStyle(
                          color: muted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: beige.withOpacity(0.4),
                          color: sage,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        '${(progress * 100).round()}% da sua meta alcançada!',
                        style: const TextStyle(
                          color: sage,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 27),
                Text(
                  'Minha conta',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: coffee,
                  ),
                ),
                const SizedBox(height: 10),
                profileOption(
                  Icons.bookmark_outline,
                  'Minha biblioteca',
                  'Organize suas leituras',
                  () {
                    setState(() => selectedTab = 2);
                  },
                ),
                profileOption(
                  Icons.menu_book_outlined,
                  'Leituras em andamento',
                  '${readingBooks.length} livro(s) sendo lido(s)',
                  () {
                    setState(() {
                      libraryFilter = 'Lendo';
                      selectedTab = 2;
                    });
                  },
                ),
                profileOption(
                  Icons.check_circle_outline,
                  'Livros concluídos',
                  '${readBooks.length} leitura(s) finalizada(s)',
                  () {
                    setState(() {
                      libraryFilter = 'Concluídos';
                      selectedTab = 2;
                    });
                  },
                ),
                profileOption(
                  Icons.star_outline,
                  'Minhas avaliações',
                  'Acompanhe suas opiniões literárias',
                  () {
                    message('Sua área de avaliações estará disponível em breve!');
                  },
                ),
                profileOption(
                  Icons.notifications_none,
                  'Notificações',
                  'Novidades e atualizações',
                  () {
                    message('Você está em dia com as novidades!');
                  },
                ),
                profileOption(
                  Icons.settings_outlined,
                  'Configurações',
                  'Personalize sua experiência',
                  () {
                    showSettings();
                  },
                ),
                profileOption(
                  Icons.help_outline,
                  'Sobre o Bookly',
                  'Mais que livros, novas perspectivas.',
                  () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Bookly',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(
                        Icons.auto_stories,
                        color: coffee,
                        size: 40,
                      ),
                      children: const [
                        Text(
                          'O Bookly é um espaço para descobrir livros, '
                          'organizar leituras e compartilhar experiências literárias.',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'BOOKLY • VERSÃO 1.0.0',
                    style: TextStyle(
                      color: muted.withOpacity(0.8),
                      fontSize: 10,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ========================================
  // EDITAR PERFIL
  // ========================================

  void editProfile() {
    final controller = TextEditingController(text: profileName);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: whiteCream,
          title: Text(
            'Editar perfil',
            style: GoogleFonts.playfairDisplay(
              color: coffee,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLength: 25,
            decoration: const InputDecoration(
              labelText: 'Seu nome',
              prefixIcon: Icon(
                Icons.person_outline,
                color: terracotta,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                controller.dispose();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: muted),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: coffee,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    profileName = controller.text.trim();
                  });
                }
                Navigator.pop(dialogContext);
                controller.dispose();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // ========================================
  // CONFIGURAÇÕES
  // ========================================

  void showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: whiteCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configurações',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: coffee,
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(
                  Icons.person_outline,
                  color: terracotta,
                ),
                title: const Text('Editar nome'),
                onTap: () {
                  Navigator.pop(context);
                  editProfile();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: terracotta,
                ),
                title: const Text('Limpar minha biblioteca'),
                subtitle: const Text('Remove todos os livros das coleções'),
                onTap: () {
                  Navigator.pop(context);
                  confirmClearLibrary();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void confirmClearLibrary() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: whiteCream,
          title: const Text('Limpar biblioteca?'),
          content: const Text(
            'Todos os livros salvos, em andamento e concluídos serão removidos das suas coleções.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: coffee,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  savedBooks.clear();
                  readingBooks.clear();
                  readBooks.clear();
                });
                Navigator.pop(dialogContext);
                message('Sua biblioteca foi limpa.');
              },
              child: const Text('Limpar'),
            ),
          ],
        );
      },
    );
  }

  // ========================================
  // OPÇÕES DO PERFIL
  // ========================================

  Widget profileOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: whiteCream,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: beige.withOpacity(0.5)),
      ),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: beige.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: terracotta),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: coffee,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: muted,
            fontSize: 11,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: muted,
        ),
        onTap: onTap,
      ),
    );
  }

  // ========================================
  // MENSAGENS
  // ========================================

  void message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: coffee,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

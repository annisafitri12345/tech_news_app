import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';
import '../routes/app_routes.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/article_card.dart';
import '../widgets/error_view.dart';
import '../widgets/search_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NewsApiService _service = NewsApiService();

  static const Map<String, String> _topics = {
    'teknologi': 'Utama',
    'AI': 'AI',
    'gadget': 'Gadget',
    'startup': 'Startup',
    'keamanan siber': 'Siber',
    'game': 'Game',
  };

  String _selected = 'teknologi';

  final Map<String, Future<List<ArticleModel>>> _cache = {};

  late Future<List<ArticleModel>> _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = _ambil(_selected);
  }

  Future<List<ArticleModel>> _ambil(String kunci) {
    return _cache.putIfAbsent(kunci, () => _service.searchNews(kunci));
  }

  void _gantiTopik(String kunci) {
    if (kunci == _selected) return;
    setState(() {
      _selected = kunci;
      _futureNews = _ambil(kunci);
    });
  }

  void _muatUlang() {
    setState(() {
      _cache.remove(_selected);
      _futureNews = _ambil(_selected);
    });
  }

  Future<void> _onRefresh() async {
    _muatUlang();
    try {
      await _futureNews;
    } catch (_) {}
  }

  Future<void> _bukaDialogCari() async {
    final kata = await showDialog<String>(
      context: context,
      builder: (_) => const SearchDialog(),
    );
    if (kata != null) {
      Get.toNamed(AppRoutes.search, arguments: kata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech News ID'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Cari berita',
            onPressed: _bukaDialogCari,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildChips(),
          Expanded(
            child: FutureBuilder<List<ArticleModel>>(
              future: _futureNews,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return ErrorView(
                    message: snapshot.error.toString(),
                    onRetry: _muatUlang,
                  );
                }
                final articles = snapshot.data ?? [];
                if (articles.isEmpty) {
                  return const Center(
                    child: Text('Belum ada berita untuk topik ini.'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return ArticleCard(
                        article: article,
                        onTap: () =>
                            Get.toNamed(AppRoutes.detail, arguments: article),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips() {
    return Container(
      height: 56,
      color: AppColors.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _topics.length,
        itemBuilder: (context, index) {
          final kunci = _topics.keys.elementAt(index);
          final dipilih = kunci == _selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: ChoiceChip(
              label: Text(_topics[kunci]!),
              selected: dipilih,
              onSelected: (_) => _gantiTopik(kunci),
              backgroundColor: Colors.white,
              selectedColor: AppColors.accent,
              surfaceTintColor: Colors.transparent,
              checkmarkColor: AppColors.textPrimary,
              labelStyle: const TextStyle(color: AppColors.textPrimary),
              side: BorderSide(
                color: dipilih ? AppColors.accentDark : AppColors.chipBorder,
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';
import '../routes/app_routes.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/article_card.dart';
import '../widgets/error_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final NewsApiService _service = NewsApiService();

  /// Kata kunci dari HomeView. Kosong bila halaman di-refresh di browser
  /// (arguments hilang).
  final String _keyword = (Get.arguments as String?)?.trim() ?? '';

  Future<List<ArticleModel>>? _futureHasil;

  @override
  void initState() {
    super.initState();
    if (_keyword.isNotEmpty) {
      _futureHasil = _service.searchNews(_keyword);
    }
  }

  void _muatUlang() {
    setState(() {
      _futureHasil = _service.searchNews(_keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_keyword.isEmpty ? 'Hasil Pencarian' : 'Hasil: $_keyword'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _keyword.isEmpty ? _buildTanpaKataKunci() : _buildHasil(),
    );
  }

  Widget _buildTanpaKataKunci() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            const Text(
              'Kata kunci tidak ditemukan. Silakan cari lagi dari beranda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Get.offAllNamed(AppRoutes.home),
              icon: const Icon(Icons.home),
              label: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHasil() {
    return FutureBuilder<List<ArticleModel>>(
      future: _futureHasil,
      builder: (context, snapshot) {
        // 1. Loading
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        // 2. Error
        if (snapshot.hasError) {
          return ErrorView(
            message: snapshot.error.toString(),
            onRetry: _muatUlang,
          );
        }
        // 3. Kosong
        final articles = snapshot.data ?? [];
        if (articles.isEmpty) {
          return Center(
            child: Text('Tidak ada berita untuk "$_keyword".'),
          );
        }
        // 4. Data
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return ArticleCard(
              article: article,
              onTap: () => Get.toNamed(AppRoutes.detail, arguments: article),
            );
          },
        );
      },
    );
  }
}
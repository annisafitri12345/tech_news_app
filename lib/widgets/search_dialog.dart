import 'package:flutter/material.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _pesanError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _kirim() {
    final teks = _controller.text.trim();
    if (teks.isEmpty) {
      setState(() => _pesanError = 'Kata kunci tidak boleh kosong');
      return;
    }
    Navigator.of(context).pop(teks);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cari Berita'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Contoh: robot, 5G, drone',
          errorText: _pesanError,
        ),
        onChanged: (_) {
          if (_pesanError != null) setState(() => _pesanError = null);
        },
        onSubmitted: (_) => _kirim(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _kirim, child: const Text('Cari')),
      ],
    );
  }
}
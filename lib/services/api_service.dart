import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

/// Erreur renvoyée par l'API (ou réseau injoignable).
class ApiException implements Exception {
  final String message;
  final int? status;
  final Map<String, String> errors;
  ApiException(this.message, {this.status, this.errors = const {}});

  /// Message à afficher : détails de validation s'ils existent.
  String get display => errors.isNotEmpty ? errors.values.join('\n') : message;

  @override
  String toString() => display;
}

/// Membre de famille tel que stocké en base MySQL (table famille_membre).
class Membre {
  final int id;
  final String nom, postnom, prenom, lieuNaissance, dateNaissance, parente;
  final String? image;
  final String? imageUrlFromApi;

  const Membre({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.image,
    this.imageUrlFromApi,
  });

  factory Membre.fromJson(Map<String, dynamic> j) => Membre(
    id: int.tryParse('${j['id']}') ?? 0,
    nom: '${j['nom'] ?? ''}',
    postnom: '${j['postnom'] ?? ''}',
    prenom: '${j['prenom'] ?? ''}',
    lieuNaissance: '${j['lieu_naissance'] ?? ''}',
    dateNaissance: '${j['date_naissance'] ?? ''}',
    parente: '${j['parente'] ?? ''}',
    image: j['image'] is String ? j['image'] as String : null,
    imageUrlFromApi: j['image_url'] is String ? j['image_url'] as String : null,
  );

  String get nomComplet => '$prenom $nom $postnom'.trim();

  /// URL complète de l'image, construite avec l'adresse de l'API actuelle.
  String? get imageUrl {
    if (imageUrlFromApi != null && imageUrlFromApi!.isNotEmpty) {
      final url = imageUrlFromApi!;
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return url;
      }
      if (url.startsWith('/')) {
        final base = Uri.parse(ApiService.baseUrl);
        return Uri(
          scheme: base.scheme,
          host: base.host,
          port: base.hasPort ? base.port : null,
          path: url,
        ).toString();
      }
      return '${ApiService.baseUrl}/${url.replaceFirst(RegExp(r'^/+'), '')}';
    }
    if (image == null || image!.isEmpty) return null;
    return '${ApiService.baseUrl}/${image!.replaceFirst(RegExp(r'^/+'), '')}';
  }

  /// Date au format JJ/MM/AAAA.
  String get dateFr {
    final p = dateNaissance.split('-');
    return p.length == 3 ? '${p[2]}/${p[1]}/${p[0]}' : dateNaissance;
  }

  int? get age {
    final d = DateTime.tryParse(dateNaissance);
    if (d == null) return null;
    final n = DateTime.now();
    var a = n.year - d.year;
    if (n.month < d.month || (n.month == d.month && n.day < d.day)) a--;
    return a;
  }
}

/// Client REST pour l'API PHP (https://github.com/espoirbaraka/api-test).
class ApiService {
  /// Modifiable depuis l'écran de connexion (icône serveur).
  /// - Émulateur Android : http://10.0.2.2/api-test-main/public
  /// - Web / Windows / iOS simulateur : http://localhost/api-test-main/public
  /// - Téléphone réel : http://IP_DU_PC/api-test-main/public
  static String baseUrl =
      (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
      ? 'http://10.0.2.2/api-test-main/public'
      : 'http://localhost/api-test-main/public';

  static const _json = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  /// Exécute la requête, décode le JSON et transforme les erreurs en ApiException.
  static Future<dynamic> _run(Future<http.Response> Function() call) async {
    http.Response r;
    try {
      r = await call().timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw ApiException('Le serveur met trop de temps à répondre.');
    } catch (_) {
      throw ApiException(
        "Impossible de joindre le serveur. Vérifiez qu'Apache et MySQL sont "
        'démarrés (XAMPP) et que l’adresse de l’API est correcte : $baseUrl',
      );
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        'Réponse invalide du serveur (code ${r.statusCode}).',
        status: r.statusCode,
      );
    }

    if (body['success'] == true) return body['data'];

    final errs = body['errors'];
    throw ApiException(
      '${body['message'] ?? 'Erreur inconnue'}',
      status: r.statusCode,
      errors: errs is Map ? errs.map((k, v) => MapEntry('$k', '$v')) : const {},
    );
  }

  /// Teste l'accès à la route de liste (true si l'API répond correctement).
  static Future<bool> testerConnexion() async {
    try {
      await listMembres();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---------- COMPTES ----------
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final d = await _run(
      () => http.post(
        _uri('/accounts/login'),
        headers: _json,
        body: jsonEncode({'email': email, 'password': password}),
      ),
    );
    return Map<String, dynamic>.from(d as Map);
  }

  static Future<Map<String, dynamic>> register(
    String email,
    String password,
  ) async {
    final d = await _run(
      () => http.post(
        _uri('/accounts/register'),
        headers: _json,
        body: jsonEncode({'email': email, 'password': password}),
      ),
    );
    return Map<String, dynamic>.from(d as Map);
  }

  // ---------- FAMILLE ----------
  static Future<List<Membre>> listMembres() async {
    final d = await _run(
      () => http.get(_uri('/famille-membres'), headers: _json),
    );
    return (d as List)
        .map((e) => Membre.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static MediaType _mime(String name) {
    switch (name.toLowerCase().split('.').last) {
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');
      default:
        return MediaType('image', 'jpeg');
    }
  }

  static Future<http.Response> _multipart(
    String path,
    Map<String, String> fields,
    XFile image,
  ) async {
    final req = http.MultipartRequest('POST', _uri(path))
      ..headers['Accept'] = 'application/json'
      ..fields.addAll(fields)
      ..files.add(
        http.MultipartFile.fromBytes(
          'image',
          await image.readAsBytes(),
          filename: image.name,
          contentType: _mime(image.name),
        ),
      );
    return http.Response.fromStream(await req.send());
  }

  /// POST /famille-membres : JSON sans image, multipart avec image.
  static Future<Membre> createMembre(
    Map<String, String> fields, {
    XFile? image,
  }) async {
    final d = await _run(
      () => image == null
          ? http.post(
              _uri('/famille-membres'),
              headers: _json,
              body: jsonEncode(fields),
            )
          : _multipart('/famille-membres', fields, image),
    );
    return Membre.fromJson(Map<String, dynamic>.from(d as Map));
  }

  /// PUT (JSON, image conservée) ou POST multipart si l'image change.
  static Future<Membre> updateMembre(
    int id,
    Map<String, String> fields, {
    XFile? image,
  }) async {
    final d = await _run(
      () => image == null
          ? http.put(
              _uri('/famille-membres/$id'),
              headers: _json,
              body: jsonEncode(fields),
            )
          : _multipart('/famille-membres/$id', fields, image),
    );
    return Membre.fromJson(Map<String, dynamic>.from(d as Map));
  }

  static Future<void> deleteMembre(int id) async {
    await _run(() => http.delete(_uri('/famille-membres/$id'), headers: _json));
  }
}

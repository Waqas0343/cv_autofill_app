import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'package:flutter_pdf_text/flutter_pdf_text.dart';

Future<File?> pickCVFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'docx'],
  );

  if (result != null) {
    return File(result.files.single.path!);
  } else {
    return null;
  }
}

Future<String> extractCVText(File file) async {
  if (file.path.endsWith('.pdf')) {
    try {
      PDFDoc doc = await PDFDoc.fromFile(file);
      String text = await doc.text;
      print("PDF Text Length: ${text.length}");
      return text;
    } catch (e) {
      print("PDF Error: $e");
      return '';
    }
  } else if (file.path.endsWith('.docx')) {
    return await extractDocxText(file);
  }
  return '';
}

Future<String> extractDocxText(File file) async {
  final bytes = await file.readAsBytes();
  final archive = ZipDecoder().decodeBytes(bytes);

  String fullText = '';

  for (final archFile in archive) {
    if (archFile.isFile && archFile.name.contains('document.xml')) {
      final content = String.fromCharCodes(archFile.content);
      final paragraphs = content.split('<w:p');
      for (final p in paragraphs) {
        final textMatch = RegExp(r'<w:t[^>]*>(.*?)</w:t>').allMatches(p);
        for (final m in textMatch) {
          String t = m.group(1) ?? '';
          t = t.replaceAll('xml:space="preserve"', '').trim();
          if (t.isNotEmpty) fullText += t + ' ';
        }
      }
    }
  }

  return fullText.replaceAll(RegExp(r'\s+'), ' ').trim();
}


Map<String, String> parseCVData(String rawText) {
  final Map<String, String> data = {};
  String text = rawText.replaceAll(RegExp(r'\s+'), ' ').trim();
  final lines = rawText
      .split(RegExp(r'\r?\n'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  String clean(String s) => s.replaceAll(RegExp(r'[^\w\s\@\.\-\+\/\:]'), '').trim();

  String name = '';
  final addressKeywords = [
    'pakistan','lahore','karachi','islamabad','rawalpindi','faisalabad','multan','peshawar','quetta','gujranwala','sialkot'
  ];

  for (int i = 0; i < lines.length && i < 8; i++) {
    String line = clean(lines[i]);

    if (line.length < 3 || line.length > 60) continue;
    if (line.contains('@') || line.contains('linkedin') || line.contains('http') || line.contains('/in/')) continue;
    if (RegExp(r'\d{2,}').hasMatch(line)) continue;
    if (line.toLowerCase().contains('resume') || line.toLowerCase().contains('cv')) continue;
    if (addressKeywords.any((kw) => line.toLowerCase().contains(kw))) continue;

    final words = line.split(' ');
    if (words.length >= 2 && words.length <= 5) {
      int caps = words.where((w) => w.isNotEmpty && w[0] == w[0].toUpperCase()).length;
      if (caps >= words.length - 1 || line.split(' ').every((w) => w.length > 2)) {
        name = line;
        break;
      }
    }
  }

  data['name'] = name.isEmpty ? 'Name Not Found' : name;

  String position = '';
  if (name != 'Name Not Found' && name.isNotEmpty) {
    int nameIndex = lines.indexWhere((l) => clean(l).contains(name.split(' ').first));
    if (nameIndex != -1 && nameIndex + 1 < lines.length) {
      String next = clean(lines[nameIndex + 1]);
      if (next.contains('/in/') || next.contains('linkedin') || next.contains('http')) {
        if (nameIndex + 2 < lines.length) next = clean(lines[nameIndex + 2]);
        else next = '';
      }
      if (next.isNotEmpty && next.length > 8 && next.length < 80) {
        if (RegExp(r'\b(developer|engineer|designer|manager|analyst|lead|specialist|consultant|architect|director|officer|ceo|cto|founder|intern|associate|executive|coordinator|seo|marketer)\b', caseSensitive: false).hasMatch(next)) {
          position = next;
        }
      }
    }
  }

  if (position.isEmpty) {
    for (String line in lines) {
      String cl = clean(line);
      if (RegExp(r'\b(developer|engineer|seo|marketer|lead|manager|specialist|consultant)\b', caseSensitive: false).hasMatch(cl)) {
        position = cl;
        break;
      }
    }
  }
  data['position'] = position;

  // ==================== 3. LINKEDIN ====================
  final patterns = [
    RegExp(r'https?://(www\.)?linkedin\.com/in/[\w\-]+', caseSensitive: false),
    RegExp(r'linkedin\.com/in/[\w\-]+', caseSensitive: false),
    RegExp(r'lnkd\.in/[\w\-]+', caseSensitive: false),
    RegExp(r'/in/[\w\-]+', caseSensitive: false),
  ];

  String linkedin = '';
  for (final pattern in patterns) {
    final match = pattern.firstMatch(text);
    if (match != null) {
      String link = match.group(0)!;
      if (link.startsWith('/in/')) linkedin = 'https://linkedin.com$link';
      else if (!link.startsWith('http')) linkedin = 'https://$link';
      else linkedin = link;
      if (linkedin.contains('lnkd.in')) linkedin = linkedin.replaceFirst('lnkd.in', 'linkedin.com/in');
      break;
    }
  }
  data['linkedin'] = linkedin;

  // ==================== 4. EMAIL & PHONE ====================
  final emailMatch = RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}').firstMatch(text);
  data['email'] = emailMatch?.group(0) ?? '';

  final phoneRaw = RegExp(r'(\+92|0)?[\s-]?(\d{3})[\s-]?(\d{7})').firstMatch(text);
  String phone = phoneRaw?.group(0) ?? '';
  if (phone.isNotEmpty) {
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (phone.startsWith('03')) phone = '+92' + phone.substring(1);
    if (phone.length == 11 && phone.startsWith('3')) phone = '+92' + phone.substring(1);
  }
  data['phone'] = phone;

  // ==================== 5. ADDRESS ====================
  final cities = ['karachi','lahore','islamabad','rawalpindi','faisalabad','multan','peshawar','quetta','gujranwala','sialkot'];
  for (String line in lines) {
    if (cities.any((c) => line.toLowerCase().contains(c))) {
      data['address'] = line;
      break;
    }
  }

  // ==================== 6. EDUCATION ====================
  final eduPattern = RegExp(r'\b(b\.?s\.?|m\.?s\.?|bachelor|master|bsc|msc|mba|ph\.?d|b\.?tech|m\.?tech|be|me|physics)\b', caseSensitive: false);
  for (String line in lines) {
    if (eduPattern.hasMatch(line)) {
      data['education'] = line;
      break;
    }
  }

  // ==================== FINAL DEBUG ====================
  print("\n" + "="*80);
  print("100% FINAL FIXED — NAME DETECTION ROBUST:");
  print("Name      → '${data['name']}'");
  print("Position  → '${data['position']}'");
  print("LinkedIn  → '${data['linkedin']}'");
  print("Email     → '${data['email']}'");
  print("Phone     → '$phone'");
  print("Address   → '${data['address']}'");
  print("Education → '${data['education']}'");
  print("="*80 + "\n");

  return data;
}









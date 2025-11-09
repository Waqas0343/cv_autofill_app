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

  final addressKeywords = [
    'pakistan','lahore','karachi','islamabad','rawalpindi','faisalabad','multan','peshawar','quetta','gujranwala','sialkot'
  ];

  final companyKeywords = [
    'company','solutions','digital','inc','llc','tech','limited','private','studio','media','creative','agency'
  ];

  String name = '';
  String company = '';

  // ===== 1. Company Detection =====
  for (int i = 0; i < lines.length && i < 6; i++) {
    String line = clean(lines[i]);
    if (companyKeywords.any((kw) => line.toLowerCase().contains(kw))) {
      company = line;
      break;
    }
  }

  // ===== 2. LinkedIn Detection =====
  final linkedInRegex = RegExp(r'(https?:\/\/)?(www\.)?(linkedin\.com|lnkd\.in)\/in\/[A-Za-z0-9\-_]+', caseSensitive: false);
  final linkedInMatch = linkedInRegex.firstMatch(text);
  String linkedin = linkedInMatch != null
      ? linkedInMatch.group(0)!
      .replaceAll('lnkd.in', 'linkedin.com/in')
      .replaceAll(RegExp(r'^https?:\/\/(www\.)?'), 'https://')
      : '';
  data['linkedin'] = linkedin;

  // ===== 3. Email Detection =====
  final emailMatch = RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}').firstMatch(text);
  data['email'] = emailMatch?.group(0) ?? '';

  // ===== 4. Name Detection =====
  // Detect line before or near LinkedIn or Email
  int emailIndex = lines.indexWhere((l) => l.contains(data['email'] ?? ''));
  int linkedInIndex = lines.indexWhere((l) => l.contains('linkedin.com') || l.contains('lnkd.in'));

  List<int> possibleIndexes = [linkedInIndex, emailIndex].where((i) => i != -1).toList();
  if (possibleIndexes.isNotEmpty) {
    int idx = possibleIndexes.first;
    for (int offset = 1; offset <= 2; offset++) {
      int above = idx - offset;
      if (above >= 0) {
        String l = clean(lines[above]);
        if (l.split(' ').length >= 2 &&
            l.split(' ').length <= 4 &&
            !l.contains('@') &&
            !l.contains('linkedin') &&
            !companyKeywords.any((kw) => l.toLowerCase().contains(kw))) {
          name = l;
          break;
        }
      }
    }
  }

  // Fallback: extract from email or LinkedIn username
  if (name.isEmpty && (data['email']!.isNotEmpty || data['linkedin']!.isNotEmpty)) {
    String base = data['email']!.isNotEmpty
        ? data['email']!.split('@').first
        : data['linkedin']!.split('/').last;
    base = base.replaceAll(RegExp(r'[\d\._\-]'), ' ');
    name = base
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ')
        .trim();
  }
  data['name'] = name.isEmpty ? 'Name Not Found' : name;

  // ===== 5. Position =====
  String position = '';
  final positionRegex = RegExp(r'\b(developer|engineer|designer|manager|analyst|lead|specialist|consultant|architect|director|officer|ceo|cto|founder|intern|associate|executive|coordinator|seo|marketer)\b', caseSensitive: false);
  for (String line in lines) {
    if (positionRegex.hasMatch(line)) {
      position = clean(line);
      break;
    }
  }
  data['position'] = position;

  // ===== 6. Phone =====
  final phoneRaw = RegExp(r'(\+92|0)?[\s-]?(\d{3})[\s-]?(\d{7})').firstMatch(text);
  String phone = phoneRaw?.group(0) ?? '';
  if (phone.isNotEmpty) {
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (phone.startsWith('03')) phone = '+92' + phone.substring(1);
    if (phone.length == 11 && phone.startsWith('3')) phone = '+92' + phone.substring(1);
  }
  data['phone'] = phone;

  // ===== 7. Address =====
  for (String line in lines) {
    if (addressKeywords.any((c) => line.toLowerCase().contains(c))) {
      data['address'] = line;
      break;
    }
  }

  // ===== 8. Education =====
  final eduPattern = RegExp(r'\b(b\.?s\.?|m\.?s\.?|bachelor|master|bsc|msc|mba|ph\.?d|b\.?tech|m\.?tech|be|me|physics|computer|science|information|technology)\b', caseSensitive: false);
  for (String line in lines) {
    if (eduPattern.hasMatch(line)) {
      data['education'] = line;
      break;
    }
  }

  // ===== 9. Skills =====
  final skillsPattern = RegExp(r'\b(skills?|technologies|tools)\b[:\-]?\s*(.*)', caseSensitive: false);
  for (int i = 0; i < lines.length; i++) {
    if (skillsPattern.hasMatch(lines[i])) {
      StringBuffer sb = StringBuffer();
      for (int j = i; j < lines.length && j < i + 5; j++) {
        String l = lines[j];
        if (RegExp(r'\b(experience|education|projects|certifications)\b', caseSensitive: false).hasMatch(l)) break;
        sb.write(l + " ");
      }
      data['skills'] = sb.toString().replaceAll(RegExp(r'(skills?|technologies|tools)[:\-]?', caseSensitive: false), '').trim();
      break;
    }
  }

  // ===== 10. Experience =====
  final expPattern = RegExp(r'\b(experience)\b', caseSensitive: false);
  for (int i = 0; i < lines.length; i++) {
    if (expPattern.hasMatch(lines[i])) {
      data['experience'] = lines[i + 1 < lines.length ? i + 1 : i];
      break;
    }
  }

  // ===== 11. Summary =====
  final summaryPattern = RegExp(r'\b(professional summary|summary|objective|profile)\b', caseSensitive: false);
  for (int i = 0; i < lines.length; i++) {
    if (summaryPattern.hasMatch(lines[i])) {
      StringBuffer buffer = StringBuffer();
      for (int j = i + 1; j < lines.length && j < i + 10; j++) {
        String next = lines[j].trim();
        if (next.isEmpty) break;
        if (RegExp(r'\b(skills|experience|education|certifications|projects|achievements)\b', caseSensitive: false).hasMatch(next)) break;
        buffer.writeln(next);
      }
      final summaryText = buffer.toString().trim();
      if (summaryText.isNotEmpty) data['summary'] = summaryText;
      break;
    }
  }

  // ===== 12. Certifications =====
  final certPattern = RegExp(r'(certificate|certified|coursera|udemy|google|meta|aws|microsoft|hubspot)', caseSensitive: false);
  List<String> certs = [];
  for (String line in lines) {
    if (certPattern.hasMatch(line)) certs.add(line);
  }
  data['certifications'] = certs.join(', ');

  print("\n" + "="*80);
  print("USER & COMPANY EXTRACTION:");
  print("Name      → '${data['name']}'");
  print("Company   → '${company.isEmpty ? 'Company Not Found' : company}'");
  print("Position  → '${data['position']}'");
  print("LinkedIn  → '${data['linkedin']}'");
  print("Email     → '${data['email']}'");
  print("Phone     → '${data['phone']}'");
  print("Address   → '${data['address']}'");
  print("Education → '${data['education']}'");
  print("Skills    → '${data['skills']}'");
  print("Experience→ '${data['experience']}'");
  print("Summary   → '${data['summary']}'");
  print("Certs     → '${data['certifications']}'");
  print("="*80 + "\n");

  return data;
}













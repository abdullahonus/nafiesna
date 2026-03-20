import 'dart:io';

void main() async {
  final output = await Process.run('dart', ['analyze', '--format=machine']);
  final lines = output.stdout.toString().split('\n');
  final stderrLines = output.stderr.toString().split('\n');
  final allLines = [...lines, ...stderrLines];
  
  for (var line in allLines) {
    if (line.isEmpty) continue;
    final parts = line.split('|');
    if (parts.length < 8) continue;
    
    // Format: SEVERITY|TYPE|ERROR_CODE|FILE_PATH|LINE|COLUMN|LENGTH|MESSAGE
    final errorCode = parts[2];
    final file = parts[3];
    final lineNum = int.tryParse(parts[4]) ?? -1;
    
    if (errorCode.contains('NON_CONSTANT') || errorCode.contains('INVALID_ASSIGNMENT') || errorCode.contains('NOT_CONSTANT') || errorCode.contains('CONST_') || errorCode.contains('INVALID_CONSTANT')) {
      if (lineNum > 0) {
        removeConstFromFileAtLine(file, lineNum);
      }
    }
  }
}

void removeConstFromFileAtLine(String filePath, int lineNum) {
  final file = File(filePath);
  if (!file.existsSync()) return;
  
  final lines = file.readAsLinesSync();
  if (lineNum <= lines.length) {
    var lineIndex = lineNum - 1;
    
    // Look for "const " on the current line.
    // If not found, look up to 20 lines backwards, because the error could point to a usage inside a const tree.
    int foundAt = -1;
    for (int i = lineIndex; i >= 0 && i >= lineIndex - 30; i--) {
       if (lines[i].contains('const ')) {
          foundAt = i;
          break;
       }
    }
    
    if (foundAt != -1) {
       lines[foundAt] = lines[foundAt].replaceFirst('const ', '');
       file.writeAsStringSync(lines.join('\n'));
    }
  }
}

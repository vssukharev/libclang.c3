
import clang;
import std::io;

enum ExitCodes : int (int value) {
  OK = 0,
  USAGE = 1,
  PARSE_ERROR = 2,
  DIAGNOSTIC_FAIL = 3,
}

fn int main(String[] args) {
  if (args.len < 2) { 
    io::eprintfn("Usage: %s <filename>", args[0]);
    return ExitCodes.USAGE.value;
  }

  String filename = args[1];

  CXIndex index = clang::createIndex(0, 0);
  defer clang::disposeIndex(index);

  CXTranslationUnit unit = clang::parseTranslationUnit(
    index,
    (ZString) filename, 
    null, 0,
    null, 0,
    clang::TRANSLATION_UNIT_NONE
  );

  if (unit == null) {
    io::eprintn("Failed to parse translation unit");
    return ExitCodes.PARSE_ERROR.value;
  }

  if (runDiagnostics(unit) > 0) {
    return ExitCodes.DIAGNOSTIC_FAIL.value;
  }

  return ExitCodes.OK.value;
}

fn uint runDiagnostics(CXTranslationUnit unit)
{
  uint error_count;

  CXDiagnosticSet diagnostics = clang::getDiagnosticSetFromTU(unit);
  defer clang::disposeDiagnosticSet(diagnostics);
  uint diags_len = clang::getNumDiagnosticsInSet(diagnostics);

  for (uint i = 0; i < diags_len; ++i) {
    CXDiagnostic diag = clang::getDiagnosticInSet(diagnostics, i);
    
    if (clang::getDiagnosticSeverity(diag) >= clang::DIAGNOSTIC_ERROR) { 
      CXSourceLocation loc = clang::getDiagnosticLocation(diag);
      CXFile file;
      uint line, column;
      CXString spelling = clang::getDiagnosticSpelling(diag);
      defer clang::disposeString(spelling);

      clang::getExpansionLocation(loc, &file, &line, &column, null);
      CXString filename = clang::getFileName(file);
      defer clang::disposeString(filename);

      io::printfn(
        "Error occured in %s (line %s, column %s): %s", 
        clang::getCString(filename), line, column,
        clang::getCString(spelling)
      );

      ++error_count;
    }

  }
  
  return error_count;
}


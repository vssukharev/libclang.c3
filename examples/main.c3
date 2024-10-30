
import clang;
import std::io;

fn int main(String[] args) {
  if (args.len < 2) { 
    io::eprintfn("Usage: %s <filename>", args[0]);
    return 1;
  }

  String filename = args[1];

  CXIndex index = clang::createIndex(0, 0); 
  CXTranslationUnit unit = clang::parseTranslationUnit(
    index,
    filename,
    null, 0,
    null, 0,
    CXTranslationUnit_None
  );

  if (unit == null) {
    io::eprintfn("ERROR: Unable to parse translation unit %s!", filename);
    return 1;
  }

  CXCursor cursor = clang::getTranslationUnitCursor(unit);

  return 0;
}


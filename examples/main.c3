
module main;

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
    (ZString) filename,
    null, 0,
    null, 0,
    clang::TRANSLATION_UNIT_NONE
  );

  if (unit == null) {
    io::eprintfn("ERROR: Unable to parse translation unit %s!", filename);
    return 1;
  }

  CXCursor cursor = clang::getTranslationUnitCursor(unit);

  clang::visitChildren(
    cursor, 
    fn (CXCursor current_cursor, CXCursor parent, CXClientData client_data) 
    {
      CXString current_display_name = clang::getCursorDisplayName(current_cursor);
      defer clang::disposeString(current_display_name);
      io::printfn("Visiting element: %s", clang::getCString(current_display_name)); 
      return clang::CHILD_VISIT_RECURSE;
    },
    null
  );

  return 0;
}


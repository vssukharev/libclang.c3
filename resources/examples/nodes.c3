
import clang;
import std::io;

// Entry point
fn int main(String[] args)
{
  if (args.len < 2) { 
    io::eprintfn("Usage: %s <filename>", args[0]);
    return 1;
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
  defer clang::disposeTranslationUnit(unit);

  if (unit == null) {
    io::eprintfn("ERROR: Unable to parse translation unit %s!", filename);
    return 1;
  }

  CXCursor cursor = clang::getTranslationUnitCursor(unit);

  clang::visitChildren(
    cursor, 
    &mainVisitor,
    null
  );

  return 0;
}


fn CXChildVisitResult mainVisitor(CXCursor cursor, CXCursor parent, CXClientData client_data) 
{
  CXType type = clang::getCursorType(cursor);
  CXSourceRange range = clang::getCursorExtent(cursor);
  CXType pointee_type = clang::getPointeeType(type);

  CXFile file;
  uint start_line, start_column, start_offset;
  uint end_line, end_column, end_offset;

  CXString display_name = clang::getCursorDisplayName(cursor);
  defer clang::disposeString(display_name);
  CXString parent_display_name = clang::getCursorDisplayName(parent);
  defer clang::disposeString(parent_display_name);
  CXString type_name = clang::getTypeSpelling(type);
  defer clang::disposeString(type_name);
  CXString kind_name = clang::getTypeKindSpelling(type.kind);
  defer clang::disposeString(kind_name);
  CXString pointee_type_name = clang::getTypeSpelling(pointee_type);
  defer clang::disposeString(pointee_type_name);

  clang::getExpansionLocation(clang::getRangeStart(range), &file, &start_line, &start_column, &start_offset);
  clang::getExpansionLocation(clang::getRangeEnd(range), &file, &end_line, &end_column, &end_offset);

  io::printfn(
  `Visiting child of %s
    Name: %s
    Type: %s
    Type kind: %s
    Pointed to: %s
    Start location
        Offset: %s
        Line: %s
        Column: %s
    End location
        Offset: %s
        Line: %s
        Column: %s`,
    clang::getCString(parent_display_name), 
    clang::getCString(display_name), 
    clang::getCString(type_name),
    clang::getCString(kind_name),
    clang::getCString(pointee_type_name),
    start_offset, start_line, start_column,
    end_offset, end_line, end_column
  );

  return clang::CHILD_VISIT_RECURSE;
}


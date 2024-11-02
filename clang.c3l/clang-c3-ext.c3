
module clang;
import libc;

/*---------------------------------*\
|                                   |
|  This file contains additional    |
|  definitions of libclang for c3.  | 
|  For example, ordinary function   |
|  for CXCursor are rewritten as    |
|  CXCursor methods. The file       |
|  is made only for conveniency     |
|  sake and do not overwrite        |
|  original functions.              |
|                                   |
\*---------------------------------*/

/*-------------------------------*\
|                                 |
|         File CXString.h         |
|                                 |
\*-------------------------------*/

/**
 * Retrieve the character data associated with the given string.
 */
macro ZString CXString.getCString(
  CXString string) 
=> getCString(string);

/**
 * Free the given string.
 */
macro void CXString.dispose(
  CXString string) 
=> disposeString(string);

/**
 * Free the given string set.
 */
macro void CXStringSet.dispose(
  CXStringSet* set) 
=> disposeStringSet(set);


/*-------------------------------*\
|                                 |
|          File CXFile.h          |
|                                 |
\*-------------------------------*/

/**
 * Retrieve the complete file and path name of the given file.
 */
macro CXString CXFile.getName(
  CXFile sfile) 
=> getFileName(sfile);

/**
 * Retrieve the last modification time of the given file.
 */
macro Time_t CXFile.getTime(
  CXFile sfile)
=> getFileTime(sfile);

/**
 * Retrieve the unique ID for the given \c file.
 *
 * \param file the file to get the ID for.
 * \param outID stores the returned CXFileUniqueID.
 * \returns If there was a failure getting the unique ID, returns non-zero,
 * otherwise returns 0.
 */
macro CInt CXFile.getUniqueID(
  CXFile file, 
  CXFileUniqueID* out_id)
=> getFileUniqueID(file, out_id);

/**
 * Returns non-zero if the \c file1 and \c file2 point to the same file,
 * or they are both NULL.
 */
macro CInt CXFile.equals(
  CXFile file, 
  CXFile other) 
=> file.isEqual(other);


/*-------------------------------*\
|                                 |
|     File CXSourceLocation.h     |
|                                 |
\*-------------------------------*/

/**
 * Determine whether two source locations, which must refer into
 * the same translation unit, refer to exactly the same point in the source
 * code.
 *
 * \returns non-zero if the source locations refer to the same location, zero
 * if they refer to different locations.
 */
macro CUInt CXSourceLocation.equals(
  CXSourceLocation loc, 
  CXSourceLocation other) 
=> equalLocations(loc, other);

/**
 * Determine whether two ranges are equivalent.
 *
 * \returns non-zero if the ranges are the same, zero if they differ.
 */
macro CUInt equals(
  CXSourceRange range, 
  CXSourceRange other) 
=> equalRanges(range, other);

/**
 * Retrieve the file, line, column, and offset represented by
 * the given source location.
 *
 * If the location refers into a macro expansion, retrieves the
 * location of the macro expansion.
 *
 * \param location the location within a source file that will be decomposed
 * into its parts.
 *
 * \param file [out] if non-NULL, will be set to the file to which the given
 * source location points.
 *
 * \param line [out] if non-NULL, will be set to the line to which the given
 * source location points.
 *
 * \param column [out] if non-NULL, will be set to the column to which the given
 * source location points.
 *
 * \param offset [out] if non-NULL, will be set to the offset into the
 * buffer to which the given source location points.
 */
macro void CXSourceLocation.getExpansion(
  CXSourceLocation location, 
  CXFile* file, 
  CUInt* line, 
  CUInt* column, 
  CUInt* offset) 
=> getExpansionLocation(location, file, line, column, offset);

/**
 * Retrieve the file, line and column represented by the given source
 * location, as specified in a # line directive.
 *
 * Example: given the following source code in a file somefile.c
 *
 * \code
 * #123 "dummy.c" 1
 *
 * static CInt func(void)
 * {
 *     return 0;
 * }
 * \endcode
 *
 * the location information returned by this function would be
 *
 * File: dummy.c Line: 124 Column: 12
 *
 * whereas clang_getExpansionLocation would have returned
 *
 * File: somefile.c Line: 3 Column: 12
 *
 * \param location the location within a source file that will be decomposed
 * into its parts.
 *
 * \param filename [out] if non-NULL, will be set to the filename of the
 * source location. Note that filenames returned will be for "virtual" files,
 * which don't necessarily exist on the machine running clang - e.g. when
 * parsing preprocessed output obtained from a different environment. If
 * a non-NULL value is passed in, remember to dispose of the returned value
 * using \c clang_disposeString() once you've finished with it. For an invalid
 * source location, an empty string is returned.
 *
 * \param line [out] if non-NULL, will be set to the line number of the
 * source location. For an invalid source location, zero is returned.
 *
 * \param column [out] if non-NULL, will be set to the column number of the
 * source location. For an invalid source location, zero is returned.
 */
macro void CXSourceLocation.getPresumed(
  CXSourceLocation location, 
  CXString* filename, 
  CUInt* line, 
  CUInt* column) 
=> getPresumedLocation(location, filename, line, column);

/**
 * Legacy API to retrieve the file, line, column, and offset represented
 * by the given source location.
 *
 * This interface has been replaced by the newer interface
 * #clang_getExpansionLocation(). See that interface's documentation for
 * details.
 */
macro void CXSourceLocation.getInstantiation(
  CXSourceLocation location, 
  CXFile* file, 
  CUInt* line, 
  CUInt* column, 
  CUInt* offset) 
=> getInstantiationLocation(location, filename, line, column, offset);

/**
 * Retrieve the file, line, column, and offset represented by
 * the given source location.
 *
 * If the location refers into a macro instantiation, return where the
 * location was originally spelled in the source file.
 *
 * \param location the location within a source file that will be decomposed
 * into its parts.
 *
 * \param file [out] if non-NULL, will be set to the file to which the given
 * source location points.
 *
 * \param line [out] if non-NULL, will be set to the line to which the given
 * source location points.
 *
 * \param column [out] if non-NULL, will be set to the column to which the given
 * source location points.
 *
 * \param offset [out] if non-NULL, will be set to the offset into the
 * buffer to which the given source location points.
 */
macro void CXSourceLocation.getSpelling(
  CXSourceLocation location, 
  CXFile* file, 
  CUInt* line, 
  CUInt* column, 
  CUInt* offset) 
=> getSpellingLocation(location, filename, line, column, offset);

/**
 * Retrieve the file, line, column, and offset represented by
 * the given source location.
 *
 * If the location refers into a macro expansion, return where the macro was
 * expanded or where the macro argument was written, if the location points at
 * a macro argument.
 *
 * \param location the location within a source file that will be decomposed
 * into its parts.
 *
 * \param file [out] if non-NULL, will be set to the file to which the given
 * source location points.
 *
 * \param line [out] if non-NULL, will be set to the line to which the given
 * source location points.
 *
 * \param column [out] if non-NULL, will be set to the column to which the given
 * source location points.
 *
 * \param offset [out] if non-NULL, will be set to the offset into the
 * buffer to which the given source location points.
 */
fn void CXSourceLocation.getFile(
  CXSourceLocation location, 
  CXFile* file, 
  CUInt* line, 
  CUInt* column, 
  CUInt* offset) 
=> getFileLocation(location, filename, line, column, offset);

/**
 * Retrieve a source location representing the first character within a
 * source range.
 */
fn CXSourceLocation CXSourceRange.getStart(
  CXSourceRange range) 
=> getRangeStart(range);

/**
 * Retrieve a source location representing the last character within a
 * source range.
 */
fn CXSourceLocation CXSourceRange.getEnd(
  CXSourceRange range) 
=> getRangeEnd(range);

/**
 * Destroy the given \c CXSourceRangeList.
 */
fn void CXSourceRangeList.dispose(
  CXSourceRangeList* ranges) 
=> disposeSourceRangeList(ranges);



# libclang-c3

**libclang-c3** are bindings for [libclang](https://clang.llvm.org/docs/LibClang.html) C library (not C++).

## Installation

To include these bindings into your project, do:
```console
$ git clone https://github.com/vssukharev/libclang.c3.git    # Clone repo somewhere
$ cd libclang.c3
$ mv clang.c3l /path/to/project/libraries                # Move to libraries directory of your project
```

Then you need to modify your `project.json`:
```json
{
  // some stuff
  "dependencies":  [ "clang", /* Some other dependencies */ ],
  // some other stuff
}
```

Simply do `c3c run` to check whether everything is fine (make sure to have `libclang` installed on your system).


## Translation Rules

1. Types which point to incomplete types are declared as `distinct`. For example: `typedef struct CXTargetInfoImpl *CXTargetInfo` -> `disitnct CXTargetInfo = void*`.
2. All fields in structures, starting with upper case letter, are lowercased. For example: `unsigned long Length` -> `ulong length`
3. All function prefixes are deleted. For example: `clang_<func-name>` -> `<func-name>`.
4. The following basic type substitutions are performed:
  - `unsigned <integral>` -> `u<integral>` (`unsigned long` -> `ulong`)
  - `const <type>` -> `<type>` (`const int` -> `int`)
  - `char*` -> `ZString`
  - `unsigned` -> `uint`
  - `size_t` -> `usz`
5. All enumerations are replaced with a set of `const` values and enumeration types themselves are `distinct`s for their underlying types. Their members are uppercased and got rid of library prefix. For example `enum CXGlobalOptFlags : int` -> `distint CXGlobalOptFlags = int` and `CXGlobalOpt_None` -> `GLOBAL_OPT_NONE`.
6. All functions, which names start with a 'type' or 'subclass' and followed by `_` and started with upper-case letter (like `CXXConstructor_isCopyConstructor`), have this 'type' moved to the end and prefixed with `_` (to `isCopyConstructor_CXXConstructor`).
7. All functions, marked `CINDEX_DEPRECATED` are marked `@deprecated`


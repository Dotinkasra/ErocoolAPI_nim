# Erocool Unofficial API for Nim

・[Original](https://github.com/Dotinkasra/ErocoolAPI/)
## Doc
### Types

```nim
type Data* = ref object
  jaTitle*: JaTitle
  enTitle*: EnTitle
  uploadDate*: UploadDate
  lang*: Lang
  thumbnail*: Thumbnail
  url*: Url
  artists*: Artists
  groups*: Groups
  parodies*: Parodies
  tags*: Tags
  imageList*: ImageList
  totalPages*: int
```

```nim
type ErocoolAPI* = ref object
  scraper: Scraper
  data: Data
```

### Procs
```nim
proc newErocoolAPI*(url: string, ua: string = ""): ErocoolAPI
```

```nim
proc reset*(self: ErocoolAPI, url: string)
```

```nim
proc download*(self: ErocoolAPI, start: int = 1, last: int = -1, output: string = "./", name: string = "")
```

```nim
proc getAllInfo*(self: ErocoolAPI): JsonNode
```

```nim
proc getInfoBySpecifyingKey*(self: ErocoolAPI, key: string): JsonNode 
```

## Commandline

```bash
erocoolAPI --url 'https://ja.erocool.com/detail/xxxxxxx.html'
```

```bash
erocoolAPI --url 'https://ja.erocool.com/detail/xxxxxxx.html' -s 5 -e 10 -o ~/Downloads/Mangas -n 'xxxxx'
```

User-Agent can be specified.

```bash
erocoolAPI --url 'https://ja.erocool.com/detail/xxxxxxx.html' --ua "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6)"
```

```bash
 $ ./erocoolapi -h
Usage:
  mangaDownload [REQUIRED,optional-params]
Download the cartoon at the URL set in the constructor of the Scraper object.
Options:
  -h, --help                        print this cligen-erated help
  --help-syntax                     advanced: prepend,plurals,..
  --url=          string  REQUIRED  URL of the contents
  -s=, --start=   int     1         Specify the first page number to start downloading.
  -e=, --last=    int     -1        Specify the last page number to finish downloading.
  -o=, --output=  string  "./"      Output directory
  -n=, --name=    string  ""        Directory name
  -u=, --ua=      string  ""        User-Agent
```

### For Windows users.

You will need to install mingw from the following site and set the environment variables.
https://nim-lang.org/install_windows.html

Alternatively, we recommend running binaries for Linux on WSLs.

## Update
- **v0.1.3b**  Increased e-hentai download speed up to 2x.  
- **v0.1.3**   Compatible with NIJIERO.  
- **v0.1.2**   Support for e-hentai.
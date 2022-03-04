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
  saveImg*: proc(url: string, pathWithImgname: string)
```

```nim
type Scraper* = ref object
  userAgent*: string
  url*: string
  xml*: XmlNode
```

```nim
type DownloadOption* = object
  absolutePath*: string
  directoryName*: string
  start*: int
  last*: Option[int]
```

### Procs
```nim
proc newScraper*(url: string): Scraper =
```

```nim
proc newScraperWithUa*(url: string, ua: string): Scraper =
```

```nim
proc download*(self: Scraper, data: Data, dlOption: DownloadOption) =
```

```nim
proc genDlOption*(self: Scraper, absolutePath: string = "./", directoryName: string = "", start: int = 1, last: Option[int] = none(int)): DownloadOption =
```

```nim
proc getData*(self: Scraper): Data =
```

## Commandline

```bash
erocoolAPI --url 'https://ja.erocool.com/detail/xxxxxxx.html'
```

```bash
erocoolAPI --url 'https://ja.erocool.com/detail/xxxxxxx.html' -s 5 -e 10 -o ~/Downloads/Mangas -n 'xxxxx'
```


```bash
 $ ./erocoolapi -h
Usage:
  mangaDownload [REQUIRED,optional-params]
Options:
  -h, --help                        print this cligen-erated help
  --help-syntax                     advanced: prepend,plurals,..
  -u=, --url=     string  REQUIRED  URL of the contents
  -s=, --start=   int     1         Specify the first page number to start downloading.
  -e=, --last=    int     -1        Specify the last page number to finish downloading.
  -o=, --output=  string  "./"      Output directory
  -n=, --name=    string  ""        Directory name
```


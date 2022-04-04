# Erocool Unofficial API for Nim

・[Original](https://github.com/Dotinkasra/ErocoolAPI/)
## 仕様
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
  scraper*: Scraper
  data*: Data
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

## コマンドライン

```bash
erocoolAPI --url 'https://ja.erocool.com/detail/xxxxxxx.html'
```

開始番号、終了番号、保存先、ディレクトリ名が指定できます。

```bash
erocoolAPI --url 'https://ja.erocool.com/detail/xxxxxxx.html' -s 5 -e 10 -o ~/Downloads/Mangas -n 'xxxxx'
```

User-Agentを指定することができます。

```bash
erocoolAPI --url 'https://ja.erocool.com/detail/xxxxxxx.html' --ua "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6)"
```

その他

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

### Windowsで利用する場合

以下のサイトからmingwをインストールし、環境変数を設定する必要があります。
https://nim-lang.org/install_windows.html

もしくは、Linux向けバイナリをWSL上で実行する方法がおすすめです。

## アップデート

- **v0.1.3b**  e-hentaiのダウンロード速度を最大2倍に向上。  
- **v0.1.3**   二次エロ画像サーチに対応。  
- **v0.1.2**   e-hentaiに対応。  
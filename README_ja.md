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

## コマンドライン
通常のダウンロード

```bash
erocoolAPI 'https://ja.erocool.com/detail/xxxxxxx.html'
```

開始番号、終了番号、保存先、ディレクトリ名が指定できます。

```bash
erocoolAPI 'https://ja.erocool.com/detail/xxxxxxx.html' -s 5 -e 10 -o ~/Downloads/Mangas -n 'xxxxx'
```

User-Agentを指定することができます。

```bash
erocoolAPI 'https://ja.erocool.com/detail/xxxxxxx.html' --ua "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6)"
```

その他

```bash
 $ ./erocoolAPI -h
Usage:
  mangaDownload [optional-params] [args: string...]
Download the cartoon at the URL set in the constructor of the Scraper object.
Options:
  -h, --help                        ヘルプを表示します
  --help-syntax                     advanced: prepend,plurals,..
  -s=, --start=   int     1         ダウンロードする漫画の開始番号を指定できます。
  -e=, --last=    int     -1        ダウンロードする漫画の終了番号を指定できます。
  -o=, --output=  string  "./"      出力先のディレクトリを指定できます。
  -n=, --name=    string  ""        出力するディレクトリの名前を設定できます。
  -u=, --ua=      string  ""        User-Agentを指定できます。
  -v, --info      bool    false     ダウンロード処理を行わずに詳細のみ出力します。
  -b, --debug     bool    false     デバッグ情報を出力します。
```

### Windowsで利用する場合

以下のサイトからmingwをインストールし、環境変数を設定する必要があります。
https://nim-lang.org/install_windows.html

もしくは、Linux向けバイナリをWSL上で実行する方法がおすすめです。

## アップデート

- **v0.1.51**   ダウンロード処理の改善。オプションを追加。
- **v0.1.5**   okhentaiに対応。
- **v0.1.4**   IMhentaiに対応。e-hentaiのダウンロード処理を改善。
- **v0.1.3b**  e-hentaiのダウンロード速度を最大2倍に向上。  
- **v0.1.3**   二次エロ画像サーチに対応。  
- **v0.1.2**   e-hentaiに対応。  
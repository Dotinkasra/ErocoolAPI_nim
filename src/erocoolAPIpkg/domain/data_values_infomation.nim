import 
  #random,
  #strutils,
  options

#日本語タイトル処理
type JaTitle* = ref object
  value: string

proc new*(_: type JaTitle, n: string): JaTitle =
  return JaTitle(
    #value: if len(n) > 0: n else: intToStr(rand(int.high)) 
    value: n
  )

proc `$`*(self: JaTitle): string =
  return self.value

#英語タイトル処理
type EnTitle* = ref object
  value: string
  
proc new*(_: type EnTitle, n: string): EnTitle =
  return EnTitle(
    #value: if len(n) > 0: n else: intToStr(rand(int.high)) 
    value: n
  )

proc `$`*(self: EnTitle): string =
  return self.value

#投稿日処理
type UploadDate* = ref object
  value: string
  
proc new*(_: type UploadDate, n: string): UploadDate =
  return UploadDate(
    value: n
  )

proc `$`*(self: UploadDate): string =
  return self.value

#言語処理
type Lang* = ref object
  value: string
  
proc new*(_: type Lang, n: string): Lang =
  return Lang(
    value: n
  )

proc `$`*(self: Lang): string =
  return self.value

#サムネイル処理
type Thumbnail* = ref object
  value: string
  
proc new*(_: type Thumbnail, n: string): Thumbnail =
  return Thumbnail(
    value: n
  )

proc `$`*(self: Thumbnail): string =
  return self.value

#URL処理
type Url* = ref object
  value: string
  
proc new*(_: type Url, n: string): Url =
  return Url(
    value: n
  )

proc `$`*(self: Url): string =
  return self.value

#作者処理
type Artists* = ref object
  value: seq[string]
  
proc new*(_: type Artists, n: seq[string]): Artists =
  return Artists(
    value: n
  )

proc value*(self: Artists): seq[string] =
  return self.value

#サークル処理
type Groups* = ref object
  value: seq[string]
  
proc new*(_: type Groups, n: seq[string]): Groups =
  return Groups(
    value: n
  )

proc value*(self: Groups): seq[string] =
  return self.value

#原作処理
type Parodies* = ref object
  value: seq[string]
  
proc new*(_: type Parodies, n: seq[string]): Parodies =
  return Parodies(
    value: n
  )

proc value*(self: Parodies): seq[string] =
  return self.value

#サークル処理
type Tags* = ref object
  value: seq[string]
  
proc new*(_: type Tags, n: seq[string]): Tags =
  return Tags(
    value: n
  )

proc value*(self: Tags): seq[string] =
  return self.value

#画像処理
type ImageList* = ref object
  value: seq[string]
  
proc new*(_: type ImageList, n: seq[string]): ImageList =
  return ImageList(
    value: n
  )

proc value*(self: ImageList): seq[string] =
  return self.value

#ページ数処理
type TotalPages* = ref object
  value: int
  
proc new*(_: type TotalPages, n: int): TotalPages =
  return TotalPages(
    value: n
  )

proc value*(self: TotalPages): int =
  return self.value

#ダウンロード引数処理
type DownloadOption* = object
  absolutePath*: string
  directoryName*: string
  start*: int
  last*: Option[int]
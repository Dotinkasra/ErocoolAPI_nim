import 
  random,
  strutils

discard """
  jaTitle : string
  enTitle : string
  uploadDat : string
  lang : string
  thumbnail : string
  url : string
  artists : seq[string]
  groups : seq[string]
  parodies : seq[string]
  tags : seq[string]
  imageList : seq[string]
  totalPages : int
"""

#日本語タイトル処理
type JaTitle* = ref object
  value: string

proc new*(_: JaTitle, n: string): JaTitle =
  return JaTitle(
    value: if len(n) > 0: n else: intToStr(rand(int.high)) 
  )

proc `$`*(self: JaTitle): string =
  return self.value


#英語タイトル処理
type EnTitle* = ref object
  value: string
  
proc new*(_: EnTitle, n: string): EnTitle =
  return EnTitle(
    value: if len(n) > 0: n else: intToStr(rand(int.high)) 
  )

proc `$`*(self: EnTitle): string =
  return self.value

#投稿日処理
type UploadDat* = ref object
  value: string
  
proc new*(_: UploadDat, n: string): UploadDat =
  return UploadDat(
    value: n
  )

proc `$`*(self: UploadDat): string =
  return self.value

#言語処理
type Lang* = ref object
  value: string
  
proc new*(_: Lang, n: string): Lang =
  return Lang(
    value: n
  )

proc `$`*(self: Lang): string =
  return self.value

#サムネイル処理
type Thumbnail* = ref object
  value: string
  
proc new*(_: Thumbnail, n: string): Thumbnail =
  return Thumbnail(
    value: n
  )

proc `$`*(self: Thumbnail): string =
  return self.value

#URL処理
type Url* = ref object
  value: string
  
proc new*(_: Url, n: string): Url =
  return Url(
    value: n
  )

proc `$`*(self: Url): string =
  return self.value

#作者処理
type Artists* = ref object
  value: seq[string]
  
proc new*(_: Artists, n: seq[string]): Artists =
  return Artists(
    value: n
  )

proc `$`*(self: Artists): seq[string] =
  return self.value

#サークル処理
type Groups* = ref object
  value: seq[string]
  
proc new*(_: Groups, n: seq[string]): Groups =
  return Groups(
    value: n
  )

proc `$`*(self: Groups): seq[string] =
  return self.value

#原作処理
type Parodies* = ref object
  value: seq[string]
  
proc new*(_: Parodies, n: seq[string]): Parodies =
  return Parodies(
    value: n
  )

proc `$`*(self: Parodies): seq[string] =
  return self.value

#サークル処理
type Tags* = ref object
  value: seq[string]
  
proc new*(_: Tags, n: seq[string]): Tags =
  return Tags(
    value: n
  )

proc `$`*(self: Tags): seq[string] =
  return self.value

#画像処理
type ImageList* = ref object
  value: seq[string]
  
proc new*(_: ImageList, n: seq[string]): ImageList =
  return ImageList(
    value: n
  )

proc `$`*(self: ImageList): seq[string] =
  return self.value

#ページ数処理
type TotalPages* = ref object
  value: int
  
proc new*(_: TotalPages, n: int): TotalPages =
  return TotalPages(
    value: n
  )

proc `$`*(self: TotalPages): int =
  return self.value

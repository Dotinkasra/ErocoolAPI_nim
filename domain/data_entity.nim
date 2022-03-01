import 
  data_values_infomation,
  options,
  os,
  httpclient,
  re

type Data* = ref object
  jaTitle*: JaTitle
  enTitle*: EnTitle
  uploadDat*: UploadDat
  lang*: Lang
  thumbnail*: Thumbnail
  url*: Url
  artists*: Artists
  groups*: Groups
  parodies*: Parodies
  tags*: Tags
  imageList*: ImageList
  totalPages*: int

proc new*(
  _:type Data,
  jaTitle: JaTitle,
  enTitle: EnTitle,
  uploadDat: UploadDat,
  lang: Lang,
  thumbnail: Thumbnail,
  url: Url,
  artists: Artists,
  groups: Groups,
  parodies: Parodies,
  tags: Tags,
  imageList: ImageList,
  totalPages: int
): Data =
  return Data(
    jaTitle = jaTitle,
    enTitle = enTitle,
    uploadDat = uploadDat,
    lang = lang,
    thumbnail = thumbnail,
    url = url,
    artists = artists,
    groups = groups,
    parodies = parodies,
    tags = tags,
    imageList = imageList,
  )

proc download*(
  self: Data,
  absolutePath: string = "./", 
  directoryName: string = "", 
  start: int = 1, 
  last = none(int)
) =
  let path: string = if absolutePath != "./": absolutePath else: "./"
  let name: string = if directoryName != "": directoryName else: self.jaTitle.`$`
  let saveDir: string = os.joinPath(path, name)
  if not saveDir.dirExists:
    os.createDir(saveDir)
  let last = if last.isSome: last.get() else: self.totalPages
  for i in start - 1..last - 1:
    let urlInFilename: seq[string] = self.imageList.value[i].findAll(re"http.://.*/(.*jpg|.*png)")
    if len(urlInFilename) == 0: continue
    let fileName: string = "hcooldl_" & urlInFilename[0]
    let img = newHttpClient().getContent(self.imageList.value[i])
    let f: File = open(fileName, FileMode.fmWrite)
    f.write img
    close(f)

proc jaTitle*(self: Data): JaTitle =
  return self.jaTitle

proc enTitle*(self: Data): EnTitle =
  return self.enTitle

proc uploadDat*(self: Data): UploadDat =
  return self.uploadDat

proc lang*(self: Data): Lang =
  return self.lang

proc thumbnail*(self: Data): Thumbnail =
  return self.thumbnail

proc artists*(self: Data): Artists =
  return self.artists

proc groups*(self: Data): Groups =
  return self.groups

proc parodies*(self: Data): Parodies =
  return self.parodies

proc tags*(self: Data): Tags =
  return self.tags

proc imageList*(self: Data): ImageList =
  return self.imageList

proc totalPages*(self: Data): int =
  return len(self.imageList.value)

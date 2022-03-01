import 
  data_values_infomation,
  options,
  os,
  httpclient,
  nre,
  strformat

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

proc new*(_:type Data,): Data = return Data()

proc download*(
  self: Data,
  dlOption: DownloadOption
) =
  let absolutePath: string = dlOption.absolutePath
  let directoryName: string = dlOption.directoryName
  let start: int = dlOption.start
  let last = if dlOption.last.isSome: dlOption.last.get() else: self.totalPages

  let path: string = if absolutePath != "./": absolutePath else: "./"
  let name: string = if directoryName != "": directoryName else: self.jaTitle.`$`
  let saveDir: string = os.joinPath(path, name)
  if not saveDir.dirExists:
    os.createDir(saveDir)
  
  for i in start - 1..last - 1:
    let img = newHttpClient().getContent(self.imageList.value[i])
    let urlInFilename: RegexMatch = self.imageList.value[i].find(re"""http.://.*/(.*|.*png)""").get
    if len(urlInFilename.captures.toSeq()) > 0:
      let fileName: string = "hcooldl_" & urlInFilename.captures[0]
      let f: File = open(os.joinPath(saveDir, fileName), FileMode.fmWrite)
      f.write img
      close(f)

proc info*(self: Data) =
  echo fmt"""
    -------Infomation-------
    【LANGUAGE】
    {self.lang.`$`}
    【URL】
    {self.url.`$`}
    【JA_TITLE】
    {self.jaTitle.`$`}
    【EN_TITLE】
    {self.enTitle.`$`}
    【UPLOAD_DATE】
    {self.uploadDate.`$`}
    【ARTISTS】
    {self.artists.value}
    【GROUPS】
    {self.groups.value}
    【PARODIES】
    {self.parodies.value}
    【TAGS】
    {self.tags.value}
    【PAGE_COUNT】
    {$self.total_pages}
    【THUMBNAIL】
    {self.thumbnail.`$`}
    """

proc jaTitle*(self: Data): JaTitle =
  return self.jaTitle

proc enTitle*(self: Data): EnTitle =
  return self.enTitle

proc uploadDate*(self: Data): UploadDate =
  return self.uploadDate

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

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
  saveImg*: proc(url: string, pathWithImgname: string)

proc new*(_:type Data,): Data = return Data()

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

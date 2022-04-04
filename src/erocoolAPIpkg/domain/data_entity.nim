import 
  data_values_infomation

type Data* = ref object
  ## An object that stores cartoon information.
  jaTitle: JaTitle
  enTitle: EnTitle
  uploadDate: UploadDate
  lang: Lang
  thumbnail: Thumbnail
  url: Url
  artists: Artists
  groups: Groups
  parodies: Parodies
  tags: Tags
  imageList: ImageList
  totalPages: int
  saveImg*: proc(url: string, pathWithImgname: string)

proc new*(_:type Data,): Data = return Data()

proc getJaTitle*(self: Data): string =
  return $self.jaTitle

proc getEnTitle*(self: Data): string =
  return $self.enTitle

proc getUploadDate*(self: Data): string =
  return $self.uploadDate

proc getLang*(self: Data): string =
  return $self.lang

proc getThumbnail*(self: Data): string =
  return $self.thumbnail

proc getArtists*(self: Data): seq[string] =
  return self.artists.value

proc getGroups*(self: Data): seq[string] =
  return self.groups.value

proc getParodies*(self: Data): seq[string] =
  return self.parodies.value

proc getTags*(self: Data): seq[string] =
  return self.tags.value

proc getImageList*(self: Data): seq[string] =
  return self.imageList.value

proc getUrl*(self: Data): string =
  return $self.url

proc getTotalPages*(self: Data): int =
  return len(self.imageList.value)

proc setJatitle*(self: Data, n: string) =
  self.jaTitle = JaTitle.new(n)

proc setEnTitle*(self: Data, n: string) =
  self.enTitle = EnTitle.new(n)

proc setUploadDate*(self: Data, n: string) =
  self.uploadDate = UploadDate.new(n)

proc setLang*(self: Data, n: string) =
  self.lang = Lang.new(n)

proc setThumbnail*(self: Data, n: string) =
  self.thumbnail = Thumbnail.new(n)

proc setArtists*(self: Data, n: seq[string]) =
  self.artists = Artists.new(n)

proc setGroups*(self: Data, n: seq[string]) =
  self.groups = Groups.new(n)

proc setParodies*(self: Data, n: seq[string]) =
  self.parodies = Parodies.new(n)

proc setTags*(self: Data, n: seq[string]) =
  self.tags = Tags.new(n)

proc setImageList*(self: Data, n: seq[string]) =
  self.imageList = ImageList.new(n)
  self.totalPages = len(n)

proc setUrl*(self: Data, n: string) =
  self.url = Url.new(n)
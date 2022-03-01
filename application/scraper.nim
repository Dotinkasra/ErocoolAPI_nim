import
  options,
  httpclient,
  htmlparser,
  xmltree,
  streams,
  ../domain/data_entity,
  ../domain/data_values_infomation

type Scraper* = ref object
  userAgent*: string
  url: string
  data: Data
  xml*: XmlNode

proc new*(
  _: type Scraper,
  ua: string = "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0",
  url: string
): Scraper =
  return Scraper(
    userAgent: ua,
    url: url,
    data: Data.new()
  )

proc download*(
  self: Scraper,
  dlOption: DownloadOption
) =
  echo len(self.data.imageList.value)
  self.data.download(
    dlOption = dlOption
  )

proc genDlOption*(
  self: Scraper,
  absolutePath: string = "./",
  directoryName: string = "",
  start: int = 1,
  last: Option[int] = none(int)
): DownloadOption =
  return DownloadOption(
    absolutePath: absolutePath,
    directoryName: directoryName,
    start: start,
    last: last
  )

proc setXml*(self: Scraper) =
  let client = newHttpClient()
  let response = client.get(self.url)
  self.xml = response.body.newStringStream().parseHtml()

proc setJatitle*(self: Scraper, n: string) =
  self.data.jaTitle = JaTitle.new(n)

proc setEnTitle*(self: Scraper, n: string) =
  self.data.enTitle = EnTitle.new(n)

proc setUploadDate*(self: Scraper, n: string) =
  self.data.uploadDate = UploadDate.new(n)

proc setLang*(self: Scraper, n: string) =
  self.data.lang = Lang.new(n)

proc setThumbnail*(self: Scraper, n: string) =
  self.data.thumbnail = Thumbnail.new(n)

proc setArtists*(self: Scraper, n: seq[string]) =
  self.data.artists = Artists.new(n)

proc setGroups*(self: Scraper, n: seq[string]) =
  self.data.groups = Groups.new(n)

proc setParodies*(self: Scraper, n: seq[string]) =
  self.data.parodies = Parodies.new(n)

proc setTags*(self: Scraper, n: seq[string]) =
  self.data.tags = Tags.new(n)

proc setImageList*(self: Scraper, n: seq[string]) =
  self.data.imageList = ImageList.new(n)
  self.data.totalPages = len(n)

import
  options,
  httpclient,
  htmlparser,
  xmltree,
  streams,
  ../domain/data_entity,
  ../domain/data_values_infomation,
  dougle,
  ehentai,
  nre,
  downloader

type Scraper* = ref object
  userAgent*: string
  url*: string
  xml*: XmlNode

proc new*(
  _: type Scraper,
  ua: string = "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0",
  url: string
): Scraper =
  let client = newHttpClient()
  let response = client.get(url)
  let xml = response.body.newStringStream().parseHtml()
  return Scraper(
    userAgent: ua,
    url: url,
    xml: xml
  )

proc download*(
  self: Scraper,
  data: Data,
  dlOption: DownloadOption
) =
  let dl: Downloader = Downloader.new(data)
  dl.download(dlOption)

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

proc getData*(self: Scraper): Data =
  if self.url.contains(re"""https://dougle\.one/.*"""):
    echo "return Dougle"
    return dougle.extractData(Data.new(), self.xml)
  elif self.url.contains(re"""https://e-hentai\.org.*"""):
    echo "return ehentai"
    return ehentai.extractData(Data.new(), self.xml)

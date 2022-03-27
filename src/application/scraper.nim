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
  nijiero,
  nre,
  downloader

type 
  Scraper* = ref object
    ## An object that analyzes cartoons.
    userAgent*: string
    url*: string
    xml*: XmlNode

proc new*(_: type Scraper, ua: string = "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0", url: string): Scraper
proc download*(self: Scraper, data: Data, dlOption: DownloadOption)
proc genDlOption*(self: Scraper, absolutePath: string = "./", directoryName: string = "", start: int = 1, last: Option[int] = none(int)): DownloadOption
proc getData*(self: Scraper): Data 

template selectData(d: Data, url: string, xml: XmlNode) =
  var instance {.inject.}: Data
  if url.contains(re"""https://dougle\.one/.*"""):
    echo "【Dougle】"
    instance = dougle.extractData(data, xml)
  elif url.contains(re"""https://e-hentai\.org.*"""):
    echo "【ehentai】"
    instance = ehentai.extractData(data, xml)
  elif url.contains(re"""https://erodoujin-search.work/.*"""):
    echo "【nijiero】"
    instance = nijiero.extractData(data, xml)

proc new*(
  _: type Scraper,
  ua: string,
  url: string
): Scraper =
  ## Constructor.
  let 
    client = newHttpClient()
    response = client.get(url)
    xml = response.body.newStringStream().parseHtml()
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
  ## Download the imageList in the Data object of the Scraper object.
  let dl: Downloader = Downloader.new(data)
  dl.download(dlOption)

proc genDlOption*(
  self: Scraper,
  absolutePath: string,
  directoryName: string,
  start: int,
  last: Option[int]
): DownloadOption =
  ## Get options for downloading.
  return DownloadOption(
    absolutePath: absolutePath,
    directoryName: directoryName,
    start: start,
    last: last
  )

proc getData*(self: Scraper): Data =
  ## Obtain the results of parsing the URL cartoon.
  let
    data: Data = Data.new()
  echo "【getData】 : " & self.url 
  data.setUrl(self.url)
  selectData(data, self.url, self.xml)
  return instance

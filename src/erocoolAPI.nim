import
  options,
  strutils,
  json,
  erocoolAPIpkg/application/scraper,
  erocoolAPIpkg/domain/data_entity,
  cligen

type ErocoolAPI* = ref object
  scraper: Scraper
  data: Data

proc newErocoolAPI*(url: string, ua: string = ""): ErocoolAPI
proc reset*(self: ErocoolAPI, url: string)
proc download*(self: ErocoolAPI, start: int = 1, last: int = -1, output: string = "./", name: string = "")
proc getAllInfo*(self: ErocoolAPI): JsonNode
proc getInfoBySpecifyingKey*(self: ErocoolAPI, key: string): JsonNode 

proc getInfoInJsonFormat(self: ErocoolAPI): JsonNode 

proc newScraper(url: string): Scraper
proc newScraper(url: string, ua: string): Scraper 
proc mangaDownload(url: string, start: int = 1, last: int = -1, output: string = "./", name: string = "", ua: string = "")

## ErocoolAPI doc

proc newErocoolAPI*(
  url: string,
  ua: string
): ErocoolAPI =
  ## Obtain a new object.
  let 
    scraper = if ua.isEmptyOrWhitespace: Scraper.new(url = url) else: Scraper.new(ua = ua, url = url)
    data = scraper.getData()
  new result
  result.scraper = scraper
  result.data = data

proc reset*(
  self: ErocoolAPI,
  url: string
) =
  ## Reset the URL of the object.
  self.scraper = Scraper.new(url = url)

proc download*(
  self: ErocoolAPI,
  start: int,
  last: int,
  output: string,
  name: string,
) = 
  ## Download the cartoon at the URL set in the constructor of the Scraper object.
  let 
    lastPageNum: Option[int] = if last > 0: some(last) else: none(int)
    data: Data = self.scraper.getData()

  self.scraper.download(
    data,
    self.scraper.genDlOption(
        start = start,
        last = lastPageNum,
        absolutePath = output,
        directoryName = name
    )
  )

proc getAllInfo*(
  self: ErocoolAPI
): JsonNode =
  ## Obtain all information in JSON format.
  var 
    infomation: JsonNode = self.getInfoInJsonFormat()
  return infomation

proc getInfoBySpecifyingKey*(
  self: ErocoolAPI,
  key: string
): JsonNode =
  ## Obtain information in JSON format by specifying a key.
  var
    infomation: JsonNode = self.getInfoInJsonFormat()
  return infomation{key}

proc getInfoInJsonFormat(
  self: ErocoolAPI
): JsonNode =
  var 
    infomation: JsonNode =
      %* {
        "jaTitle": self.data.getJaTitle(),
        "enTitle": self.data.getEnTitle(),
        "uploadDate": self.data.getUploadDate(),
        "lang": self.data.getLang(),
        "thumbnail": self.data.getThumbnail(),
        "url": self.data.getUrl(),
        "artists": self.data.getArtists(),
        "groups": self.data.getGroups(),
        "parodies": self.data.getParodies(),
        "tags": self.data.getTags(),
        "imageList": self.data.getImageList(),
        "totalPages": self.data.getTotalPages()
      }
  return infomation

proc newScraper(
  url: string
): Scraper =
  ## Obtains a Scraper object without specifying a User Agent.
  return Scraper.new(url = url)

proc newScraper(
  url: string,
  ua: string
): Scraper =
  ## Obtains a Scraper object by specifying a User Agent.
  return Scraper.new(ua = ua, url = url)

proc mangaDownload(
  url: string,
  start: int,
  last: int,
  output: string,
  name: string,
  ua: string
) =
  ## Download the cartoon at the URL set in the constructor of the Scraper object.
  let 
    lastPageNum: Option[int] = if last > 0: some(last) else: none(int)
    scraper = if ua.isEmptyOrWhitespace: newScraper(url = url) else: newScraper(url = url, ua = ua)
    data: Data = scraper.getData()

  scraper.download(
    data,
    scraper.genDlOption(
        start = start,
        last = lastPageNum,
        absolutePath = output,
        directoryName = name
    )
  )

when isMainModule:
  dispatch(
    mangaDownload,
    short = {
      "start": 's',
      "last": 'e',
      "output": 'o',
      "name": 'n',
      "ua": 'u'
    },
    help = {
      "url": "URL of the contents",
      "start": "Specify the first page number to start downloading.",
      "last": "Specify the last page number to finish downloading.",
      "output": "Output directory",
      "name": "Directory name",
      "ua": "User-Agent"
    }
  )
import
  options,
  strutils,
  application/scraper,
  domain/data_entity,
  cligen

proc newScraper*(url: string): Scraper
proc newScraper*(url: string, ua: string): Scraper 
proc mangaDownload(url: string, start: int = 1, last: int = -1, output: string = "./", name: string = "", ua: string = "")

## ErocoolAPI doc
proc newScraper*(
  url: string
): Scraper =
  ## Obtains a Scraper object without specifying a User Agent.
  return Scraper.new(url = url)

proc newScraper*(
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
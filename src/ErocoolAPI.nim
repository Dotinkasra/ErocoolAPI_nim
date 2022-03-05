import
  options,
  application/scraper,
  domain/data_entity,
  cligen

proc newScraper*(
  url: string
): Scraper =
  return Scraper.new(url = url)

proc newScraperWithUa*(
  url: string,
  ua: string
): Scraper =
  return Scraper.new(ua = ua, url = url)

proc mangaDownload(
  url: string,
  start: int = 1,
  last: int = -1,
  output: string = "./",
  name: string = ""
) =
  let 
    lastPageNum: Option[int] = if last > 0: some(last) else: none(int)
    scraper = Scraper.new(url = url)
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
      "name": 'n'
    },
    help = {
      "url": "URL of the contents",
      "start": "Specify the first page number to start downloading.",
      "last": "Specify the last page number to finish downloading.",
      "output": "Output directory",
      "name": "Directory name"
    }
  )
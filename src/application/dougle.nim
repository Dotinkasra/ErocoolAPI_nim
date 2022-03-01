import 
  future,
  options,
  xmltree,
  strutils,
  nimquery,
  ../domain/data_entity,
  ../domain/data_values_infomation,
  ./scraper

type Dougle* = ref object
  scraper: Scraper

proc new*(
  _: type Dougle,
  url: string
): Dougle =
  return Dougle(scraper: Scraper.new(url = url))

proc download*(
  self: Dougle,
  dlOption: DownloadOption
) = 
  self.scraper.download(
    dlOption = dlOption
  )

proc genDlOption*(
  self: Dougle,
  absolutePath: string = "./",
  directoryName: string = "",
  start: int = 1,
  last: Option[int] = none(int)
): DownloadOption =
  return self.scraper.genDlOption(
    absolutePath = absolutePath,
    directoryName = directoryName,
    start = start,
    last = last
  )

proc setXml*(self: Dougle) =
  self.scraper.setXml()

proc extractData*(self: Dougle) =
  self.scraper.setJatitle(
    querySelectorAll(
      self.scraper.xml, "[class=\"single-post-title entry-title\"]"
    )[0].innerText
  )
  
  let tagArea = querySelectorAll(self.scraper.xml, "[class=\"tag_area\"]")
  if len(tagArea) == 2:
    let artistsDiv: seq[string] = collect(newSeq):
        for item in tagArea[0]: item.innerText
    let tagsDiv: seq[string] = collect(newSeq):
        for item in tagArea[1]: item.innerText

    self.scraper.setArtists(artistsDiv)
    self.scraper.setTags(tagsDiv)
  
  let content = querySelectorAll(self.scraper.xml, "div.content > a")
  var imgList: seq[string] = newSeq[string](len(content))
  echo "作成直後:" & $len(imgList)
  for i, c in content:
    echo i
    let href = c.attr("href")
    if not href.isEmptyOrWhitespace(): imgList[i] = c.attr("href")
  if len(imgList) > 0:
    self.scraper.setImageList(imgList)

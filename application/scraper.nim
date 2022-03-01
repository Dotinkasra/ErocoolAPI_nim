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
  url*: string
  data*: Data
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

proc setXml*(self: Scraper) =
  let client = newHttpClient()
  let response = client.get(self.url)
  self.xml = response.body.newStringStream().parseHtml()
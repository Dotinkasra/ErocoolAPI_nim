import 
  xmltree,
  nimquery,
  nre,
  htmlparser,
  asyncdispatch,
  threadpool,
  streams,
  strutils,
  httpclient,
  ../domain/data_entity

proc extractData*(data: Data, xml: XmlNode): Data
proc getImageLink(viewerUrl: string): Future[string] {.async,thread.}
proc loopHandle(viewerUrl: string): string 

proc extractData*(data: Data, xml: XmlNode): Data =
  echo "【IMHentai】extractData : start"

  let 
    urlDomain: string = "https://imhentai.xxx"
    firstPageUrl: string = urlDomain & xml
      .querySelector("div.row.gallery_first")
      .findAll("a")[0]
      .attr("href")

    viewerUrl: string = firstPageUrl
      .find(re"""(^https://imhentai\.xxx/view/\d+/).*/""")
      .get
      .captures[0]

    totalPages:int = xml
      .querySelector("#load_pages")
      .attr("value")
      .parseInt
    
  var 
    thredsProcList = newSeq[FlowVar[string]]()
    imageList = newSeq[string]()


  for i in 1..totalPages:
    thredsProcList.add(spawn loopHandle(viewerUrl & $i & "/"))
  sync()

  for result in thredsProcList:
    imageList.add(^result)
  data.setImageList(imageList)
  echo "【IMHentai】extractData : end"
  return data

proc loopHandle(viewerUrl: string): string =
  let imgLink: string = waitFor getImageLink(viewerUrl)
  return imgLink

proc getImageLink(viewerUrl: string): Future[string] {.async.} =
  let
    client = newAsyncHttpClient()
    body = await client.getContent(viewerUrl)
    imageSrc = body
      .newStringStream()
      .parseHtml()
      .querySelector("#gimg")
      .attr("data-src") 
  if imageSrc.isEmptyOrWhitespace: return ""
  return imageSrc
import 
  xmltree,
  nimquery,
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
  data.setJatitle(
    findAll(xml, "h2")[0]
    .innerText
  )

  data.setEntitle(
    findAll(xml, "h1")[0]
    .innerText
  )

  let 
    urlDomain: string = "https://okhentai.net"
    linkList = xml.querySelector("#list_pages").findAll("div")
    
  var 
    thredsProcList = newSeq[FlowVar[string]]()
    imageList = newSeq[string]()
  
  for i in linkList:
    if i.findAll("div").len == 0:
      continue

    thredsProcList.add(
      spawn loopHandle(
        urlDomain & i
          .findAll("div")[0]
          .findAll("a")[0]
          .attr("href")
      )
    )
  sync()

  for result in thredsProcList:
    imageList.add(urlDomain & ^result)
    echo urlDomain & ^result
  data.setImageList(imageList)

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
      .attr("src") 
  client.close()
  if imageSrc.isEmptyOrWhitespace: return ""
  return imageSrc
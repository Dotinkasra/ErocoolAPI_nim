import 
  xmltree,
  strutils,
  nimquery,
  htmlparser,
  streams,
  asyncdispatch,
  httpclient,
  nre,
  sequtils,
  ../domain/data_entity

proc getViewerLink(url: string): Future[seq[string]] {.async.} 
proc getImageLink(url: string): Future[string] {.async.} 
proc loopHandle(allPages: XmlNode): Future[seq[string]] {.async.} 
proc extractData*(data: Data, xml: XmlNode): Data 

proc getViewerLink(url: string): Future[seq[string]] {.async.} =
  let 
    content = newHttpClient().get(url)
    xml = content.body.newStringStream().parseHtml()
    imagePageDiv = xml.querySelectorAll("div.gdtm")
  var 
    retFuture = newFuture[seq[string]]("connect")
    linkList: seq[string] = newSeq[string]()
  
  for page in imagePageDiv:
    let link = page.querySelectorAll("a")
    if len(link) == 0:
      continue
    linkList.add(link[0].attr("href"))
  retFuture.complete(linkList)
  return linkList

proc getImageLink(url: string): Future[string] {.async.} =
  let
    content = newHttpClient().get(url)
    xml = content.body.newStringStream().parseHtml()
    imageTag = xml.querySelector("#img").attr("src")
  return imageTag

proc loopHandle(allPages: XmlNode): Future[seq[string]] {.async.} =
  var 
    results = newSeq[string]()
    previwLinks = newSeq[string]()
    imgLinks = newSeq[string]()
    previwGetEvents = newSeq[Future[seq[string]]]()
    imgGetEvents = newSeq[Future[string]]()

  for page in allPages:
    let aLink = page.querySelectorAll("a")
    if len(aLink) == 0:
      continue
    previwLinks.add(aLink[0].attr("href"))
  
  for link in previwLinks.deduplicate:
    previwGetEvents.add(getViewerLink(link))

  var previwResult = await all(previwGetEvents)

  for r in previwResult:
    results &= r
  
  for previwLink in results:
    imgGetEvents.add(getImageLink(previwLink))
  
  var imgResult = await all(imgGetEvents)
  for r in imgResult:
    if not r.isEmptyOrWhitespace():
      imgLinks.add(r)
  
  return imgLinks

proc extractData*(data: Data, xml: XmlNode): Data =
  data.setJatitle(
    querySelectorAll(xml, "#gn")[0]
    .innerText
  )

  data.setThumbnail(
    xml
    .querySelector("#gd1 > div")
    .attr("style")
    .find(re""".*url\((https://.*)\)""")
    .get.captures[0]
  )

  for row in xml.querySelector("#gdd > table").querySelectorAll("tr"):
    var info: string = row.querySelectorAll("td")[0].innerText
    case info
    of "Posted:":
      data.setUploadDate(info)
    of "Language:":
      data.setLang(info)
  let allPages = xml.querySelector("body > div:nth-child(9) > table").querySelectorAll("tr")[0]
  let imgLinks: seq[string] = waitFor loopHandle(allPages = allPages)
  data.setImageList(imgLinks)

  return data


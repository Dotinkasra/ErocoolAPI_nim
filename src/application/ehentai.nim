import 
  xmltree,
  strutils,
  nimquery,
  htmlparser,
  asyncdispatch,
  streams,
  httpclient,
  threadpool,
  nre,
  ../domain/data_entity

proc getImageLink(url: string): Future[seq[string]] {.async.}
proc loopHandle(allPages: XmlNode): seq[string]
proc extractData*(data: Data, xml: XmlNode): Data 
proc loopExecuter(link: string): seq[string] {.thread.}

proc getImageLink(url: string): Future[seq[string]] {.async.} =
  echo "getImageLink"
  let 
    client = newAsyncHttpClient()
    body = await client.getContent(url)
    xml = body.newStringStream().parseHtml()
    imagePageDiv = xml.querySelectorAll("div.gdtm")
  var 
    linkList: seq[string] = newSeq[string]()
  
  for page in imagePageDiv:
    let link = page.querySelectorAll("a")
    if len(link) == 0:
      continue
    let linkContent = await newAsyncHttpClient().getContent(link[0].attr("href"))
    linkList.add(
      linkContent
      .newStringStream().parseHtml()
      .querySelector("#img").attr("src")
    )
  return linkList

proc loopHandle(allPages: XmlNode): seq[string] =
  echo "loophandle"
  var 
    #previwLinks = newSeq[string]()
    resultSeq = newSeq[FlowVar[seq[string]]]()
    imgLinks = newSeq[string]()
    #handle = newSeq[seq[string]]()
  for page in allPages:
    let aLink = page.querySelectorAll("a")
    if len(aLink) == 0:
      continue
    resultSeq.add(spawn loopExecuter(aLink[0].attr("href")))
  sync()

  for result in resultSeq:
    for img in ^result:
      echo img
      imgLinks.add(img)
  return imgLinks
  
proc loopExecuter(link: string): seq[string] =
  echo "loopExecuter"
  var
    imgLinks = newSeq[string]()
  let 
    results = waitFor getImageLink(link)
  for img in results:
    if not img.isEmptyOrWhitespace:
      imgLinks.add(img)
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
  let imgLinks: seq[string] = loopHandle(allPages = allPages)
  data.setImageList(imgLinks)

  return data


import 
  xmltree,
  strutils,
  nimquery,
  htmlparser,
  asyncdispatch,
  streams,
  httpclient,
  sequtils,
  threadpool,
  nre,
  ../domain/data_entity

proc getImageLink(url: string): Future[seq[string]] {.async.}
proc loopHandle(allPages: XmlNode): seq[string]
proc extractData*(data: Data, xml: XmlNode): Data 
proc loopExecuter(link: string): seq[string] {.thread.}

proc getImageLink(url: string): Future[seq[string]] {.async.} =
  echo "【e-hentai】getImageLink : " & url
  let 
    client = newAsyncHttpClient()
    body = await client.getContent(url)
    xml = body.newStringStream().parseHtml()
    imagePageDiv = xml.querySelectorAll("div.gdtm")
  var 
    linkList: seq[string] = newSeq[string]()
  
  for page in imagePageDiv:
    let link = page.querySelectorAll("a")
    if len(link) == 0: continue
    let linkContent = await client.getContent(link[0].attr("href"))
    linkList.add(
      linkContent
      .newStringStream().parseHtml()
      .querySelector("#img").attr("src")
    )
    client.close()
  return linkList

proc loopHandle(allPages: XmlNode): seq[string] =
  echo "【e-hentai】loopHandle"
  var 
    resultSeq = newSeq[FlowVar[seq[string]]]()
    imgLinks = newSeq[string]()
    viewerLinks = newSeq[string]()

  for page in allPages:
    let aLink = page.querySelectorAll("a")
    if len(aLink) == 0: continue
    if aLink[0].attr("href").isEmptyOrWhitespace: continue
    viewerLinks.add(aLink[0].attr("href"))

  for viewer in viewerLinks.deduplicate:
    resultSeq.add(spawn loopExecuter(viewer))
  sync()

  for result in resultSeq:
    for img in ^result:
      if img.isEmptyOrWhitespace: continue
      imgLinks.add(img)
  return imgLinks
  
proc loopExecuter(link: string): seq[string] =
  echo "【e-hentai】loopExecuter : start"
  var
    imgLinks = newSeq[string]()
  let 
    results = waitFor getImageLink(link)
  for img in results:
    if img.isEmptyOrWhitespace: continue
    imgLinks.add(img)
  return imgLinks

proc extractData*(data: Data, xml: XmlNode): Data =
  echo "【e-hentai】extractData : start"
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
  echo "【e-hentai】extractData : end"
  return data


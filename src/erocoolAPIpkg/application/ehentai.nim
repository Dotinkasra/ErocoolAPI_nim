import 
  xmltree,
  strutils,
  strformat,
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
proc loopHandle(xml: XmlNode): seq[string]
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
  echo "【e-hentai】getImageLink : end"
  return linkList

proc loopHandle(xml: XmlNode): seq[string] =
  echo "【e-hentai】loopHandle"
  var 
    resultSeq = newSeq[FlowVar[seq[string]]]()
    imgLinks = newSeq[string]()
    viewerLinks = newSeq[string]()
  let
    tds: seq[XmlNode] = xml.querySelector("body > div:nth-child(9) > table").querySelectorAll("tr")[0].querySelectorAll("td")
    baseLink: string = tds[1].querySelectorAll("a")[0].attr("href")
    lastPageLink: string = tds[tds.len - 2].querySelectorAll("a")[0].attr("href")
    lastPage = lastPageLink.find(re"""https://e-hentai\.org/g/.*/?p=(\d+)""")
    #finalNum: int = final.find(re(pettern)).get.captures[0].parseInt
  viewerLinks.add(baseLink)

  if lastPage.isSome() and len(lastPage.get.captures.toSeq()) >= 1: 
    let 
      lastPageNum: int = lastPage.get.captures[0].parseInt
    if lastPageNum == 1:
      viewerLinks.add(baseLink & "?p=1")
    else:
      for i in 1..lastPageNum:
        viewerLinks.add(baseLink & fmt"?p={i}")
  echo viewerLinks

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
  echo "【e-hentai】loopExecuter : end"
  return imgLinks

proc extractData*(data: Data, xml: XmlNode): Data =
  echo "【e-hentai】extractData : start"
  data.setJatitle(
    querySelectorAll(xml, "#gj")[0]
    .innerText
  )

  data.setEntitle(
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
  #let allPages = xml.querySelector("body > div:nth-child(9) > table").querySelectorAll("tr")[0]
  let imgLinks: seq[string] = loopHandle(xml = xml)
  data.setImageList(imgLinks)
  echo "【e-hentai】extractData : end"
  return data


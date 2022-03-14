import 
  xmltree,
  strutils,
  nimquery,
  htmlparser,
  streams,
  httpclient,
  threadpool,
  nre,
  sequtils,
  ../domain/data_entity

proc getImageLink(url: string): seq[string]  
proc loopHandle(allPages: XmlNode): seq[string]
proc extractData*(data: Data, xml: XmlNode): Data 

proc getImageLink(url: string): seq[string] =
  let 
    content = newHttpClient().get(url)
    xml = content.body.newStringStream().parseHtml()
    imagePageDiv = xml.querySelectorAll("div.gdtm")
  var 
    linkList: seq[string] = newSeq[string]()
  
  for page in imagePageDiv:
    let link = page.querySelectorAll("a")
    if len(link) == 0:
      continue
    linkList.add(
      newHttpClient()
      .get(link[0].attr("href"))
      .body.newStringStream().parseHtml()
      .querySelector("#img").attr("src")
    )
  return linkList

proc loopHandle(allPages: XmlNode): seq[string] =
  var 
    previwLinks = newSeq[string]()
    imgLinks = newSeq[string]()

  for page in allPages:
    let aLink = page.querySelectorAll("a")
    if len(aLink) == 0:
      continue
    previwLinks.add(aLink[0].attr("href"))
  
  for link in previwLinks.deduplicate:
    var thread = spawn getImageLink(link)
    for img in ^thread:
      if not img.isEmptyOrWhitespace:
        imgLinks.add(img)
  sync()
  
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


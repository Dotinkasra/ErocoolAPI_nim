import 
  xmltree,
  nimquery,
  logging,
  ../domain/data_entity

proc extractData*(data: Data, xml: XmlNode): Data
proc extractJatitle(xml: XmlNode): string
proc extractImageList(xml: XmlNode): seq[string]

proc extractData*(data: Data, xml: XmlNode): Data =
  data.apiLog.log(lvlDebug, "【kemono】extractData : start")

  data.setJatitle(
    extractJatitle(xml)
  )

  data.setImageList(
    extractImageList(xml)
  )
  return data

proc extractJatitle(xml: XmlNode): string =
  var
    title: string
    postTitleSpan = querySelectorAll(xml, ".post__title")[0].findAll("span")

  for span in postTitleSpan:
    title = title & span.innerText
  return title

proc extractImageList(xml: XmlNode): seq[string] =
  var 
    imgList: seq[string] = newSeq[string]()

  let 
    posts = xml.querySelectorAll(".post__files")[0].querySelectorAll(".post__thumbnail")
  
  for p in posts:
    let
      a = p.querySelector(".post__thumbnail").findAll("a")
    for link in a:
      imgList.add("https://kemono.party" & link.attr("href"))
  return imgList


import 
  xmltree,
  nimquery,
  sequtils,
  nre,
  ../domain/data_entity

proc extractData*(data: Data, xml: XmlNode): Data

proc extractData*(data: Data, xml: XmlNode): Data =
  data.setJatitle(
    querySelectorAll(
      xml, "head > title"
    )[0].innerText
  )
  
  let 
    article: seq[XmlNode] = querySelectorAll(xml, "article.article")[0].querySelectorAll("img")
    root: string = find(data.getUrl, re"""(https?://[^/]+/)""").get.captures[0]
  var 
    imgList: seq[string] = newSeq[string]()

  for c in article:
    let href = c.attr("src")
    if href.contains(re"""http.?://.*"""):
      imgList.add(href)
    else:
      imgList.add(root & href)
  if len(imgList) > 0:
    data.setImageList(imgList.deduplicate)
  return data
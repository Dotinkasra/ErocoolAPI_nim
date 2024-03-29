import 
  sugar,
  xmltree,
  strutils,
  nimquery,
  logging,
  ../domain/data_entity

proc extractData*(data: Data, xml: XmlNode): Data

proc extractData*(data: Data, xml: XmlNode): Data =
  data.apiLog.log(lvlDebug, "【dougle】extractData : start")

  data.setJatitle(
    querySelectorAll(
      xml, "[class=\"single-post-title entry-title\"]"
    )[0].innerText
  )
  
  let tagArea = querySelectorAll(xml, "[class=\"tag_area\"]")
  if len(tagArea) == 2:
    let artistsDiv: seq[string] = collect(newSeq):
        for item in tagArea[0]: item.innerText
    let tagsDiv: seq[string] = collect(newSeq):
        for item in tagArea[1]: item.innerText

    data.setArtists(artistsDiv)
    data.setTags(tagsDiv)
  
  let content = querySelectorAll(xml, "div.content > a")
  var imgList: seq[string] = newSeq[string](len(content))
  for i, c in content:
    let href = c.attr("href")
    if not href.isEmptyOrWhitespace(): imgList[i] = c.attr("href")
  if len(imgList) > 0:
    data.setImageList(imgList)
  data.apiLog.log(lvlDebug, "【dougle】extractData : end")
  return data

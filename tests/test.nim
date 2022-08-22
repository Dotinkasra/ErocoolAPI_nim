import
    unittest, 
    json,
    strutils,
    ../src/erocoolAPI

test "dougle_test":
  let 
    erocool: ErocoolAPI = newErocoolAPI("https://dougle.one/archives/87461")
    info: JsonNode = erocool.getAllInfo()
    jaTitle: string = $info{"jaTitle"}
    imageList: seq[string] = split($info{"imageList"}, ",")
  echo jaTitle
  echo imageList
  check(jaTitle != "")
  check(len(imageList) > 0)
    
test "nijiero_test":
  let 
    erocool: ErocoolAPI = newErocoolAPI("https://erodoujin-search.work/2022/02/02/post-0-1358/")
    info: JsonNode = erocool.getAllInfo()
    jaTitle: string = $info{"jaTitle"}
    imageList: seq[string] = split($info{"imageList"}, ",")
  echo jaTitle
  echo imageList
  check(jaTitle != "")
  check(len(imageList) > 0)

test "download":
  let
    erocool: ErocoolAPI = newErocoolAPI("https://dougle.one/archives/87461")
  erocool.download()

test "json":
  let 
    erocool: ErocoolAPI = newErocoolAPI("https://e-hentai.org/g/2176194/0fe559b270/")
  echo erocool.getAllInfo()

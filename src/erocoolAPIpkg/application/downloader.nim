import
  options,
  httpclient,
  asyncfile,
  os,
  nre,
  asyncdispatch,
  threadpool,
  strutils,
  logging,
  random,
  ../domain/data_entity,
  ../domain/data_values_infomation

type Downloader* = ref object
 data*: Data

proc new*(_: type Downloader, data: Data): Downloader
proc download*(self: Downloader, dlOption: DownloadOption)
proc asyncRequest(self: Downloader, url: string, pathWithImgname: string): Future[bool] {.async,thread.}
proc loopHandle(self: Downloader, url: string, pathWithImgname: string): bool 

proc new*(_: type Downloader, data: Data): Downloader =
  return Downloader(data: data)

proc asyncRequest(self: Downloader, url: string, pathWithImgname: string): Future[bool] {.async,thread.} =
  self.data.apiLog.log(lvlDebug, "【downloader】asyncRequest : " & url)
  let 
    client = newHttpClient()
    f = openAsync(pathWithImgname, FileMode.fmWrite)
  try:
    let 
      img = client.getContent(url)
    client.close()
    await f.write(img)

    self.data.apiLog.log(lvlDebug, "【downloader】asyncRequest : Save Complete " & pathWithImgname)
    return true
  except:
    self.data.apiLog.log(lvlError, "【downloader】Download error!\n" & getCurrentExceptionMsg())
    return false
  finally:
    f.close()

proc loopHandle(self: Downloader, url: string, pathWithImgname: string): bool =
  return waitFor self.asyncRequest(url, pathWithImgname)

proc download*(self: Downloader, dlOption: DownloadOption) =
  let 
    absolutePath: string = dlOption.absolutePath
    directoryName: string = dlOption.directoryName
    start: int = dlOption.start
    last: int = if dlOption.last.isSome: dlOption.last.get() else: self.data.getTotalPages()

    path: string = if absolutePath != "./": absolutePath else: "./"
    name: string = 
      if directoryName != "":
        directoryName 
      else:
        if (self.data.getJaTitle() == "") and (self.data.getEnTitle() == ""):
          intToStr(rand(int.high)) 
        elif (self.data.getJaTitle() != ""):
          self.data.getJaTitle()
        else:
          self.data.getEnTitle()
          
    saveDir: string = os.joinPath(path, name)

    imageList: seq[string] = self.data.getImageList()

  self.data.apiLog.log(lvlDebug, "【downloader】options : start = " & $start & " end = " & $last & " path = " & saveDir)

  var
    thredsProcList = newSeq[FlowVar[bool]]()

  if not saveDir.dirExists:
    os.createDir(saveDir)

  var index: int = 1
  echo repr(imageList)
  for i in start - 1..last - 1:
    try:
      if imageList[i].isEmptyOrWhitespace: continue
    except:
      self.data.apiLog.log(lvlError,  "Error!\n" & getCurrentExceptionMsg())
      continue
    let 
      urlInFilename: Option[nre.RegexMatch] = imageList[i].find(re"""https?://.*/(.*jpg|.*png|.*webp|.*gif|.*avif).*""")
    if urlInFilename.isNone() or len(urlInFilename.get.captures.toSeq()) == 0: continue

    let 
      fileName: string = "hcooldl_" & $index & "_" & urlInFilename.get.captures[0]
    var
      pathWithImgname: string =  os.joinPath(saveDir, fileName)
    if fileName.isEmptyOrWhitespace: continue
    if os.fileExists(pathWithImgname): 
      pathWithImgname = os.joinPath(saveDir, $i & fileName)

    inc index
    self.data.apiLog.log(lvlDebug, "【downloader】" & $(i + 1) & " : " & fileName)
    thredsProcList.add(
      spawn self.loopHandle(url = imageList[i], pathWithImgname = pathWithImgname)
    )

  sync()
  self.data.apiLog.log(lvlInfo, saveDir)
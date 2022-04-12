import
  options,
  httpclient,
  asyncfile,
  os,
  nre,
  asyncdispatch,
  threadpool,
  strutils,
  ../domain/data_entity,
  ../domain/data_values_infomation

type Downloader* = ref object
 data*: Data

proc new*(_: type Downloader, data: Data): Downloader
proc download*(self: Downloader, dlOption: DownloadOption)
proc asyncRequest(self: Downloader, url: string, pathWithImgname: string) {.async.}

proc new*(_: type Downloader, data: Data): Downloader =
  return Downloader(data: data)

proc asyncRequest(self: Downloader, url: string, pathWithImgname: string) {.async.} =
  echo "【downloader】asyncRequest : " & url
  let 
    client = newHttpClient()
    img = client.getContent(url)
  echo "【downloader】asyncRequest : Complete " & pathWithImgname 
  client.close()
  let 
    f = openAsync(pathWithImgname, FileMode.fmWrite)
  try:
    await f.write(img)
    echo "【downloader】asyncRequest : Save Complate "
  except:
    echo "【downloader】Download error!"
  finally:
    f.close()

proc download*(self: Downloader, dlOption: DownloadOption) =
  let 
    absolutePath: string = dlOption.absolutePath
    directoryName: string = dlOption.directoryName
    start: int = dlOption.start
    last = if dlOption.last.isSome: dlOption.last.get() else: self.data.getTotalPages()

    path: string = if absolutePath != "./": absolutePath else: "./"
    name: string = if directoryName != "": directoryName else: self.data.getJaTitle()
    saveDir: string = os.joinPath(path, name)

    imageList: seq[string] = self.data.getImageList()

  echo "【downloader】options : start = " & $start & " end = " & $last & " path = " & saveDir

  if not saveDir.dirExists:
    os.createDir(saveDir)

  var index: int = 1
  for i in start - 1..last - 1:
    try:
      if imageList[i].isEmptyOrWhitespace: continue
    except:
      echo "Error!"
      continue
    let 
      urlInFilename: Option[nre.RegexMatch] = imageList[i].find(re"""https?://.*/(.*jpg|.*png).*""")
    if urlInFilename.isNone() or len(urlInFilename.get.captures.toSeq()) == 0: continue

    let 
      fileName: string = "hcooldl_" & $index & "_" & urlInFilename.get.captures[0]
    var
      pathWithImgname: string =  os.joinPath(saveDir, fileName)
    if fileName.isEmptyOrWhitespace: continue
    if os.fileExists(pathWithImgname): 
      pathWithImgname = os.joinPath(saveDir, $i & fileName)

    inc index
    echo "【downloader】" & $(i + 1) & " : " & fileName
    discard spawn self.asyncRequest(url = imageList[i], pathWithImgname = pathWithImgname)
  sync()
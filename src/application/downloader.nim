import
  options,
  httpclient,
  asyncfile,
  os,
  nre,
  asyncdispatch,
  threadpool,
  ../domain/data_entity,
  ../domain/data_values_infomation

type Downloader* = ref object
 data*: Data
 
proc new*(_: type Downloader, data: Data): Downloader
proc asyncRequest(self: Downloader, url: string, pathWithImgname: string) {.async.}
proc download*(self: Downloader, dlOption: DownloadOption)

proc new*(_: type Downloader, data: Data): Downloader =
  return Downloader(data: data)

proc asyncRequest(self: Downloader, url: string, pathWithImgname: string) {.async.} =
  let 
    img = newHttpClient().getContent(url)
    f = openAsync(pathWithImgname, FileMode.fmWrite)
  try:
    await f.write(img)
    close(f)
  except IOError:
    echo "IO error!"

proc download*(self: Downloader, dlOption: DownloadOption) =
  let 
    absolutePath: string = dlOption.absolutePath
    directoryName: string = dlOption.directoryName
    start: int = dlOption.start
    last = if dlOption.last.isSome: dlOption.last.get() else: self.data.totalPages
 
    path: string = if absolutePath != "./": absolutePath else: "./"
    name: string = if directoryName != "": directoryName else: self.data.jaTitle.`$`
    saveDir: string = os.joinPath(path, name)

  if not saveDir.dirExists:
    os.createDir(saveDir)

  for i in start - 1..last - 1:
    let urlInFilename: Option[nre.RegexMatch] = self.data.imageList.value[i].find(re"""https?://.*/(.*jpg|.*png).*""")
    if urlInFilename.isSome():
      if len(urlInFilename.get.captures.toSeq()) > 0:
        let 
          fileName: string = "hcooldl_" & urlInFilename.get.captures[0]
          v = spawn self.asyncRequest(url = self.data.imageList.value[i], pathWithImgname = os.joinPath(saveDir, fileName))
  sync()
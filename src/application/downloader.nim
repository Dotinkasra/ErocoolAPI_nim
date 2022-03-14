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
proc download*(self: Downloader, dlOption: DownloadOption)
proc asyncRequest(self: Downloader, url: string, pathWithImgname: string) {.async.}

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
    last = if dlOption.last.isSome: dlOption.last.get() else: self.data.getTotalPages()
 
    path: string = if absolutePath != "./": absolutePath else: "./"
    name: string = if directoryName != "": directoryName else: self.data.getJaTitle()
    saveDir: string = os.joinPath(path, name)

  if not saveDir.dirExists:
    os.createDir(saveDir)

  for i in start - 1..last - 1:
    let urlInFilename: Option[nre.RegexMatch] = self.data.getImageList()[i].find(re"""https?://.*/(.*jpg|.*png).*""")
    if urlInFilename.isSome():
      if len(urlInFilename.get.captures.toSeq()) > 0:
        let 
          fileName: string = "hcooldl_" & urlInFilename.get.captures[0]
        discard spawn self.asyncRequest(url = self.data.getImageList()[i], pathWithImgname = os.joinPath(saveDir, fileName))
  sync()
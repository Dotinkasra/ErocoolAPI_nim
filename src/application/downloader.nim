import
  options,
  puppy,
  asyncfile,
  os,
  nre,
  asyncdispatch,
  threadpool,
  ../domain/data_entity,
  ../domain/data_values_infomation

type Downloader* = ref object
 data*: Data

proc new*(_: type Downloader, data: Data): Downloader =
  return Downloader(data: data)

proc asyncRequest(self: Downloader, url: string, pathWithImgname: string) {.async.} =
  let 
    img = fetch(
      url,
      headers = @[Header(key: "User-Agent", value: "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0")]
    )
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
    #let img = await newAsyncHttpClient().getContent(self.imageList.value[i])
    let urlInFilename: RegexMatch = self.data.imageList.value[i].find(re"""http.://.*/(.*|.*png)""").get
    if len(urlInFilename.captures.toSeq()) > 0:
      let 
        fileName: string = "hcooldl_" & urlInFilename.captures[0]
        v = spawn self.asyncRequest(url = self.data.imageList.value[i], pathWithImgname = os.joinPath(saveDir, fileName))
  sync()
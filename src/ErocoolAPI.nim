import
  options,
  application/dougle,
  cligen,
  nre

proc optionParser(
  url: string,
  start: int = 1,
  last: int = -1,
  output: string = "./",
  name: string = "",
  args: seq[string]
) =
  let lastPageNum: Option[int] = if last > 0: some(last) else: none(int)
  if url.contains(re"""https://dougle\.one/.*"""):
    let d = Dougle.new(
      url = url
    )
    d.setXml()
    d.extractData()
    d.download(
      d.genDlOption(
        start = start,
        last = lastPageNum,
        absolutePath = output,
        directoryName = name
      )
    )
  else:
    echo "no..."

proc main() =
  dispatch(
    optionParser,
    short = {
      "start": 's',
      "last": 'e',
      "output": 'o',
      "name": 'n'
    },
    help = {
      "url": "URL of the contents",
      "start": "Specify the first page number to start downloading.",
      "last": "Specify the last page number to finish downloading.",
      "output": "Output directory",
      "name": "Directory name"
    }
  )

when isMainModule:
  main()
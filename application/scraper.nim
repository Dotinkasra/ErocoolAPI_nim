import
  ../domain/data_entity,
  ../domain/data_values_infomation

type Scraper* = ref object
  userAgent: string
  data: Data

proc download*(
  d: Data, 
  absolutePath: string, 
  directoryName: string, 
  start: int = 1, 
  last: int
) =
  echo 'a'
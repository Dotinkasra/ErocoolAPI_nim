import
    unittest, 
    ../src/erocoolAPI,
    ../src/application/scraper,
    ../src/domain/data_entity

test "dougle_test":
    let 
        erocool: Scraper = newScraper("https://dougle.one/archives/87461")
        data: Data = erocool.getData()
        jaTitle: string = data.getJaTitle()
        imageList: seq[string] = data.getImageList()
    echo jaTitle
    echo imageList
    check(jaTitle != "")
    check(len(imageList) > 0)
    
test "ehentai_test":
    let 
        erocool: Scraper = newScraper("https://e-hentai.org/g/2159705/f328758fd3/")
        data: Data = erocool.getData()
        jaTitle: string = data.getJaTitle()
        imageList: seq[string] = data.getImageList()
    echo jaTitle
    echo imageList
    check(jaTitle != "")
    check(len(imageList) > 0)

test "nijiero_test":
    let 
        erocool: Scraper = newScraper("https://erodoujin-search.work/2022/02/02/post-0-1358/")
        data: Data = erocool.getData()
        jaTitle: string = data.getJaTitle()
        imageList: seq[string] = data.getImageList()
    echo jaTitle
    echo imageList
    check(jaTitle != "")
    check(len(imageList) > 0)
import
    unittest, 
    ../src/erocoolAPI,
    ../src/application/scraper,
    ../src/domain/data_entity,
    ../src/domain/data_values_infomation

test "dougle_test":
    let erocool = newScraper("https://dougle.one/archives/87461")
    let data = erocool.getData()
    echo data.jaTitle
    echo data.imageList.value
    check(data.jaTitle.`$` != "")
    check(len(data.imageList.value) > 0)
    
test "ehentai_test":
    let erocool = newScraper("https://e-hentai.org/g/2159705/f328758fd3/")
    let data = erocool.getData()
    echo data.jaTitle
    echo data.imageList.value
    check(data.jaTitle.`$` != "")
    check(len(data.imageList.value) > 0)
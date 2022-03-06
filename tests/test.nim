import
    unittest, 
    ../src/erocoolAPI,
    ../src/application/scraper

test "dougle_test":
    let erocool = newScraper("https://dougle.one/archives/87461")
    discard erocool.getData()
    
test "ehentai_test":
    let erocool = newScraper("https://e-hentai.org/g/2159705/f328758fd3/")
    discard erocool.getData()
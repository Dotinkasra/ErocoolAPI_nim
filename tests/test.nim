import
    unittest, 
    ../src/erocoolAPI,
    ../src/application/scraper,
    ../src/domain/data_values_infomation,
    options

test "test_1":
    #let erocool = newScraper("https://dougle.one/archives/89592")
    let erocool = newScraper("https://e-hentai.org/g/2157949/3727e6562f/")
    let data = erocool.getData()
    #erocool.download(data, erocool.genDlOption())
    


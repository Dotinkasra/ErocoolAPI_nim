import
    unittest, 
    ../src/ErocoolApi

test "test_1":
    let module = Main.new()
    check module.download(url = "https://dougle.one/archives/87200")
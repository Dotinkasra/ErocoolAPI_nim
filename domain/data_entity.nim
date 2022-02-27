import 
    data_values_infomation

type Data* = ref object
    jaTitle: JaTitle
    enTitle: EnTitle
    uploadDat: UploadDat
    lang: Lang
    thumbnail: Thumbnail
    url: Url
    artists: Artists
    groups: Groups
    parodies: Parodies
    tags: Tags
    imageList: ImageList
    totalPages: TotalPages

proc new*(
    _:type Data,
    jaTitle: JaTitle,
    enTitle: EnTitle,
    uploadDat: UploadDat,
    lang: Lang,
    thumbnail: Thumbnail,
    url: Url,
    artists: Artists,
    groups: Groups,
    parodies: Groups,
    tags: Tags,
    imageList: ImageList
): Data =
    return Data(
        jaTitle: JaTitle,
        enTitle: EnTitle,
        uploadDat: UploadDat,
        lang: Lang,
        thumbnail: Thumbnail,
        url: Url,
        artists: Artists,
        groups: Groups,
        parodies: Groups,
        tags: Tags,
        imageList: ImageList,
        totalPages: len(imageList)
    )

proc jaTitle*(self: Data): JaTitle =
    return self.jaTitle

proc enTitle*(self: Data): EnTitle =
    return self.enTitle

proc uploadDat*(self: Data): UploadDat =
    return self.uploadDat

proc lang*(self: Data): Lang =
    return self.lang

proc thumbnail*(self: Data): Thumbnail =
    return self.thumbnail

proc artists*(self: Data): Artists =
    return self.artists

proc groups*(self: Data): Groups =
    return self.groups

proc parodies*(self: Data): Parodies =
    return self.parodies

proc tags*(self: Data): Tags =
    return self.tags

proc imageList*(self: Data): ImageList =
    return self.imageList

proc totalPages*(self: Data): TotalPages =
    return self.totalPages

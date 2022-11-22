import download from './download'

FOLDER_ID = process.env["TRANSLATE_FOLDER_ID"]
API_KEY = process.env["TRANSLATE_API_KEY"]

export default translate = (texts, options={}) ->
    data = {
        folderId: FOLDER_ID,
        "texts": texts,
        "targetLanguageCode": "en",
        "sourceLanguageCode": "ru",
        "format": "HTML",
        options...
    }
    href = "https://translate.api.cloud.yandex.net/translate/v2/translate"
    result = await download(href, undefined, {
        body: data,
        json: true,
        method: 'POST',
        followAllRedirects: true,
        timeout: 30 * 1000,
        headers: {
            "Content-Type": "application/json",
            "Authorization": "Api-Key #{API_KEY}"
        }
    })
    return result?.translations?.map((x) -> x?.text)

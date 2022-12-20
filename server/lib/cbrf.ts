// @ts-ignore
import download from './download'
import * as xml2js from 'xml2js'

export default async function getCbRfRate(currencyCode: string) {
    const page = await download("http://www.cbr.ru/scripts/XML_daily.asp", undefined, {timeout: 30 * 1000})
    const data = await xml2js.parseStringPromise(page)
    for (const currency of data.ValCurs.Valute) {
        if (currency.CharCode[0] == currencyCode) {
            const value = currency.Value[0].replace(",", ".")
            const nominal = currency.Nominal[0].replace(",", ".")
            return +value / +nominal
        }
    }
}

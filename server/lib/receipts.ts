import download from './download'

const SERVER = process.env["PAYKEEPER_SERVER"]
const USER = process.env["PAYKEEPER_USER"]
const PASSWORD = process.env["PAYKEEPER_PASSWORD"]

async function callApi(method: "GET"|"POST", endpoint: string, payload: any): Promise<any> {
    const url = `https://${SERVER}${endpoint}`
    const result = await download(url, null, {auth: {user: USER, password: PASSWORD}, form: payload, method})
    console.log(`>>>${endpoint}/${JSON.stringify(payload)}=>${result}`)
    const parsed = JSON.parse(result)
    if (parsed.result == "fail") {
        throw `Error at ${endpoint}: ${parsed.msg}`
    }
    return parsed
}

async function getToken() {
    return (await callApi("GET", "/info/settings/token/", {})).token
}

export default async function addUsnReceipt({service, amount, contact, orderId}: {service: string, amount: number, contact: string, orderId: string}) {
    if (!SERVER) {
        throw "Unknown usn server"
    }
    const cart = [
      {
        name: service,
        price: amount, 
        quantity: 1,
        sum: amount,
        tax: "none",
        item_type: "service",
        payment_type: "full",
      }
    ]
    const data = {
        payment_id: "",
        type: "sale",
        is_post_sale: true,
        is_correction: false,
        refund_id: "",
        contact: contact,
        sum_cashless: amount,
        sum_cash: 0,
        sum_advance: 0,
        sum_credit: 0,
        sum_counter_payment: 0,
        cart: JSON.stringify(cart),
        receipt_key: orderId,
        token: await getToken()
    }
    const res = await callApi("POST", '/change/receipt/print/', data)
    return res.receipt_id
}
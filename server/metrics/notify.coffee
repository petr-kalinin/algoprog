TelegramBot = require('node-telegram-bot-api')

TOKEN = process.env["TELEGRAM_TOKEN"]
ADMIN_CHAT_ID = process.env["ADMIN_TELEGRAM_ID"]

import logger from '../log'

if TOKEN
    bot = new TelegramBot(TOKEN, {polling: true})
    bot.on 'message', (msg) -> 
        logger.info "Telegram message", msg
else
    bot = undefined

export default notify = (message) ->
    if bot
        bot.sendMessage(ADMIN_CHAT_ID, message)
    else
        logger.warn("Notify message ", message)

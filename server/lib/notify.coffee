TelegramBot = require('node-telegram-bot-api')

TOKEN = process.env["TELEGRAM_TOKEN"]
ADMIN_CHAT_ID = process.env["ADMIN_TELEGRAM_ID"]
ALGOPROG_CHAT_ID = +process.env["ALGOPROG_CHAT_ID"]

import logger from '../log'
import User from '../models/user'

if TOKEN
    bot = new TelegramBot(TOKEN, {polling: true})

    bot.on 'chat_join_request', (request) -> 
        if request.chat.id == ALGOPROG_CHAT_ID
            userId = await User.findByTelegram(String(request.from.id))
            userName = await User.findByTelegram(String(request.from.username))

            if not userId && not userName
                bot.declineChatJoinRequest(ALGOPROG_CHAT_ID, request.from.id)
                logger.info "Rejected request from ", request.from.id
            else
                bot.approveChatJoinRequest(ALGOPROG_CHAT_ID, request.from.id)
                logger.info "Accepted request from ", request.from.id
        else
            logger.info "New join request from chat: ", request.chat.id, ", algoprog chat: ", ALGOPROG_CHAT_ID
else
    bot = undefined



export default notify = (message) ->
    if bot
        bot.sendMessage(ADMIN_CHAT_ID, message)
    else
        logger.warn("Notify message ", message)

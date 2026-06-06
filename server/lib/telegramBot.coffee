TelegramBot = require('node-telegram-bot-api')

TOKEN = process.env["TELEGRAM_TOKEN"]
ADMIN_CHAT_ID = process.env["ADMIN_TELEGRAM_ID"]
ALGOPROG_CHAT_ID = +process.env["ALGOPROG_CHAT_ID"]

import logger from '../log'
import User from '../models/user'
import { proxyChainManager } from './proxyChainForTg'


if TOKEN
    bot = new TelegramBot(TOKEN, {polling: true, request: { proxy: "http://localhost:1234" } })

    bot.on 'chat_join_request', (request) -> 
        try
            if request.chat.id == ALGOPROG_CHAT_ID
                userId = await User.findByTelegram(String(request.from.id))
                userName = await User.findByTelegram(String(request.from.username))

                if not userId && not userName
                    bot.declineChatJoinRequest(ALGOPROG_CHAT_ID, request.from.id)
                    logger.info "Rejected request from ", request.from.id, request.from.username
                else
                    bot.approveChatJoinRequest(ALGOPROG_CHAT_ID, request.from.id)
                    logger.info "Accepted request from ", request.from.id, request.from.username
            else
                logger.info "New join request from chat: ", request.chat.id, ", algoprog chat: ", ALGOPROG_CHAT_ID
        catch
            proxyChainManager.changeProxy()
else
    bot = undefined

export notifyUser = (id, message) ->
    try
        telegramId = (await User.findByIdWithTelegram(id)).telegram
        if bot and telegramId
            bot.sendMessage(telegramId, message, {parse_mode: 'HTML'})
        else
            logger.warn "Send message '", id, "', text: ", message 
    catch
        proxyChainManager.changeProxy()

export notify = (message) ->
    try
        if bot
            bot.sendMessage(ADMIN_CHAT_ID, message)
        else
            logger.warn("Notify message ", message)
    catch
        proxyChainManager.changeProxy()

export notifyDocument = (doc, fileOptions={}) ->
    try
        if bot
            bot.sendDocument(ADMIN_CHAT_ID, Buffer.from(doc, 'utf8'), undefined, fileOptions)
        else
            logger.warn("Notify document ", doc)
    catch
        proxyChainManager.changeProxy()

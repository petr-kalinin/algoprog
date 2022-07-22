TelegramBot = require('node-telegram-bot-api')
#setPrivacyDisabled у BotFather

TOKEN = "5555417433:AAFw-Fzz7dXU-v2YwdK2erzj5qRRlgThKds" #Изменить при отправке на ПР
ADMIN_CHAT_ID = "1382998623" #Изменить при отправке на ПР
ALGOPROG_CHAT_ID = -1001729463825

import logger from '../log'
import User from '../models/user'

if TOKEN
    bot = new TelegramBot(TOKEN, {polling: true})

    bot.on 'chat_join_request', (request) -> 
        if request.chat.id == ALGOPROG_CHAT_ID
            user = await User.findByTelegram(String(request.from.id))
            if not user
                bot.declineChatJoinRequest(ALGOPROG_CHAT_ID, request.from.id)
            else
                bot.approveChatJoinRequest(ALGOPROG_CHAT_ID, request.from.id)

        logger.info "New join request: ", request
else
    bot = undefined



export default notify = (message) ->
    if bot
        bot.sendMessage(ADMIN_CHAT_ID, message)
    else
        logger.warn("Notify message ", message)

passport = require('passport')
session = require('express-session')
import bodyParser from "body-parser"
import cookieParser from "cookie-parser"

import RegisteredUser from './models/registeredUser'

passport.use(RegisteredUser.createStrategy())

passport.serializeUser(RegisteredUser.serializeUser())
passport.deserializeUser(RegisteredUser.deserializeUser())

export default configure = (app) ->
    app.use(cookieParser('zdgadf'))
    #app.use(bodyParser.json())
    app.use(bodyParser.urlencoded({ extended: true }))
    app.use(session({secret: 'zdgadf', resave: false, saveUninitialized: false}))
    app.use(passport.initialize())
    app.use(passport.session())

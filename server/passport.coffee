passport = require('passport')
session = require('express-session')
MongoStore = require('connect-mongo')(session);
import bodyParser from "body-parser"
import cookieParser from "cookie-parser"

import RegisteredUser from './models/registeredUser'

passport.use(RegisteredUser.createStrategy())

passport.serializeUser(RegisteredUser.serializeUser())
passport.deserializeUser(RegisteredUser.deserializeUser())

export default configure = (app, db) ->
    mongoStore = new MongoStore({ mongooseConnection: db })

    app.use(cookieParser('zdgadf'))
    app.use(bodyParser.json())
    app.use(bodyParser.urlencoded({ extended: true }))
    app.use(bodyParser.raw({type: 'multipart/form-data'}))
    app.use(session({secret: 'zdgadf', store: mongoStore, resave: false, saveUninitialized: false}))
    app.use(passport.initialize())
    app.use(passport.session())

React = require('react')

import ProblemList from '../components/ProblemList'

export default class Archive
    problemBadge: (result) ->
        badge = ""
        if result.contestResult.ok > 0
            badge = "+"
        else if result.attempts > 0
            badge = "-"
        if result.attempts > 0
            badge += result.attempts
        badge

    problemStyle: (result) ->
        switch
            when result.contestResult.ok > 0 then "success"
            when result.attempts > 0 then "danger"
            else undefined

    Contest: ProblemList
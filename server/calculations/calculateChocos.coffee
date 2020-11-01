import Table from '../models/table'
import Result from '../models/result'
import logger from '../log'

class FullContestChocoCalculator
    constructor: ->
        @fullContests = 0
        
    processContest: (contest) ->
        full = true
        for p in contest
            if not p or p.solved == 0
                full = false
        if full
            @fullContests++
            
    chocos: ->
        if @fullContests == 0
            0
        else if @fullContests == 1
            1
        else
            (@fullContests // 3) + 1
            

class CleanContestChocoCalculator
    constructor: ->
        @cleanContests = 0
        
    processContest: (contest) ->
        clean = true
        for p in contest
            if not p or (p.attempts > 0) or (p.solved == 0)
                clean = false
        if clean
            @cleanContests++
            
    chocos: ->
        @cleanContests

class HalfCleanContestChocoCalculator
    constructor: ->
        @hcleanContests = 0
        
    processContest: (contest) ->
        clean = true
        half = true
        for p in contest
            if not p or (p.attempts > 0) or (p.solved == 0)
                clean = false
            if not p or (p.attempts > 1) or (p.solved == 0)
                half = false
        if half and (not clean)
            @hcleanContests++
            
    chocos: ->
        @hcleanContests // 2
        
export default calculateChocos = (userId) ->
    start = new Date()
    logger.info "calculateChocos ", userId
    chocoCalcs = [new FullContestChocoCalculator(), new CleanContestChocoCalculator(), new HalfCleanContestChocoCalculator()]
    tables = await Table.find({})
    for table in tables
        if table.problems.length == 0  # not a single contest
            continue
        results = []
        for problem in table.problems
            results.push(await Result.findByUserAndTable(userId, problem))
        for calc in chocoCalcs
            await calc.processContest(results)
    res = []
    for calc in chocoCalcs
        res.push(calc.chocos())
    logger.info "calculated chocos ", userId, " spent time ", (new Date()) - start
    return res

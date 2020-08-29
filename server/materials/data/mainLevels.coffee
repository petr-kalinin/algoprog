import label from "../lib/label"
import level from "../lib/level"

import arithmeticalOperations from './topics/arithmeticalOperations'
import ifs from './topics/ifs'
import debugging from './topics/debugging'
import loops from './topics/loops'
import arrays from './topics/arrays'
import strings from './topics/strings'
import floats from './topics/floats'
import pythonAdditional from './topics/pythonAdditional'
import gcd from './topics/gcd'
import backtrack from './topics/backtrack'
import sorting from './topics/sorting'
import technical from './topics/technical'
import prefixSums from './topics/prefixSums'
import recursion from './topics/recursion'

import level_1D from './level_1D'

TOPICS_PER_LEVEL = 3

ALL_TOPICS = [
    arithmeticalOperations,
    ifs,
    debugging,
    loops,
    arrays,
    strings,
    floats,
    pythonAdditional,

    gcd,
    prefixSums,
    recursion,
    backtrack

    # sorting
    # technical
]

ADDITIONAL_LEVELS =
    '1Г': level_1D

class TopicGenerator
    constructor: () ->
        @lastTopicId = -1

    nextTopic: () ->
        @lastTopicId++
        if @lastTopicId >= ALL_TOPICS.length
            return null
        return ALL_TOPICS[@lastTopicId]


minorLevel = (generator, id) ->
    allTopics = []
    topicsCount = 0
    allAdvancedTopics = []
    while true
        if topicsCount == TOPICS_PER_LEVEL
            break
        nextTopic = generator.nextTopic()
        if not nextTopic
            break
        nextTopic = nextTopic()
        if not nextTopic.topic and not nextTopic.topics
            nextTopic = {topic: nextTopic}
        {topic, topics = [], count=true, advancedTopics = []} = nextTopic
        if topic
            topics.push topic
        allTopics = [allTopics..., topics...]
        allAdvancedTopics = [allAdvancedTopics..., advancedTopics...]
        if count
            topicsCount++
    if allTopics.length == 0
        console.log "Return null minorLevel #{id}"
        return null
    return {
        level: level(id, [
                label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
                allTopics...
            ]),
        advancedTopics: allAdvancedTopics
    }

majorLevel = (generator, id) ->
    levelA = minorLevel(generator, "#{id}А")
    levelB = minorLevel(generator, "#{id}Б")
    subLevels = [
        levelA?.level
        levelB?.level
    ]
    subLevels = (l for l in subLevels when l)
    if subLevels.length == 0
        console.log "Return null majorLevel #{id}"
        return null
    advancedTopics = [(levelA?.advancedTopics || [])..., (levelB?.advancedTopics || [])...]
    if advancedTopics.length != 0
        subLevels.push level("#{id}В", [
            label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум половину задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
            advancedTopics...
        ])
    if "#{id}Г" of ADDITIONAL_LEVELS
        subLevels.push ADDITIONAL_LEVELS["#{id}Г"]()
    return level("#{id}", [
        subLevels...
    ])

export default mainLevels = () ->
    allLevels = []
    id = 1
    generator = new TopicGenerator()
    while true
        nextLevel = majorLevel(generator, id)
        if not nextLevel
            break
        allLevels.push nextLevel
        id++
    return allLevels

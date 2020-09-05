import label from "../lib/label"
import level from "../lib/level"
import contest from "../lib/contest"

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
import complexity from './topics/complexity'
import dp_simple from './topics/dp_simple'
import greedy_simple from './topics/greedy_simple'
import primes from './topics/primes'
import stack from './topics/stack'
import stl from './topics/stl'
import graphs_simple from './topics/graphs_simple'
import cpp from './topics/cpp'
import codeforces from './topics/codeforces'
import binsearch from './topics/binsearch'
import bfs from './topics/bfs'
import dfs_simple from './topics/dfs_simple'
import testing_advanced from './topics/testing_advanced'
import two_pointers from './topics/two_pointers'
import numeral_systems from './topics/numeral_systems'
import bit_operations from './topics/bit_operations'
import dp_bayans from './topics/dp_bayans'
import dijkstra from './topics/dijkstra'
import geometry_simple from './topics/geometry_simple'
import count_sort from './topics/count_sort'
import long_arithmetics from './topics/long_arithmetics'
import events_sort from './topics/events_sort'
import tertiary_search from './topics/tertiary_search'
import linked_lists from './topics/linked_lists'
import dp_middle from './topics/dp_middle'
import hash from './topics/hash'
import heap from './topics/heap'
import dijkstra_with_heap from './topics/dijkstra_with_heap'
import floyd_and_fb from './topics/floyd_and_fb'
import simple_games from './topics/simple_games'
import combinatorics from './topics/combinatorics'
import bfs_01 from './topics/bfs_01'
import greedy_advanced from './topics/greedy_advanced'

import level_1D from './level_1D'

TOPICS_PER_LEVEL = 3
PROBLEMS_PER_ADDITIONAL_CONTEST = 6

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
    backtrack(false),
    complexity,
    dp_simple,
    technical,
    primes,
    greedy_simple,
    stack,
    stl,
    testing_advanced,
    graphs_simple,
    cpp,
    codeforces,
    bfs,
    dfs_simple,
    binsearch,
    two_pointers,
    numeral_systems,
    bit_operations,
    sorting,
    dp_bayans,
    dijkstra,
    geometry_simple,
    count_sort
    long_arithmetics,
    events_sort,
    tertiary_search,
    linked_lists,
    dp_middle,
    hash,
    heap,
    dijkstra_with_heap,
    backtrack(true),
    floyd_and_fb,
    simple_games,
    combinatorics,
    bfs_01
    greedy_advanced

    # kmp
    # dfs_advanced
    # z_function
    # cartesian_tree
    # segment_tree
    # sqrt_decomposition
    # cartesian_tree_implicit
    # dp_advanced.coffee
    # dsu.coffee
    # geometry_middle.coffee
    # grundy.coffee
    # matching.coffee
    # aho_corasick.coffee
    # fenwick.coffee
    # flows.coffee
    # lca.coffee
    # mass_operations.coffee
    # multid_trees.coffee
    # advanced_numbers.coffee
    # geometry_advanced.coffee
    # matrices.coffee
    # maxmatching.coffee
    # mincost_maxflow.coffee
    # suffixes.coffee

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

shuffleArray = (array) ->
    if array.length == 0
        return
    for i in [array.length - 1 .. 0]
        j = Math.floor(Math.random() * (i + 1))
        [array[i], array[j]] = [array[j], array[i]]

contestsFromAdvancedProblems = (problems) ->
    shuffleArray(problems)
    count = Math.ceil(problems.length / PROBLEMS_PER_ADDITIONAL_CONTEST)
    countPerContest = Math.floor(problems.length / count)
    idx = 0
    result = []
    for i in [0...count]
        thisCount = countPerContest
        if i < problems.length % count
            thisCount++
        thisProblems = []
        for j in [0...thisCount]
            thisProblems.push(problems[idx])
            idx++
        result.push(contest("Дополнительные задачи на разные темы - #{i + 1}", thisProblems))
    if idx != problems.length
        throw "Bad idx: #{idx}, #{problems.length}"
    return result

minorLevel = (generator, id) ->
    allTopics = []
    topicsCount = 0
    allAdvancedTopics = []
    allAdvancedProblems = []
    while true
        if topicsCount == TOPICS_PER_LEVEL
            break
        nextTopic = generator.nextTopic()
        if not nextTopic
            break
        nextTopic = nextTopic()
        if not nextTopic.topic and not nextTopic.topics
            nextTopic = {topic: nextTopic}
        {topic, topics = [], count=true, advancedTopics = [], advancedProblems = []} = nextTopic
        if topic
            topics.push topic
        allTopics = [allTopics..., topics...]
        allAdvancedTopics = [allAdvancedTopics..., advancedTopics...]
        allAdvancedProblems = [allAdvancedProblems..., advancedProblems...]
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
        advancedProblems: allAdvancedProblems
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
    advancedProblems = [(levelA?.advancedProblems || [])..., (levelB?.advancedProblems || [])...]
    advancedTopics = [(levelA?.advancedTopics || [])..., (levelB?.advancedTopics || [])..., contestsFromAdvancedProblems(advancedProblems)...]
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

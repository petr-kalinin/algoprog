seedrandom = require('seedrandom')

import isContestRequired from '../../../client/lib/isContestRequired'

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
import dp_sbory from './topics/dp_sbory'
import hash from './topics/hash'
import heap from './topics/heap'
import dijkstra_with_heap from './topics/dijkstra_with_heap'
import floyd_and_fb from './topics/floyd_and_fb'
import games_simple from './topics/games_simple'
import combinatorics from './topics/combinatorics'
import bfs_01 from './topics/bfs_01'
import greedy_advanced from './topics/greedy_advanced'
import dfs_advanced from './topics/dfs_advanced'
import kmp from './topics/kmp'
import z_function from './topics/z_function'
import sqrt_decomposition from './topics/sqrt_decomposition'
import sparse_tables from './topics/sparse_tables'
import segment_tree from './topics/segment_tree'
import two_sat from './topics/2sat'
import lca from './topics/lca'
import binary_trees_and_trie from './topics/binary_trees_and_trie'
import geometry_middle from './topics/geometry_middle'
import dp_advanced from './topics/dp_advanced'
import games_cyclic from './topics/games_cyclic'
import cartesian_tree from './topics/cartesian_tree'
import dsu from './topics/dsu'
import cartesian_tree_implicit from './topics/cartesian_tree_implicit'
import advanced_numbers from './topics/advanced_numbers'
import inclusion_exclusion from './topics/inclusion_exclusion'
import matching from './topics/matching'
import grundy from './topics/grundy'
import flows from './topics/flows'
import fenwick from './topics/fenwick'
import mass_operations from './topics/mass_operations'
import aho_corasick from './topics/aho_corasick'
import advanced_scanline from './topics/advanced_scanline'
import divide_and_conquer from './topics/divide_and_conquer'
import matrices from './topics/matrices'
import suffixes from './topics/suffixes'
import hld from './topics/hld'
import geometry_advanced from './topics/geometry_advanced'
import mincost_maxflow from './topics/mincost_maxflow'
import dp_hard from './topics/dp_hard'
import maxmatching from './topics/maxmatching'
import persistency from './topics/persistency'

import level_1D from './level_1D'
import level_3D from './level_3D'
import level_5D from './level_5D'
import level_7D from './level_7D'
import level_9D from './level_9D'
import level_11D from './level_11D'

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
    dp_sbory,
    hash,
    heap,
    dijkstra_with_heap,
    backtrack(true),
    floyd_and_fb,
    games_simple,
    combinatorics,
    bfs_01,
    greedy_advanced,
    dfs_advanced,
    kmp,
    z_function,
    sqrt_decomposition,
    sparse_tables,
    segment_tree
    two_sat,
    lca,
    binary_trees_and_trie
    geometry_middle
    dp_advanced
    games_cyclic
    cartesian_tree
    dsu
    cartesian_tree_implicit
    advanced_numbers,
    inclusion_exclusion,
    matching
    grundy
    flows
    fenwick
    mass_operations
    aho_corasick,
    advanced_scanline,
    divide_and_conquer
    matrices
    suffixes
    hld
    geometry_advanced
    mincost_maxflow
    dp_hard
    maxmatching
    persistency
]

ADDITIONAL_LEVELS =
    '1Г': level_1D
    '3Г': level_3D
    '5Г': level_5D
    '7Г': level_7D
    '9Г': level_9D
    '11Г': level_11D

class TopicGenerator
    constructor: () ->
        @lastTopicId = -1

    nextTopic: () ->
        @lastTopicId++
        if @lastTopicId >= ALL_TOPICS.length
            return null
        return ALL_TOPICS[@lastTopicId]

shuffleArray = (rng, array) ->
    if array.length == 0
        return
    for i in [array.length - 1 .. 0]
        j = Math.floor(rng() * (i + 1))
        [array[i], array[j]] = [array[j], array[i]]

contestsFromAdvancedProblems = (id, problems) ->
    rng = seedrandom(id)
    shuffleArray(rng, problems)
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

requiredNote = (topics) ->
    allRequired  = true
    for topic in topics
        t = topic()
        if t.title 
            hasProblems = false
            for m in t.submaterials || []
                if m?()?.testSystem
                    hasProblems = true
            if hasProblems
                allRequired = allRequired and isContestRequired(t.title)
    if not allRequired
        return " (кроме контестов со звездочкой)"
    return ""

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
                label("<p>Чтобы перейти на следующий уровень, надо решить все задачи#{requiredNote(allTopics)}.</p>"),
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
    advancedTopics = [(levelA?.advancedTopics || [])..., (levelB?.advancedTopics || [])..., contestsFromAdvancedProblems(id, advancedProblems)...]
    if advancedTopics.length != 0
        subLevels.push level("#{id}В", [
            label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум половину задач</b>#{requiredNote(advancedTopics)}. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
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

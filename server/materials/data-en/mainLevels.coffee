seedrandom = require('seedrandom')

import isContestRequired from '../../../client/lib/isContestRequired'

import label from "../lib/label"
import level from "../lib/level"
import contest from "../lib/contest"

import arithmeticalOperations from '../data/topics/arithmeticalOperations'
import ifs from '../data/topics/ifs'
import debugging from '../data/topics/debugging'
import loops from '../data/topics/loops'
import arrays from '../data/topics/arrays'
import strings from '../data/topics/strings'
import floats from '../data/topics/floats'
import pythonAdditional from '../data/topics/pythonAdditional'
import gcd from '../data/topics/gcd'
import backtrack from '../data/topics/backtrack'
import sorting from '../data/topics/sorting'
import technical from '../data/topics/technical'
import prefixSums from '../data/topics/prefixSums'
import recursion from '../data/topics/recursion'
import complexity from '../data/topics/complexity'
import dp_simple from '../data/topics/dp_simple'
import greedy_simple from '../data/topics/greedy_simple'
import primes from '../data/topics/primes'
import stack from '../data/topics/stack'
import stl from '../data/topics/stl'
import graphs_simple from '../data/topics/graphs_simple'
import cpp from '../data/topics/cpp'
import codeforces from '../data/topics/codeforces'
import binsearch from '../data/topics/binsearch'
import bfs from '../data/topics/bfs'
import dfs_simple from '../data/topics/dfs_simple'
import testing_advanced from '../data/topics/testing_advanced'
import two_pointers from '../data/topics/two_pointers'
import numeral_systems from '../data/topics/numeral_systems'
import bit_operations from '../data/topics/bit_operations'
import dp_bayans from '../data/topics/dp_bayans'
import dijkstra from '../data/topics/dijkstra'
import geometry_simple from '../data/topics/geometry_simple'
import count_sort from '../data/topics/count_sort'
import long_arithmetics from '../data/topics/long_arithmetics'
import events_sort from '../data/topics/events_sort'
import tertiary_search from '../data/topics/tertiary_search'
import linked_lists from '../data/topics/linked_lists'
import dp_middle from '../data/topics/dp_middle'
import dp_sbory from '../data/topics/dp_sbory'
import hash from '../data/topics/hash'
import heap from '../data/topics/heap'
import dijkstra_with_heap from '../data/topics/dijkstra_with_heap'
import floyd_and_fb from '../data/topics/floyd_and_fb'
import games_simple from '../data/topics/games_simple'
import combinatorics from '../data/topics/combinatorics'
import bfs_01 from '../data/topics/bfs_01'
import greedy_advanced from '../data/topics/greedy_advanced'
import dfs_advanced from '../data/topics/dfs_advanced'
import kmp from '../data/topics/kmp'
import z_function from '../data/topics/z_function'
import sqrt_decomposition from '../data/topics/sqrt_decomposition'
import sparse_tables from '../data/topics/sparse_tables'
import segment_tree from '../data/topics/segment_tree'
import two_sat from '../data/topics/2sat'
import lca from '../data/topics/lca'
import binary_trees_and_trie from '../data/topics/binary_trees_and_trie'
import geometry_middle from '../data/topics/geometry_middle'
import dp_advanced from '../data/topics/dp_advanced'
import games_cyclic from '../data/topics/games_cyclic'
import cartesian_tree from '../data/topics/cartesian_tree'
import dsu from '../data/topics/dsu'
import cartesian_tree_implicit from '../data/topics/cartesian_tree_implicit'
import advanced_numbers from '../data/topics/advanced_numbers'
import inclusion_exclusion from '../data/topics/inclusion_exclusion'
import matching from '../data/topics/matching'
import grundy from '../data/topics/grundy'
import flows from '../data/topics/flows'
import fenwick from '../data/topics/fenwick'
import mass_operations from '../data/topics/mass_operations'
import aho_corasick from '../data/topics/aho_corasick'
import advanced_scanline from '../data/topics/advanced_scanline'
import divide_and_conquer from '../data/topics/divide_and_conquer'
import matrices from '../data/topics/matrices'
import suffixes from '../data/topics/suffixes'
import hld from '../data/topics/hld'
import geometry_advanced from '../data/topics/geometry_advanced'
import mincost_maxflow from '../data/topics/mincost_maxflow'
import dp_hard from '../data/topics/dp_hard'
import maxmatching from '../data/topics/maxmatching'
import persistency from '../data/topics/persistency'

import level_1D from '../data/level_1D'
import level_3D from '../data/level_3D'
import level_5D from '../data/level_5D'
import level_7D from '../data/level_7D'
import level_9D from '../data/level_9D'
import level_11D from '../data/level_11D'

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
###
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
###
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
        result.push(contest("Additional problems on different topics - #{i + 1}", thisProblems))
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
        return " (except the contests marked with asterisk)"
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
                label("<p>To advance to next level, you need to solve all problems#{requiredNote(allTopics)}.</p>"),
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
            label("<p>To advance to next level, you need to solve <b>at least half of the problems</b>#{requiredNote(advancedTopics)}. When you solve them, I recommend that you move to the next level, so as not to delay the study of new theory. Return to the remaining tasks of this level later from time to time and try to gradually solve almost all of them.</p>"),
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

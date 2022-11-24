import correctUrl from './correctUrl'

test('test', () => {
    expect(correctUrl('/material/1', '')).toStrictEqual('/material/1')
    expect(correctUrl('/material/1', '!en')).toStrictEqual('/material/1!en')

    expect(correctUrl('/material/1!en', '')).toStrictEqual('/material/1')
    expect(correctUrl('/material/1!en', '!en')).toStrictEqual('/material/1!en')

    // ---
    expect(correctUrl('/material/1Б', '')).toStrictEqual('/material/1B')
    expect(correctUrl('/material/1Б', '!en')).toStrictEqual('/material/1B!en')

    expect(correctUrl('/material/1B!en', '')).toStrictEqual('/material/1B')
    expect(correctUrl('/material/1B!en', '!en')).toStrictEqual('/material/1B!en')

    // ---
    expect(correctUrl('/material/1Б.5', '')).toStrictEqual('/material/1B.5')
    expect(correctUrl('/material/1Б.5', '!en')).toStrictEqual('/material/1B.5!en')

    expect(correctUrl('/material/1B.5!en', '')).toStrictEqual('/material/1B.5')
    expect(correctUrl('/material/1B.5!en', '!en')).toStrictEqual('/material/1B.5!en')

    // ---
    expect(correctUrl('/material/ifs', '')).toStrictEqual('/material/ifs')
    expect(correctUrl('/material/ifs', '!en')).toStrictEqual('/material/ifs!en')

    expect(correctUrl('/material/ifs!en', '')).toStrictEqual('/material/ifs')
    expect(correctUrl('/material/ifs!en', '!en')).toStrictEqual('/material/ifs!en')

    // ---
    expect(correctUrl('/foobar', '')).toStrictEqual('/foobar')
    expect(correctUrl('/foobar', '!en')).toStrictEqual('/foobar')

    expect(correctUrl('/foobar!en', '')).toStrictEqual('/foobar!en')
    expect(correctUrl('/foobar!en', '!en')).toStrictEqual('/foobar!en')
})

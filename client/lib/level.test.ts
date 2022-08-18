import {parseLevel, encodeLevel} from './level'

test('simpleEncode', () => {
    expect(parseLevel('1')).toStrictEqual({major: 1})

    expect(parseLevel('1А')).toStrictEqual({major: 1, minor: 0})
    expect(parseLevel('1A')).toStrictEqual({major: 1, minor: 0})

    expect(parseLevel('1Б')).toStrictEqual({major: 1, minor: 1})
    expect(parseLevel('1B')).toStrictEqual({major: 1, minor: 1})

    expect(parseLevel('1В')).toStrictEqual({major: 1, minor: 2})
    expect(parseLevel('1C')).toStrictEqual({major: 1, minor: 2})

    expect(parseLevel('1Г')).toStrictEqual({major: 1, minor: 3})
    expect(parseLevel('1D')).toStrictEqual({major: 1, minor: 3})

    expect(parseLevel('2А')).toStrictEqual({major: 2, minor: 0})
    expect(parseLevel('2A')).toStrictEqual({major: 2, minor: 0})

    expect(parseLevel('10Б')).toStrictEqual({major: 10, minor: 1})
    expect(parseLevel('10B')).toStrictEqual({major: 10, minor: 1})

    expect(parseLevel('123В')).toStrictEqual({major: 123, minor: 2})
    expect(parseLevel('123C')).toStrictEqual({major: 123, minor: 2})

    expect(parseLevel('123')).toStrictEqual({major: 123})

    // Strip label
    expect(parseLevel('123В!en')).toStrictEqual({major: 123, minor: 2})
    expect(parseLevel('123C!en')).toStrictEqual({major: 123, minor: 2})
    expect(parseLevel('12!en')).toStrictEqual({major: 12})
})

test('regEncode', () => {
    expect(parseLevel('reg')).toStrictEqual({regMajor: "reg"})
    expect(parseLevel('reg2002')).toStrictEqual({regMajor: "reg", regMinor: "2002"})

    expect(parseLevel('roi')).toStrictEqual({regMajor: "roi"})
    expect(parseLevel('roi2002')).toStrictEqual({regMajor: "roi", regMinor: "2002"})

    expect(parseLevel('nnoi')).toStrictEqual({regMajor: "nnoi"})
    expect(parseLevel('nnoi2002')).toStrictEqual({regMajor: "nnoi", regMinor: "2002"})

    expect(parseLevel('sch')).toStrictEqual({regMajor: "sch"})
    expect(parseLevel('sch2002')).toStrictEqual({regMajor: "sch", regMinor: "2002"})
    
    // Strip label
    expect(parseLevel('sch!en')).toStrictEqual({regMajor: "sch"})
    expect(parseLevel('sch2002!en')).toStrictEqual({regMajor: "sch", regMinor: "2002"})
})

test('notALevel', () => {
    expect(parseLevel('foo')).toBe(null)
    expect(parseLevel('1AB')).toBe(null)
    expect(parseLevel('1ab')).toBe(null)
    expect(parseLevel('A1B')).toBe(null)
    expect(parseLevel('1Z')).toBe(null)
    expect(parseLevel('1Я')).toBe(null)
    expect(parseLevel('1E')).toBe(null)
    expect(parseLevel('1E!en')).toBe(null)
    expect(parseLevel('1Д')).toBe(null)
    expect(parseLevel('1Z1')).toBe(null)
})

test('encodeSimple', () => {
    expect(encodeLevel({major: 1})).toBe("1")
    expect(encodeLevel({major: 12})).toBe("12")
    expect(encodeLevel({major: 1, minor: 0})).toBe("1А")
    expect(encodeLevel({major: 1, minor: 1})).toBe("1Б")
    expect(encodeLevel({major: 13, minor: 2})).toBe("13В")
    expect(encodeLevel({major: 24, minor: 3})).toBe("24Г")

    // for english
    expect(encodeLevel({major: 1}, "!en")).toBe("1!en")
    expect(encodeLevel({major: 12}, "!en")).toBe("12!en")
    expect(encodeLevel({major: 1, minor: 0}, "!en")).toBe("1A!en")
    expect(encodeLevel({major: 1, minor: 1}, "!en")).toBe("1B!en")
    expect(encodeLevel({major: 13, minor: 2}, "!en")).toBe("13C!en")
    expect(encodeLevel({major: 24, minor: 3}, "!en")).toBe("24D!en")
})

test('encodeReg', () => {
    expect(encodeLevel({regMajor: "reg"})).toBe("reg")
    expect(encodeLevel({regMajor: "reg", regMinor: "2002"})).toBe("reg2002")

    // for english
    expect(encodeLevel({regMajor: "reg"}, "!en")).toBe("reg!en")
    expect(encodeLevel({regMajor: "reg", regMinor: "2002"}, "!en")).toBe("reg2002!en")
})
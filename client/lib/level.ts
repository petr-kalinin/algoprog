import stripLabel from './stripLabel'

export interface Level {
    major?: number,
    minor?: number
    regMajor?: string,
    regMinor?: string
}

function parseMinor(minor: string) {
    if (minor >= "A" && minor <= "Z") {
        return minor.charCodeAt(0) - "A".charCodeAt(0) + 1;
    } else if (minor >= "А" && minor <= "Я") {
        return minor.charCodeAt(0) - "А".charCodeAt(0) + 1;
    } else return null
}

export function parseLevel(level: string): Level {
    if (!level) {
        return null
    }
    level = stripLabel(level)
    for (const reg of ["sch", "nnoi", "reg", "roi"]) {
        if (level.substr(0, reg.length) == reg) {
            if (level == reg) {
                return { regMajor: reg }
            } else {
                return { regMajor: reg, regMinor: level.substr(reg.length) }
            }
        }
    }
    const last = level.slice(-1)
    if (last >= '0' && last <= '9' && ("" + (+level) == level)) {
        return { major : +level }
    }
    const start = +level.slice(0, -1)
    const minor = parseMinor(last)
    if ("" + start + last != level || minor == null) {
        return null
    }
    return { major : +level.slice(0, -1), minor : parseMinor(last) }
}
    
export function encodeLevel(level: Level, lang=""): string {
    var {major, minor, regMajor, regMinor} = level
    if (regMajor) {
        var res = regMajor;
        if (regMinor) {
            res += regMinor;
        }
        return res + lang;
    }
    var letter = ""
    if (minor) {
        /*
        if (lang == "") {
            letter = ['А', 'Б', 'В', 'Г'][minor - 1]
        } else if (lang == "!en") {
            letter = ['A', 'B', 'C', 'D', "E", "F", "G"][minor - 1]
        } else throw `strange lang ${lang}`
        */
        letter = String.fromCharCode("A".charCodeAt(0) + minor - 1);
    }
    return `${major}${letter}${lang}`
}

export function compareLevels(a: Level, b: Level): Number {
    if (a.regMajor || b.regMajor) {
        throw "Can't compare reg levels";
    }
    if (a.major != b.major) {
        if (a.major < b.major) 
            return -1
        else
            return 1
    }
    if (a.minor < b.minor) 
        return -1
    else if (a.minor == b.minor)
        return 0
    else
        return 1
}
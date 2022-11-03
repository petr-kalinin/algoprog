import {parseLevel, encodeLevel} from '../lib/level'
import stripLabel from '../lib/stripLabel'

function correctSubmaterial(materialId: string, label: string) {
    const data = materialId.split(".")
    if (data.length != 2)
        return null
    const level = parseLevel(data[0])
    if (!level) 
        return null
    return "/material/" + stripLabel(encodeLevel(level, label)) + "." + stripLabel(data[1]) + label
}

export default function correctUrl(url: string, label: string) {
    if (!url.startsWith("/material/"))
        return url
    const data = url.split("/")
    if (data.length != 3) 
        return url
    const level = parseLevel(data[2])
    if (!level) {
        const correctedSubmaterial = correctSubmaterial(data[2], label)
        return correctedSubmaterial || (stripLabel(url) + label);
    }
    return "/material/" + encodeLevel(level, label)
}

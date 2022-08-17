export default function stripLabel(id: string): string {
    var idx = id.indexOf("!")
    if (idx != -1) {
        return id.substring(0, idx)
    }
    return id
}
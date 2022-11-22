export default function stripLabel(id: string): string {
    if (!id) {
        return id
    }
    var idx = id.indexOf("!")
    if (idx != -1) {
        return id.substring(0, idx)
    }
    return id
}
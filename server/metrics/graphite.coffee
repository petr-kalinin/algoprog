graphite = require('graphite')
import logger from '../log'

client = graphite.createClient('plaintext://ije.algoprog.ru:2003/')

instance_number = process.env["INSTANCE_NUMBER"] || "0"
enabled = process.env["GRAPHITE"]

export default send = (metrics) ->
    if not enabled
        console.log "disabled send metrics ", metrics
        return

    metrics["instance"] = +instance_number

    prefix = "algoprog_sm.#{instance_number}"
    metricsWithPrefix = {}
    for key, value of metrics
        metricsWithPrefix["#{prefix}.#{key}"] = value
    client.write(metricsWithPrefix, (err) -> if err? then logger.error("Can't send metrics to graphite: #{err}"))

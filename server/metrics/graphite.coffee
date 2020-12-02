graphite = require('graphite')
import logger from '../log'

client = graphite.createClient('plaintext://ije.algoprog.ru:2003/')

instance_number = process.env["INSTANCE_NUMBER"] || "0"
enabled = process.env["GRAPHITE"] || process.env["GRAPHITE_PREFIX"]
PREFIX = process.env["GRAPHITE_PREFIX"] || "algoprog"

export default send = (metrics) ->
    if not enabled
        console.log "disabled send metrics ", metrics
        return

    metrics["instance"] = +instance_number

    prefix = "#{PREFIX}.#{instance_number}"
    metricsWithPrefix = {}
    for key, value of metrics
        metricsWithPrefix["#{prefix}.#{key}"] = value
    try
        client.write(metricsWithPrefix, (err) -> if err? then logger.error("Can't send metrics to graphite: #{err}"))
    catch e
        logger.error("Can't send metrics to graphite: #{e}")

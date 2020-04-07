mongoose = require('mongoose')

paymentSchema = new mongoose.Schema
    user: String
    orderId: String
    time: Date
    success: Boolean
    processed: Boolean
    oldPaidTill: Date
    newPaidTill: Date
    payload: mongoose.Schema.Types.Mixed
    receipt: String


paymentSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @time = new Date()
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a payment"

paymentSchema.statics.findLastReceiptByUserId = (userId) ->
    return (await Payment.find({user: userId}).sort("-time").limit(1))[0]
    

paymentSchema.index({ user : 1, time: -1 })
paymentSchema.index({ time : 1 })

Payment = mongoose.model('smPayments', paymentSchema);

export default Payment

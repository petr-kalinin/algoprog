export default run = ->
    for u in await User.findAll()
        u.updateCfRating()

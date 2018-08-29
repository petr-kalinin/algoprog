import download from '../lib/download'
import logger from '../log'

import TestSystem, {TestSystemUser} from './TestSystem'


REQUESTS_LIMIT = 20


export default class Ejudge extends TestSystem
    id: () ->
        return "ejudge"


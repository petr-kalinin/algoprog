import { Schema, model } from 'mongoose'

// @ts-ignore
import logger from '../log'

interface IAction {
  action: string,
  userList: string,
  url: string,
  userId: string,
  allowed: boolean
  date: Date
}

const actionSchema = new Schema<IAction>({
  action: String,
  userList: String,
  url: String,
  userId: String,
  allowed: Boolean,
  date: Date
})

actionSchema.methods.upsert = function () {
    try {
        this.date = new Date()
        this.update(this, {upsert: true})
    } catch {
        logger.info("Could not upsert a action")
    }
}

const AdminAction = model<IAction>('AdminActions', actionSchema)

export default AdminAction
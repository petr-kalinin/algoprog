import { Server } from 'proxy-chain'

import logger from '../log'


export function chooseRandom<T>(x: T[] | undefined) {
    if (!x) {
        return undefined
    }
    return x[Math.floor(Math.random() * x.length)]
}

const BOT_PROXIES = process.env.BOT_PROXIES?.split(';')


export class ProxyChainManager {
    private allProxies: string[]
    private currentProxy: string
    private connectionCount: number
    private proxyChainServer: Server

    constructor() {
        this.allProxies = BOT_PROXIES
        this.currentProxy = chooseRandom(this.allProxies) || ''
        this.connectionCount = 0
        
        logger.info(`[ProxyChain] Initial proxy selected: ${this.currentProxy}`)
        
        this.proxyChainServer = new Server({
            port: 1234,
            host: 'localhost',
            //verbose: true,
            prepareRequestFunction: ({ request, username, password, hostname, port, isHttp, connectionId }) => {
                this.connectionCount++
                //logger.info(`[ProxyChain] Using proxy: ${this.currentProxy} (connection #${this.connectionCount})`)
                return {
                    upstreamProxyUrl: this.currentProxy
                }
            }
        })
        
        // Listen for failed connections and switch proxy
        this.proxyChainServer.on('connectionClosed', ({ connectionId, stats }) => {
            if (stats?.srcTxBytes === 0 && stats?.srcRxBytes === 0) {
                // Connection failed without any data transfer
                this.changeProxy(`Connection ${connectionId} failed (no data transfer)`)
            }
        })
        
        this.proxyChainServer.on('requestFailed', ({ request, error }) => {
            // Request failed, switch to a different proxy
            this.changeProxy(`Request failed with error: ${error?.message}`)
        })
        
        this.proxyChainServer.listen()
    }

    /**
     * Manually change to a different proxy
     * @param reason Optional reason for the proxy change
     */
    changeProxy(reason?: string): void {
        const oldProxy = this.currentProxy
        this.currentProxy = chooseRandom(this.allProxies) || this.currentProxy
        const reasonStr = reason ? ` Reason: ${reason}` : ''
        logger.info(`[ProxyChain] Switching proxy: ${oldProxy} -> ${this.currentProxy}.${reasonStr}`)
    }

    /**
     * Get the current proxy being used
     */
    getCurrentProxy(): string {
        return this.currentProxy
    }

    /**
     * Get the proxy chain server instance
     */
    getServer(): Server {
        return this.proxyChainServer
    }
}

// Global instance
export const proxyChainManager = new ProxyChainManager()

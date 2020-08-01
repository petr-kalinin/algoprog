const path = require('path')
const webpack = require('webpack')
const nodeExternals = require('webpack-node-externals')
const {CleanWebpackPlugin} = require('clean-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const OptimizeCssAssetWebpackPlugin = require('optimize-css-assets-webpack-plugin')
const TerserWebpackPlugin = require('terser-webpack-plugin')

const isDev = !process.env.NODE_ENV || process.env.NODE_ENV === 'development'
console.log('IS DEV:', isDev)
const isProd = !isDev
const mode = () => isDev ? 'development' : 'production'
const watch = () => isDev
const optimization = () => {
  const config = {
    // i don't know how to handle unknown amount of parts in ssr
    //splitChunks: {
    //  chunks: 'all'
    //}
  }
  
  if (isProd) {
    config.minimizer= [
      new OptimizeCssAssetWebpackPlugin(),
      new TerserWebpackPlugin()
    ]
  }
  
  return config
}

const resolve = () => ({ extensions: ['.coffee','.js']})
const devtool = () => (isDev ? 'source-map' : '')
const moduleconf = () => ({
  rules: [
    {
      test: /\.css$/,
      use: [
        {
          loader: MiniCssExtractPlugin.loader,
          options: {
            esModule: true,
            hmr: isDev
          }
        },
        {
          loader: 'css-loader',
          options: {
            importLoaders: 1,
            modules: true
          }
        }
      ]
    },
    {
      test: /\.coffee$/,
      loader: 'coffee-loader',
      options: {
        transpile: {
          presets: ['@babel/preset-react',
                     ["@babel/preset-env",
                       {
                         useBuiltIns: 'usage',
                         corejs: 3
                       }
                     ]
                   ],
        }
      }
    }
  ]
})

const clientConfig = {
  context: path.resolve(__dirname, 'client'),
  mode: mode(),
  watch: watch(),
  entry: {
    client: ['./client.coffee']
  },
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'build/assets')
  },
  resolve: resolve(),
  devtool: devtool(),
  optimization: optimization(),
  module: moduleconf(),
  plugins: [
    new CleanWebpackPlugin(),
    new MiniCssExtractPlugin({
      filename: 'bundle.css',
      chunkFilename: '[id].bundle.css',
    })
  ],
}

const serverConfig = {
  context: path.resolve(__dirname, 'server'),
  mode: mode(),
  watch: watch(),
  target: 'node',
  entry: {
    server: ['./server.coffee']
  },
  output: {
    filename: '[name].bundle.js',
    path: path.resolve(__dirname, 'build/server')
  },
  node: {
    __dirname: false,
    __filename: false
  },
  externals: [nodeExternals()],
  resolve: resolve(),
  devtool: devtool(),
  optimization: optimization(),
  module: moduleconf(),
  plugins: [
    new CleanWebpackPlugin(),
    new MiniCssExtractPlugin({
      filename: 'server.bundle.css',
      chunkFilename: '[id].bundle.css',
    })
  ],
}


module.exports = [clientConfig, serverConfig]

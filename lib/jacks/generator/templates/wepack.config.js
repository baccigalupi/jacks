const path = require('path')

const dotenv = require('dotenv')

const HtmlWebpackPlugin     = require('html-webpack-plugin')
const MiniCssExtractPlugin  = require('mini-css-extract-plugin')
const ManifestPlugin        = require('webpack-manifest-plugin')

const appEnv    = process.env.APP_ENV || 'development'
let manifestName = 'manifest.local'

if (appEnv == 'production') {
  dotenv.config({path: path.resolve(path.join(__dirname, '.env.production'))})
  manifestName = 'manifest'
}
dotenv.config()

const assetServer = process.env.ASSET_SERVER

const imageRegex = /\.(png|svg|jpe?g|gif|ico)$/i

function templateParametersGenerator(title, cssName, jsName) {
  return function (compilation, assets, _options) {
    const css = assets.css.filter(function (filename) {
      return filename.includes(cssName)
    }).map(function (filename) {
      return '<link href="' + assetServer + '/' + filename + '" rel="stylesheet"></link>\n'
    })

    const js = assets.js.filter(function (filename) {
      return filename.includes(jsName)
    }).map(function (filename) {
      return '<script type="text/javascript" src="' + assetServer + '/' + filename + '"></script>\n'
    })

    const images = Array.from(compilation.assetsInfo.keys()).filter(function (filename) {
      return filename.match(imageRegex)
    })

    const imageMatching = function (name) {
      const foundImage = images.find(function (filename) {
        return filename.includes(name)
      })
      if (!foundImage) { return '' }

      return assetServer + '/' + foundImage
    }

    return {
      assetServer: assetServer,
      title: title,
      css: css,
      js: js,
      imageMatching: imageMatching,
    }
  }
}

module.exports = {
  entry: {
    'home-styles':  './app/client/packs/home-styles.js',
    'admin-styles': './app/client/packs/admin-styles.js',
    'images':       './app/client/packs/images.js',
    'application':  './app/client/packs/application.js',
  },
  output: {
    path: path.resolve(__dirname, 'app/compiled_assets'),
    filename: "[name].[contenthash].js"
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        loader: 'babel-loader',
        exclude: /node_modules/
      },
      {
        test: /\.s?css$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          {
            loader: 'sass-loader',
            options: {
              sourceMap: true,
            },
          },
        ]
      },
      {
        test: imageRegex,
        loader: 'file-loader',
        options: {
          name: '[folder]/[name].[contenthash].[ext]',
        }
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.jsx', '.scss']
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: '[name].[contenthash].css',
      chunkFilename: '[id].css'
    }),
    new HtmlWebpackPlugin({
      filename: 'index.[hash:8].html',
      template: './app/client/pages/index.html',
      inject: false,
      templateParameters: templateParametersGenerator(
        'Dykaspora', 'home-styles', 'application'
      )
    }),
    new HtmlWebpackPlugin({
      filename: 'admin/index.[hash:8].html',
      template: './app/client/pages/index.html',
      inject: false,
      templateParameters: templateParametersGenerator(
        'Dykaspora Admin', 'admin-styles', 'application'
      )
    }),
    new ManifestPlugin({
      fileName: `../client/${manifestName}.json`,
      writeToFileEmit: true,
    })
  ],
}
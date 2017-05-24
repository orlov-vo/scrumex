'use strict'; // eslint-disable-line

const webpack = require('webpack');
const path = require('path');
const autoprefixer = require('autoprefixer');
const jeet = require('jeet');

const CopyWebpackPlugin = require('copy-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

const config = {
  cacheBusting: "[name]_[hash:8]",
  paths: {
    dist: path.resolve(__dirname, './priv/static/'),
    assets: path.resolve(__dirname, './web/static/')
  },
  enabled: {
    sourceMaps: true,
    cacheBusting: false
  },
  browsers: [
    "last 2 versions",
    "android 4",
    "opera 12",
  ],
};

const assetsFilenames = (config.enabled.cacheBusting) ? config.cacheBusting : '[name]';
const sourceMapQueryStr = (config.enabled.sourceMaps) ? '+sourceMap' : '-sourceMap';

module.exports = {
  entry: [
    './web/static/js/app.js',
    './web/static/styles/main.styl',
  ],
  output: {
    path: config.paths.dist,
    filename: 'js/app.js',
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        query: {
          presets: ['env'],
        },
      },
      {
        test: /\.css$/,
        include: config.paths.assets,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          publicPath: '../',
          use: [
            `css-loader?${sourceMapQueryStr}`,
            'postcss-loader',
          ],
        }),
      },
      {
        test: /\.scss$/,
        include: config.paths.assets,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          publicPath: '../',
          use: [
            `css-loader?${sourceMapQueryStr}`,
            'postcs-loaders',
            `resolve-url-loader?${sourceMapQueryStr}`,
            `sass-loader?${sourceMapQueryStr}`,
          ],
        }),
      },
      {
        test: /\.styl$/,
        include: config.paths.assets,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          publicPath: '../',
          use: [
            `css-loader?${sourceMapQueryStr}`,
            'postcss-loader',
            `resolve-url-loader?${sourceMapQueryStr}`,
            `stylus-loader?${sourceMapQueryStr}`,
          ],
        }),
      },
      {
        test: /\.(png|jpe?g|gif|svg|ico)$/,
        include: config.paths.assets,
        loader: 'file-loader',
        options: {
          name: `img/${assetsFilenames}.[ext]`,
        },
      },
      {
        test: /\.(ttf|eot)$/,
        include: config.paths.assets,
        loader: 'file-loader',
        options: {
          name: `fonts/${assetsFilenames}.[ext]`,
        },
      },
      {
        test: /\.woff2?$/,
        include: config.paths.assets,
        loader: 'url-loader',
        options: {
          limit: 10000,
          mimetype: 'application/font-woff',
          name: `fonts/${assetsFilenames}.[ext]`,
        },
      },
      {
        test: /\.(ttf|eot|woff2?|png|jpe?g|gif|svg)$/,
        include: /node_modules|bower_components/,
        loader: 'file-loader',
        options: {
          name: `vendor/${config.cacheBusting}.[ext]`,
        },
      },
    ],
  },
  plugins: [
    new CopyWebpackPlugin([
      {
        from: './web/static/assets/',
        to: './',
      },
    ]),
    new ExtractTextPlugin({
      filename: 'css/app.css',
      allChunks: true,
    }),
    new webpack.LoaderOptionsPlugin({
      test: /\.s?css$/,
      options: {
        output: { path: config.paths.dist },
        context: config.paths.assets,
        postcss: [
          autoprefixer({ browsers: config.browsers }),
        ],
      },
    }),
    new webpack.LoaderOptionsPlugin({
      test: /\.styl$/,
      options: {
        output: { path: config.paths.dist },
        context: config.paths.assets,
        postcss: [
          autoprefixer({ browsers: config.browsers }),
        ],
        stylus: {
          use: [jeet()],
        },
      },
    }),
  ],
}

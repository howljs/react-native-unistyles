const path = require('node:path')

/** @type {import('../../packages/unistyles/plugin').UnistylesPluginOptions} */
const unistylesPluginOptions = {
    debug: true,
    isLocal: true,
    localPath: path.join(__dirname, '../../packages/unistyles'),
    root: 'src'
}

module.exports = api => {
    api.cache(true)

    return {
        presets: ['module:@react-native/babel-preset'],
        plugins: [
            [
                path.join(__dirname, '../../packages/unistyles/plugin'),
                unistylesPluginOptions
            ],
            'react-native-worklets/plugin'
        ]
    }
}

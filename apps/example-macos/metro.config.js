const { getDefaultConfig } = require('@react-native/metro-config')
const path = require('node:path')

const projectRoot = __dirname
const monorepoRoot = path.resolve(projectRoot, '../..')
const libraryRoot = path.resolve(monorepoRoot, 'packages/unistyles')
const librarySource = path.resolve(libraryRoot, 'src/index.ts')
const config = getDefaultConfig(projectRoot)

config.watchFolders = [libraryRoot, monorepoRoot]
config.resolver.nodeModulesPaths = [
    path.resolve(projectRoot, 'node_modules'),
    path.resolve(monorepoRoot, 'node_modules')
]
config.resolver.resolveRequest = (context, moduleName, platform) => {
    if (moduleName === 'react-native-unistyles') {
        return {
            type: 'sourceFile',
            filePath: librarySource
        }
    }

    if (
        platform === 'macos'
        && (moduleName === 'react-native' || moduleName.startsWith('react-native/'))
    ) {
        return context.resolveRequest(
            context,
            moduleName.replace('react-native', 'react-native-macos'),
            platform
        )
    }

    return context.resolveRequest(context, moduleName, platform)
}

module.exports = config

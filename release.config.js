const config = {
  branches: ['main'],
  githubToken: process.env.GH_TOKEN || process.env.GITHUB_TOKEN,
  gitlabToken: process.env.GITLAB_TOKEN,
  plugins: [
    [
      'semantic-release-gitmoji',
      {
        releaseRules: {
          patch: {
            include: [':bug:', ':ambulance:', ':lock:', ':adhesive_bandage:']
          },
          minor: {
            include: [':sparkles:', ':rocket:', ':boom:', ':lipstick:', ':zap:']
          },
          major: {
            include: [':boom:', ':warning:']
          }
        }
      }
    ],
    '@semantic-release/commit-analyzer',
    [
      '@semantic-release/release-notes-generator',
      {
        preset: 'conventionalcommits',
        writerOpts: {
          types: [
            { type: 'feat', section: '✨ Features' },
            { type: 'fix', section: '🐛 Bug Fixes' },
            { type: 'perf', section: '⚡ Performance Improvements' },
            { type: 'revert', section: '⏪ Reverts' },
            { type: 'docs', section: '📚 Documentation' },
            { type: 'style', section: '💄 Styles' },
            { type: 'chore', section: '🔧 Miscellaneous' },
            { type: 'refactor', section: '♻️ Code Refactoring' },
            { type: 'test', section: '✅ Tests' },
            { type: 'build', section: '👷 Build System' },
            { type: 'ci', section: '🔄 CI/CD' }
          ]
        }
      }
    ],
    '@semantic-release/changelog',
    [
      '@semantic-release/git',
      {
        assets: ['CHANGELOG.md', 'package.json'],
        message:
          'Release ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}'
      }
    ],
    [
      '@semantic-release/github',
      {
        successComment:
          '🎉 This ${issue.pull_request ? "PR is included" : "issue has been resolved"} in version ${nextRelease.version}',
        failTitle: '❌ The release failed',
        failComment:
          'This release from branch ${branch.name} failed to publish.'
      }
    ]
  ]
}

export default config

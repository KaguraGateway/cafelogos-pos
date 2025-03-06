# Ignore inline messages which lay outside a diff's range
# github.dismiss_out_of_range_messages

# Check PR
warn("PRの説明が短すぎるよ！レビュアーが見て分かる説明を書いてね！ :cry:") if github.pr_body.length < 100

# Warn when there is a big PR
warn("PRのサイズが大きすぎるよ！可能であれば分割してね! :cry:") if git.lines_of_code > 1000

# Check and comment on swiftlint only in the range corrected by PR
swiftlint.verbose = true
swiftlint.binary_path = '/usr/bin/swiftlint' if !env.ci_source.kind_of?(LocalGitRepo)
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files inline_mode: true

workflow "New workflow" {
  on = "push"
  resolves = ["sqrt.pytest"]
}

action "sqrt.build" {
  uses = "actions/docker/cli@master"
  args = "build -t sqrt-$GITHUB_SHA:latest ."
}

action "sqrt.pytest" {
  uses = "actions/docker/cli@master"
  needs = ["sqrt.build"]
  args = "run sqrt-$GITHUB_SHA:latest pytest"
}

#action "git.master" {
#  uses = "actions/bin/filter@master"
#  needs = [“ruby.rubocop”, “ruby.rspec”]
#  args = “branch master”
#}

# Filter for branch
#action "filter.demo/github_actions" {
#  uses = "actions/bin/filter@master"
#  needs = 
#  args = "branch demo/github_actions"
#}
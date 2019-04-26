workflow "Build and push to Dockerhub" {
  resolves = [
    "Login to Dockerhub",
    "Push to Dockerhub",
  ]
  on = "push"
}

action "Login to Dockerhub" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  secrets = ["LOGIN_NAME", "PASSWORD"]
}

action "Build fortuneapp" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "[ \"build\", \"-t\", \"$DOCKER_TAG\", \".\" ]"
  env = {
    DOCKER_TAG = "chukmunnlee/fortuneapp:$(echo $GITHUB_SHA | head -c7)"
  }
}

action "Push to Dockerhub" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Build fortuneapp", "Login to Dockerhub"]
  args = "[\"push\", \"$DOCKER_TAG\" ]"
}

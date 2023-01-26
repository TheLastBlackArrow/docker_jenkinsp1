# ---- groups ----

group "linux" {
  targets = [
    "almalinux_jdk11",
    "alpine_jdk11",
    "alpine_jdk17",
    "centos7_jdk11",
    "debian_jdk11",
    "debian_jdk17",
    "debian_slim_jdk11",
    "debian_slim_jdk17",
    "rhel_ubi8_jdk11",
    "debian_slim_jdk11_arm32v6"
  ]
}

group "linux-arm-v6" {
  targets = [
    "debian_slim_jdk11_arm32v6"
  ]
}

group "linux-arm64" {
  targets = [
    "almalinux_jdk11",
    "debian_jdk11",
    "debian_jdk17",
    "rhel_ubi8_jdk11",
  ]
}

group "linux-s390x" {
  targets = [
    "debian_jdk11",
  ]
}

# ---- variables ----

variable "JENKINS_VERSION" {
  default = "2.375.2"
}

variable "JENKINS_SHA" {
  default = "e572525f7fa43b082e22896f72570297d88daec4f36ab4f25fdadca885f95492"
}

variable "REGISTRY" {
  default = "docker.io"
}

variable "JENKINS_REPO" {
  default = "lelai123/jenkins_pi1"
}

variable "LATEST_WEEKLY" {
  default = "false"
}

variable "LATEST_LTS" {
  default = "true"
}

variable "PLUGIN_CLI_VERSION" {
  default = "2.12.9"
}

variable "COMMIT_SHA" {
  default = ""
}

# ----  user-defined functions ----

# return a tag prefixed by the Jenkins version
function "_tag_jenkins_version" {
  params = [tag]
  result = notequal(tag, "") ? "${REGISTRY}/${JENKINS_REPO}:${JENKINS_VERSION}-${tag}" : "${REGISTRY}/${JENKINS_REPO}:${JENKINS_VERSION}"
}

# return a tag optionaly prefixed by the Jenkins version
function "tag" {
  params = [prepend_jenkins_version, tag]
  result = equal(prepend_jenkins_version, true) ? _tag_jenkins_version(tag) : "${REGISTRY}/${JENKINS_REPO}:${tag}"
}

# return a weekly optionaly prefixed by the Jenkins version
function "tag_weekly" {
  params = [prepend_jenkins_version, tag]
  result =  equal(LATEST_WEEKLY, "true") ? tag(prepend_jenkins_version, tag) : ""
}

# return a LTS optionaly prefixed by the Jenkins version
function "tag_lts" {
  params = [prepend_jenkins_version, tag]
  result =  equal(LATEST_LTS, "true") ? tag(prepend_jenkins_version, tag) : ""
}

# ---- targets ----

target "almalinux_jdk11" {
  dockerfile = "11/almalinux/almalinux8/hotspot/Dockerfile"
  context = "."
  args = {
    JENKINS_VERSION = JENKINS_VERSION
    JENKINS_SHA = JENKINS_SHA
    COMMIT_SHA = COMMIT_SHA
    PLUGIN_CLI_VERSION = PLUGIN_CLI_VERSION
  }
  tags = [
    tag(true, "almalinux"),
    tag_weekly(false, "almalinux"),
    tag_lts(false, "lts-almalinux")
  ]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "alpine_jdk11" {
  dockerfile = "11/alpine/hotspot/Dockerfile"
  context = "."
  args = {
    JENKINS_VERSION = JENKINS_VERSION
    JENKINS_SHA = JENKINS_SHA
    COMMIT_SHA = COMMIT_SHA
    PLUGIN_CLI_VERSION = PLUGIN_CLI_VERSION
  }
  tags = [
    tag(true, "alpine"),
    tag_weekly(false, "alpine"),
    tag_weekly(false, "alpine-jdk11"),
    tag_lts(false, "lts-alpine"),
    tag_lts(false, "lts-alpine-jdk11"),
    tag_lts(true, "lts-alpine"),
  ]
  platforms = ["linux/amd64"]
}

target "alpine_jdk17" {
  dockerfile = "17/alpine/hotspot/Dockerfile"
  context = "."
  args = {
    JENKINS_VERSION = JENKINS_VERSION
    JENKINS_SHA = JENKINS_SHA
    COMMIT_SHA = COMMIT_SHA
    PLUGIN_CLI_VERSION = PLUGIN_CLI_VERSION
  }
  tags = [
    tag(true, "alpine-jdk17"),
    tag_weekly(false, "alpine-jdk17"),
    tag_lts(false, "lts-alpine-jdk17")
  ]
  platforms = ["linux/amd64"]
}

target "centos7_jdk11" {
  dockerfile = "11/centos/centos7/hotspot/Dockerfile"
  context = "."
  args = {
    JENKINS_VERSION = JENKINS_VERSION
    JENKINS_SHA = JENKINS_SHA
    COMMIT_SHA = COMMIT_SHA
    PLUGIN_CLI_VERSION = PLUGIN_CLI_VERSION
  }
  tags = [
    tag(true, "centos7"),
    tag_weekly(false, "centos7"),
    tag_weekly(false, "centos7-jdk11"),
    tag_lts(true, "lts-centos7"),
    tag_lts(false, "lts-centos7"),
    tag_lts(false, "lts-centos7-jdk11")
  ]
  platforms = ["linux/amd64"]
}

target "debian_jdk11" {
  dockerfile = "11/debian/bullseye/hotspot/Dockerfile"
  context = "."
  args = {
    JENKINS_VERSION = JENKINS_VERSION
    JENKINS_SHA = JENKINS_SHA
    COMMIT_SHA = COMMIT_SHA
    PLUGIN_CLI_VERSION = PLUGIN_CLI_VERSION
  }
  tags = [
    tag(true, ""),
    tag(true, "jdk11"),
    tag_weekly(false, "latest"),
    tag_weekly(false, "latest-jdk11"),
    tag_weekly(false, "jdk11"),
    tag_lts(false, "lts"),
    tag_lts(false, "lts-jdk11"),
    tag_lts(true, "lts"),
    tag_lts(true, "lts-jdk11")
  ]
  platforms = ["linux/amd64", "linux/arm64", "linux/s390x"]
}

target "debian_jdk17" {
  dockerfile = "17/debian/bullseye/hotspot/Dockerfile"
  context = "."
  args = {
    JENKINS_VERSION = JENKINS_VERSION
    JENKINS_SHA = JENKINS_SHA
    COMMIT_SHA = COMMIT_SHA
    PLUGIN_CLI_VERSION = PLUGIN_CLI_VERSION
  }
  tags = [
    tag(true, "jdk17"),
    tag_weekly(false, "latest-jdk17"),
    tag_weekly(false, "jdk17"),
    tag_lts(false, "lts-jdk17"),
    tag_lts(true, "lts-jdk17")
  ]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "debian_slim_jdk11_arm32v6" {
  dockerfile = "11/debian/bullseye-slim/arm32v6/Dockerfile"
  context = "."
  args = {
    JENKINS_VERSION = JENKINS_VERSION
    JENKINS_SHA = JENKINS_SHA
    COMMIT_SHA = COMMIT_SHA
    PLUGIN_CLI_VERSION = PLUGIN_CLI_VERSION
  }
  tags = [
    tag(false, "jdk11"),
  ]
  platforms = ["linux/arm/v6"]
}

target "debian_slim_jdk11" {
  dockerfile = "11/debian/bullseye-slim/hotspot/Dockerfile"
  context = "."
  args = {
    JENKINS_VERSION = JENKINS_VERSION
    JENKINS_SHA = JENKINS_SHA
    COMMIT_SHA = COMMIT_SHA
    PLUGIN_CLI_VERSION = PLUGIN_CLI_VERSION
  }
  tags = [
    tag(true, "slim"),
    tag_weekly(false, "slim"),
    tag_weekly(false, "slim-jdk11"),
    tag_lts(false, "lts-slim"),
    tag_lts(false, "lts-slim-jdk11"),
    tag_lts(true, "lts-slim"),
  ]
  platforms = ["linux/amd64"]
}

target "debian_slim_jdk17" {
  dockerfile = "17/debian/bullseye-slim/hotspot/Dockerfile"
  context = "."
  args = {
    JENKINS_VERSION = JENKINS_VERSION
    JENKINS_SHA = JENKINS_SHA
    COMMIT_SHA = COMMIT_SHA
    PLUGIN_CLI_VERSION = PLUGIN_CLI_VERSION
  }
  tags = [
    tag(true, "slim-jdk17"),
    tag_weekly(false, "slim-jdk17"),
    tag_lts(false, "lts-slim-jdk17"),
  ]
  platforms = ["linux/amd64"]
}

target "rhel_ubi8_jdk11" {
  dockerfile = "11/rhel/ubi8/hotspot/Dockerfile"
  context = "."
  args = {
    JENKINS_VERSION = JENKINS_VERSION
    JENKINS_SHA = JENKINS_SHA
    COMMIT_SHA = COMMIT_SHA
    PLUGIN_CLI_VERSION = PLUGIN_CLI_VERSION
  }
  tags = [
    tag(true, "rhel-ubi8-jdk11"),
    tag_weekly(false, "rhel-ubi8-jdk11"),
    tag_lts(false, "lts-rhel-ubi8-jdk11"),
    tag_lts(true, "lts-rhel-ubi8-jdk11")
  ]
  platforms = ["linux/amd64", "linux/arm64"]
}

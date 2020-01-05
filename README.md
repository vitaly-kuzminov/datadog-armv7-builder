# Datadog ARMv7 Builder

The present repository provides a Docker image to build the [Datadog Agent][1]
from source. The build happens in two steps:
1. Building the container using the `Dockerfile`, creates a container with needed
  requirements.
2. Running the container, triggers the actual build.

**Note:** This is an unofficial repository to build the Datadog Agent for ARMv7
CPUs. For supported platforms and CPUs, check the [Datadog Agent documentation][2].

## Quickstart

Clone the repository and run the following `docker` (or `podman`) commands:

```bash
$ git clone git@github.com:palazzem/datadog-armv7-builder.git && cd datadog-armv7-builder
$ docker build -t dd-agent-armv7-builder:latest .
$ docker run --rm -v $(pwd)/out:/go/src/github.com/DataDog/datadog-agent/target dd-agent-armv7-builder:latest
```

After the process finishes, you can find the Agent build inside the `out/` folder.

## Automatic Builds

Every time a commit lands on `master`, a [GitHub action is executed][3] to build the
container, and later the package. The output of the build is available as an artifact.

[1]: https://github.com/datadog/datadog-agent
[2]: https://docs.datadoghq.com/agent/
[3]: https://github.com/palazzem/datadog-armv7-builder/actions

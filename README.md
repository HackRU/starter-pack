# HackRU starter pack

Maybe we'll explain it here.

Everything below is a sort of development documentation.

**Warning**: there is a submodule! Remember to `git submodule init && git submodule update` like once.

## The test-x folder (here be dragons)

There are files in here (uwu):
* `Dockerfile` (kinda deprecated, but we'll keep it until everything works):
  runs a local docker instance that lets you forward X to a local X.
  It's a proof-of-concept.
* `run-docker.sh`: runs the above docker instance. Proof-of-concept.
* `run-ssh.sh` runs a docker instance with xpra and outputs all sorts of
  useful info about it (the password to the docker account, for instance).
  Takes the port to bind to 22 as a parameter.
* `run-ssh-ec2.sh` drives the above, but from the client-side. So it gets
  the server to spawn a docker instance and then attaches to the xpra
  session. This will prompt you for the docker user's password.
  The first argument is the path to a pem file and the second a URL.
  This works for ec2's. See the top of the file for this again - but with an example.
* `docker-image`: this folder is a submodule with the relevant docker
  doo-hickies for the xpra docker. (we may have to roll our own :sob:.)

### Gotchas

Above when I say "docker user" I mean a user of the container made called
docker. This user has access to X. X only exists in the container and
the client. The server may not have it.

Xpra produces a crap ton of output. Make sure you can scroll or memorize
gibberish passwords quickly.

Xpra loads, but into... something I don't get. Investigation will be done.

## ECS Tutorial

The `ecs_tutorial` directory contains a shell script, `tutorial.sh`,
that runs the Amazon Elastic Cloud Service
[tutorial](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_tutorial_fargate.html).
The script works with `bash`'s emulation of `sh` and with `dash`,
so it should work with any other `sh`.
The tutorial depends on the AWS CLI,
which you can install with `pip install awscli`,
and on the ECS CLI, which I installed through the Arch User Repository
(the ECS CLI is written in Go, if you're curious).
Note that the tutorial assumes that `aws` is aliased to `python -m awscli`
(the script creates this alias itself because it doesn't inherit aliases).
You will also need to configure the AWS CLI if you haven't already,
as explained in the Prerequisites section of the tutorial.
The AWS CLI is not capable of deleting Virtual Private Clouds (VPCs)
if they have active dependencies, as they will at the end of the tutorial,
so when the deletion inevitably fails,
you will need to delete the VPC through the console.
The CloudFormation stack deletion will wait for ten minutes
before it times out, so you don't have to rush to delete the VPC.

Maybe we should make each code sample a separate cluster.
For example, if we have a coding sample for Makefiles,
we would add a container to the Makefiles cluster
each time a new user wants to use the Makefiles sample.
The next thing to do here is probably to see if we can rewrite the script
in Python so that it can interface with the rest of our codebase
(and so that we don't have to do janky shell script stuff
just to populate variables).

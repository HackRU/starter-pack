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

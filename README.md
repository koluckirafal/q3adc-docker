# Lilium Arena Classic in Docker

Lilium Arena Classic dedicated server in Docker.

## Usage

```
$ docker build .
$ docker volume create dcquake
$ # copy pak0.pk3 to dcquake docker volume
$ docker run -it --name dcquake --mount source=dcquake,target=/home/quake3/baseq3 container-id
```

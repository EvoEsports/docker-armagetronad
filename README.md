<p align="center">
  <img src="https://github-production-user-asset-6210df.s3.amazonaws.com/4627720/239994145-589884d2-3f0f-4ae0-8926-c015cbd3bcb3.png?raw=true" alt="Armagetron image" height="100"/>
</p>
<p align="center">
    <a href="https://hub.docker.com/r/evoesports/armagetronad">
        <img src="https://img.shields.io/docker/stars/evoesports/armagetronad?&style=flat-square"
            alt="docker stars"></a>
    <a href="https://hub.docker.com/r/evoesports/armagetronad">
        <img src="https://img.shields.io/docker/pulls/evoesports/armagetronad?style=flat-square"
            alt="docker pulls"></a>
    <a href="https://hub.docker.com/r/evoesports/armagetronad">
        <img src="https://img.shields.io/docker/v/evoesports/armagetronad?style=flat-square"
            alt="docker image version"></a>
    <a href="https://hub.docker.com/r/evoesports/armagetronad">
        <img src="https://img.shields.io/docker/image-size/evoesports/armagetronad?style=flat-square"
            alt="docker image size"></a>
    <a href="https://discord.gg/evotm">
        <img src="https://img.shields.io/discord/384138149686935562?color=%235865F2&label=discord&logo=discord&logoColor=%23ffffff&style=flat-square"
            alt="chat on Discord"></a>
</p>
This image will start an Armagetron Advanced/Retrocycles server. You can also start a master server with it.

## Table of Contents
- [Table of Contents](#table-of-contents)
- [How to use this image](#how-to-use-this-image)
  - [... with 'docker run'](#-with-docker-run)
  - [... with 'docker compose'](#-with-docker-compose)
- [Environment Variables](#environment-variables)
- [Contributing](#contributing)


## How to use this image
### ... with 'docker run'
To start an Armagetron Advanced server with `docker run`:
```shell
docker run \
  -p 4534:4534/udp \
  -v armagetron_data:/armagetronad \
  evoesports/armagetronad:latest
```

### ... with 'docker compose'
To do the same with `docker compose`:
```yaml
version: "3.8"
services:
  armagetron:
    image: evoesports/armagetronad:latest
    ports:
      - 4534:4534/udp
    volumes:
      - armagetron_data:/armagetronad
volumes:
  armagetron_data:
```
In both cases, the server will launch and be bound to port 4534 UDP.
The server only needs one volume to store all your data, which is mounted to /armagetron. You can also use bind mounts.

## Environment Variables
| **Environment Variable**         | **Description**                                                                                                               | **Default Value**    | **Required** |
|----------------------------------|-------------------------------------------------------------------------------------------------------------------------------|--------------------------|:------------:|
| `MASTERSERVER`                   | Whether you want to launch a normal gameserver or a master server.                                                                          | False                     |              |

## Contributing
If you have any questions, issues, bugs or suggestions, don't hesitate and open an [Issue](https://github.com/evoesports/docker-armagetronad/issues/new)! You can also join our [Discord](https://discord.gg/evoesports) for questions.

You may also help with development by creating a pull request.

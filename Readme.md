# Migrate Mercurial (HG) to Git repository directly between remotes

Container to migrate from Mercurial repository into Git repository, directly between remotes via Docker container.

```text
Mercurial --pull--> [This Container] --push--> Git
```

I developed this for my own use case but thought I'd share this.

**Please test this yourself first** - I hacked this up in a day so use at your own risk 😉 .

## Dependencies

Basically a recent version of `docker` and `docker-compose` - developed with these:

- Docker >= 20.10.12
- docker-compose >= 1.29.2

## Usage

1. Create your needs-specific `docker-compose.yml` (See [docker-compose.yml.template](./docker-compose.yml.template) for help)

    ```bash
    # Make a copy from template
    cp docker-compose.yml.template docker-compose.yml

    # Edit it to your needs
    vim docker-compose.yml
    ```

2. Run the migration container:

    ```bash
    ./run-hg-git-migration.sh
    ```

3. Profit 😋

## To Develop

1. Create `docker-compose.yml` (see above)
2. Run this in special debug mode

    ```bash
    ./run-hg-git-migration.sh development
    ```

3. Get shell into container

    ```bash
    ./bash_shell-hg-git-migration.sh
    ```

## Credits

My work wouldn't be possible with these awesome people!

- Frej Drejhammar (frej): For his [fast-export](https://github.com/frej/fast-export) code!
- Git Team: For their [mercurial to Git conversion guide](https://git-scm.com/book/en/v2/Git-and-Other-Systems-Migrating-to-Git#_mercurial)

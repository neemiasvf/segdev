# Segdev

Segdev is a focused application created for Segdev's coding challenge #2.

It calculates the risk profile for different insurance lines (auto, disability, home, and life) based on the customer's information.

See `README-desafio2.md` or [Segdev's challenge #2](https://github.com/segdev-tecnologia/vagas/blob/main/backend/desafio2/README.md) for more details.

## Table of Contents

- [Configuration](#configuration)
  - [ENVs, Credentials and Secrets](#envs-credentials-and-secrets)
    - [Database Credentials](#database-credentials)
    - [Rails Credentials](#rails-credentials)
    - [Docker Secrets](#docker-secrets)
    - [Additional Environment Variables](#additional-environment-variables)
  - [Directory Structure](#directory-structure)
  - [Additional Configuration](#additional-configuration)
    - [Active Model Serializers](#active-model-serializers)
    - [Annotate](#annotate)
- [Running the Application](#running-the-application)
  - [Locally](#locally)
  - [Using Docker](#using-docker)
- [Running Tests](#running-tests)
- [API Documentation](#api-documentation)

## Configuration

### ENVs, Credentials and Secrets

Environment variables are defined in `.env.<environment>`. These should only contain **non-sensitive** information.

**Sensitive** information is stored in the Rails credentials file and Docker secrets. They are versioned in development and test environments only as an example.

The application relies on the following environment variables and secrets:

#### **Database Credentials**

- PostgreSQL User
  - Stored in Rails credentials under key `db.user`.
  - Stored in `docker/secrets/<environment>/postgres_user`.
  - Referenced as `POSTGRES_USER_FILE` in compose files.
  - Default to `rails`.

- PostgreSQL Password
  - Stored in Rails credentials under key `db.password`.
  - Stored in `docker/secrets/<environment>/postgres_password`.
  - Referenced as `POSTGRES_PASSWORD_FILE` in compose files.

- PostgreSQL Database
  - Stored in `.env.<environment>`.
  - Defaults to `segdev_<environment>`.
  
#### **Rails Credentials**

- Credentials Path
  - Stored as a Docker secret.
  - Defaults to `config/credentials`.

- Credentials File
  - Stored in credentials path as `<environment>.key` and `<environment>.yml.enc`.
  - Run `rails credentials:show -e <environment>` to view the credentials:

    ``` yaml
    # Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
    secret_key_base: <secret_key_base>

    db:
      username: <db_user>
      password: <db_password>
    ```

#### **Docker Secrets**

- Docker Secrets Path
  - Stored in `.env.<environment>` as `DOCKER_SECRETS_PATH`.
  - Defaults to `/run/secrets`.
  - Takes precedence over the default Rails credentials path and is used to set the app's `credentials.key_path` and `credentials.content_path`.
  - See [Docker Secrets](https://docs.docker.com/compose/use-secrets/) and `config/application.rb` for more details.

#### **Additional Environment Variables**

- `RAILS_ENV`: The Rails environment. explain their role in for Docker compose files;

### Directory Structure

``` plaintext
segdev
├── config
│   ├── credentials (ignored by Docker)
│   │   ├── development.key
│   │   ├── development.yml.enc
│   │   ├── production.key (ignored by git)
│   │   ├── production.yml.enc
│   │   ├── test.key
│   │   └── test.yml.enc
├── docker
│   └── secrets (ignored by Docker)
│       ├── development
│       │   ├── postgres_user
│       │   └── postgres_password
│       ├── production (ignored by git)
│       │   ├── postgres_user
│       │   └── postgres_password
│       └── test
│           ├── postgres_user
│           └── postgres_password
├── .env.development
├── .env.test
└── .env.production (ignored by git)
```

### Additional Configuration

#### Active Model Serializers

The application is configured to use `active_model_serializers` with the `:json` adapter. See `initializers/active_model_serializers.rb` for more details.

#### Annotate

The application is configured to automatically annotate certain kinds of files. See `lib/auto_annotate_models.rake` for more details.

## Running the Application

### Locally

To run the application locally, make sure you have:

- the same Ruby version and gemset from `.ruby-version` and `.ruby-gemset`, respectively.
- `libpq-dev` (Postgres C API library), required to compile the `pg` gem.
- a PostgreSQL instance up and running with the same credentials from the credentials file.
  - alternatively, you can run `docker compose -f docker/compose.dev.yml up db -d` to have Docker initialize ONLY the database instance.
  - in `docker/compose.dev.yml`, uncomment the line that exposes PostgreSQL socket to the host.

Then you can:

``` bash
# Install gems with bundler
bundle

# Prepare the database
rails db:prepare

# Run the test suite
rspec

# Run the application
rails s
```

### Using Docker

To run the application with Docker:

``` bash
docker compose -f docker/compose.dev.yml up -d
```

## Running Tests

To run the test suite locally:

``` bash
rspec
```

To run the test suite with Docker:

``` bash
docker compose -f docker/compose.test.yml run app rspec
```

## API Documentation

The API documentation is located at `docs/api.yml`.

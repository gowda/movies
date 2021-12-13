# imdb
![](https://github.com/gowda/imdb/workflows/lint/badge.svg)

Clone of imdb exported dataset from [IMDb Datasets](https://www.imdb.com/interfaces/)

## Initialize database
```bash
$ bin/rails db:setup
$ bin/rails db:migrate
```

## Google API credentials
Please follow the instructions from [Prerequisites](https://developers.google.com/identity/protocols/oauth2/web-server#prerequisites) for [Using OAuth 2.0 for Web Server Applications](https://developers.google.com/identity/protocols/oauth2/web-server) guide to setup & download credentials file.

Assuming the downloaded file name is `client_secret.json`, set the environment variable in `.env.development`:
```diff
-GOOGLE_CLIENT_CONFIG=
+GOOGLE_CLIENT_CONFIG=client_secret.json
```

## Import IMDb data
```bash
$ bin/rails import:parse_and_load
```

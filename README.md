# imdb
![](https://github.com/gowda/imdb/workflows/lint/badge.svg)

Clone of imdb exported dataset from [IMDb Datasets](https://www.imdb.com/interfaces/)

## Initialize database
```bash
$ bin/rails db:setup
$ bin/rails db:migrate
```

## Import IMDb data
```bash
$ bin/rails import:parse_and_load
```

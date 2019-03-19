@echo off

docker build ^
        --tag cn-datascience-notebook:0 ^
        --rm ^
        --compress ^
        .
docker system prune
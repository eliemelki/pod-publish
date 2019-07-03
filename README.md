# Pod Package

Shell scripts to publish pods



## Publish to truck

Publish to trunk, will
- clone the repo
- create a tag
- publish it to pod trunk.

```
 ./pod-publish-trunk.sh ${GIT_URL}

```



## Publish to private repo

Publish to private, will
- register private repo
- clone the repo
- create a tag
- publish it to private pod .

```
 ./pod-publish-private.sh ${GIT_URL} ${POD_SPEC_NAME} ${POD_SPEC_URL}

```


## Create tag

Create tag, will
- clone the repo
- create a tag

```
 ../pod-create-tag ${GIT_URL}

```


## Register private repo

```
 ./pod-register-private ${POD_SPEC_NAME} ${POD_SPEC_URL}

```
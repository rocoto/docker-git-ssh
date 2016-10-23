# docker-git+ssh


```sh
docker run --name web nginx -v /usr/share/nginx

docker run \
  -e "SSH_KEY=$(cat ~/.ssh/id_rsa.pub)" \
  -e "RELEASE_SRC=dist" \
  -e "RELEASE_DEST=/usr/share/nginx/html" \
  --volumes-from web \
  rocoto/git-ssh
```

### Environment Vars

* `SSH_KEY`
* `RELEASE_BRANCH`
* `RELEASE_SRC`: Optional relative path within the repository to files to be
  placed in the `RELEASE_DEST`.
* `RELEASE_DEST`


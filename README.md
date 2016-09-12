# steeltoe-ci

Config files for Steeltoe CI, (https://ci.shoetree.io).

## Changing pipelines

Change the files, then:

```bash
fly -t shoetree set-pipeline -l <(lpass show --notes 'Shared-Steeltoe/concourse.yml') -p integration -c pipelines/integration.yml
```

## Creating docker images

### Base image, `cf-cli`
```bash
(cd dockerfiles/cf-cli && docker build -t dgodd/cf-cli . && docker push dgodd/cf-cli)
```

### Base image, `cf-space-resource`
```bash
(cd dockerfiles/cf-space-resource && docker build -t dgodd/cf-space-resource . && docker push dgodd/cf-space-resource)
```

### For pcfdev windows machine

Install using (after changing MACHINE_IP)

```
wget  misty-sisters.surge.sh/garden.zip
```

Install the https certificate on linux and windows since it is self signed



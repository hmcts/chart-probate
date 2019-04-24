# chart-probate

This chart is intended for deploying the full Probate product stack.
Including:
* Frontend
* Back-Office (with CCD)
* Persistence-service
* Orchestrator
* Business-service
* Caveats
* Submit-service


## Example configuration

Below is example configuration for running this chart on a PR, it could easily be tweaked to work locally if you wish, PRs to make that simpler are welcome.

requirements.yaml
```yaml
dependencies:
  - name: chart-probate
    version: '0.1.0'
    repository: '@hmcts'
```

The `SERVICE_FQDN`, `INGRESS_IP` and `CONSUL_LB_IP` are all provided by the pipeline, but require you to pass them through

values.template.yaml
```yaml

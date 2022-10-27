# action-netlify-cli

This action enables arbitrary actions with the [Netlify CLI](https://github.com/netlify/cli)

This action is a replacement for `netlify/actions/cli@master` _without_ the docker layer that incurs an extra 30-50s of runner time (which seems result in an average deploy time of ~1m 30s).

This action usually completes in under a minute (and in best cases, 30s).

## Secrets

- `NETLIFY_AUTH_TOKEN` - _Required_ The token to use for authentication. [Obtain one with the UI](https://www.netlify.com/docs/cli/#obtain-a-token-in-the-netlify-ui)
- `NETLIFY_SITE_ID` - _Optional_ API site ID of the site you wanna work on [Obtain it from the UI](https://www.netlify.com/docs/cli/#link-with-an-environment-variable)

## Outputs

The following outputs will be available from a step that uses this action:

- `NETLIFY_OUTPUT`, the full stdout from the run of the `netlify` command
- `NETLIFY_LOGS_URL`, the URL where the logs from the deploy can be found
- `NETLIFY_DRAFT_URL`, the URL of the draft site that Netlify provides
- `NETLIFY_PROD_URL`, the URL of the "real" site, set only if `--prod` was passed

## Recipes

### Simple publish

```yml
on: [push]
jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      # build your site for deployment... in this case the `public` folder is being deployed

      - name: Publish
        uses: South-Paw/action-netlify-cli@v1
        id: netlify
        with:
          # be sure to escape any double quotes with a backslash and note that the --json
          # flag has been passed when deploying - if you want the outputs to work you'll need to include it
          args: 'deploy --json --dir \"./public\" --message \"draft [${{ github.sha }}]\"'
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}

      # and access outputs in other steps with ${{ steps.netlify.outputs.OUTPUT_ID }}
```

### GitHub deployments

```yml
on: [push]
jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - name: Start deployment
        uses: bobheadxi/deployments@v1
        id: deployment
        with:
          env: production
          step: start

      # ... steps to build your site for deployment

      - name: Deploy to Netlify
        uses: South-Paw/action-netlify-cli@v1
        id: netlify
        with:
          args: deploy --json --prod --dir './public' --message 'production [${{ github.sha }}]'
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}

      - name: Finish deployment
        uses: bobheadxi/deployments@v1
        if: always()
        with:
          env: ${{ steps.deployment.outputs.env }}
          step: finish
          status: ${{ job.status }}
          deployment_id: ${{ steps.deployment.outputs.deployment_id }}
          env_url: ${{ steps.netlify.outputs.NETLIFY_PROD_URL }}
```

## Issues and Bugs

If you find any, please report them [here](https://github.com/South-Paw/action-netlify-cli/issues) so they can be squashed.

## License

MIT, see the [LICENSE](https://github.com/South-Paw/awesome-gatsby-starter/blob/master/LICENSE) file.

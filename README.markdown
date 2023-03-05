# CodeEngine Rake Tasks

A collection of Rake tasks for working with IBM Cloud Code Engine projects

# Installation

1. Add the gem to your project:

   ```command
   $ bundle add code-engine-tasks
   ```

1. Require the gem in your `Rakefile`:

   ```ruby
   require 'code_engine/tasks'
   ```

# Prerequisites

The following envrionment variables need to be set:

```command
export CE_ACCOUNT=XXXXXXXX1234YYYYYYYY5678ZZZZZZZZ
export CE_PROJECT=presentations
export CE_APP=concourse-resource-presentation
export CE_REGION=eu-de
```

Optionally, `CE_RESOURCE_GROUP` can be set; it defaults to `default`.

How to get these values:

* `CE_ACCOUNT` - running `ibmcloud account list` and use the "Account GUID" of the account the project resides in
* `CE_REGION` - the region where your Code Engine app should run in (use `rake ce:regions` or check [the list](https://cloud.ibm.com/docs/codeengine?topic=codeengine-regions) for possible values)
* `CE_PROJECT` - the name of your Code Engine project. Find existing ones with `ibmcloud ce project list` or provide the name for a new one, which will be created.
* `CE_APP` - the name of your Code Engine app. Find existing ones with `ibmcloud ce application list` or provide the name for a new one, which will be created.

# Usage

> All Rake tasks have documentation; use `rake --tasks` to show it.

If the app does not already exist, create a new one with

```command
$ rake ce:app:create
```

Subsequent updates of the app can be performed with

```command
$ rake ce:app:update
```

The URL of the app can be shown with

```command
$ rake ce:app:url
```

# TODO

- cli tool to generate a boilerplate project (`ce init --type static-web-app`)


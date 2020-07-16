puppet-churchoffoxx
===================

Puppet configuration for the Church of Foxx.  This configuration features roles and profiles and external modules.

# Layout

* `dist`: bundled Puppet modules. This is to be avoided but sometimes due to restrictions it may be unavoidable.
* `manifests`: classifier code for nodes, this is usually hit first. These files break down which nodes need to use which role which drives the profiles.
* `modules`: this directory does not exist in the repo, but will be created when using `r10k` from the modules in the `Puppetfile`.
* `site`: roles and profiles.
  * `roles/manifests`: role manifests. These include profiles per class or "role" of a node. A role may have many profiles, but no role should include another role.
  * `profiles/manifests`: profile manifests. These do the actual work of including modules and Puppet-specific code.

# Usage

The default way to use this repo is in full standalone _without_ Puppet Server. This means using `puppet apply` directly:

```
puppet apply /etc/puppet/code/environments/production/manifests/live.pp
```

This will allow you to break apart the Puppet code into stages if required due to complicated deployments. A two-stage deployment from Packer for instance would be done as:

```
puppet apply /etc/puppet/code/environments/production/manifests/packer.pp
puppet apply /etc/puppet/code/environments/production/manifests/live.pp
```

A standard Puppet Server-based deploy may also be done with the `site.pp`:

```
puppet apply /etc/puppet/code/environments/production/manifests/site.pp
```

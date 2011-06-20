# init.pp

Accepts parameters of version (present, latest, or specific version number) as well as booleans for master, agent, and dashboard.  If dashboard is true, it includes the Class['dashboard'].

# agent.pp

Configures puppet agent package, service, puppet.conf (concat), and ensures the cron setting is present.

# master.pp

Configures the puppet master package, service, puppet.conf (concat), init script, Passenger (if needed), and Storeconfigs (if needed).

# NEED TODO #

Strip out Passenger, Dashboard, and storeconfigs to their own separate classes.  Fix all OS-specific logic, validate params, ensure portability.
What about certname? Agent AND master?
What about agent vs. master ssldir/vardir?
Better method than concat?

## Questions ##
* With Validation - would be easier to define variables like $v_alphanum in stdlib if we use them frequently?
* Where should validation occur - especially if we're calling out to dependent classes?
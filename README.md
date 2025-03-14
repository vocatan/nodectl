# pgEdge NodeCtl : Command Line Interface

NODECTL is the pgEdge Command Line Interface (CLI).  It is a cross-platform 
tool to manage your PostgreSQL eco-system of components.  The modules are 
`um`, `service`, `spock`, and `cluster`.  We are licensed under the 
pgEdge Community License 1.0

## Synopsis
    ./nodectl <module> <command> [parameters] [options] 

## `um` Update Manager commands
```
list                Display available/installed components
update              Retrieve new list of latest components & update nodectl
install             Install a component (eg pg15, spock, postgis)
remove              Un-install component
upgrade             Perform an upgrade of a component
clean               Delete downloaded component files from local cache
```

## `service` Service control commands
```
start               Start server components
stop                Stop server components
status              Display status of installed server components
reload              Reload server config files (without a restart)
restart             Stop & then start server components
enable              Enable a server component
disable             Disable component from starting automatically
config              Configure a component
init                Initialize a component
```

## `spock` Logical and Multi-Active PostgreSQL node configuration
```
tune                 Tune for this configuration
node-create          Define a node for spock
node-drop            Remove a spock node
node-alter-location  Set location details for spock node
node-list            Display node table
node-add-interface   Add a new node interafce
node-drop-interface  Delete a node interface
repset-create        Define a replication set
repset-alter         Modify a replication set
repset-drop          Remove a replication set
repset-add-table     Add table(s) to replication set
repset-remove-table  Remove table from replication set
repset-add-seq       Add a sequence to a replication set
repset-remove-seq    Remove a sequence from a replication set
repset-alter-seq     Change a replication set sequence
repset-list-tables   List tables in replication sets
sub-create           Create a subscription
sub-drop             Delete a subscription
sub-alter-interface  Modify an interface to a subscription
sub-enable           Make a subscription live
sub-disable          Put a subscription on hold and disconnect from provider
sub-add-repset       Add a replication set to a subscription
sub-remove-repset    Drop a replication set from a subscription
sub-show-status      Display the status of the subcription
sub-show-table       Show subscription tables
sub-sync             Synchronize a subscription
sub-resync-table     Resynchronize a table
sub-wait-for-sync    Pause until the subscription is synchronized
table-wait-for-sync  Pause until a table finishes synchronizing
health-check         Check if PG instance is accepting connections
metrics-check        Retrieve advanced DB & OS metrics
set-readonly         Turn PG read-only mode 'on' or 'off'
```

## `cluster` Installation and configuration of a SPOCK cluster
```
create-local        Create local cluster of N pgEdge nodes on different ports
destroy             Stop and then nuke a cluster
validate            Validate a remote cluster configuration
init                Initialize a remote cluster for SPOCK
command             Run nodectl command on one or all nodes of a cluster
diff-tables         Compare table on different cluster nodes
```

## Options
```
--json           Turn on JSON output
--debug          Turn on debug logging
--silent         Less noisy
--verbose or -v  More noisy
```


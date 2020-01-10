EasyBuild easyconfigs files for building and installing RStudio Server versions on HPC.


Usage
-----------------------------------------------------------------------------

```
rserver --server-daemonize=0 --www-port 8787 --rsession-which-r=$(which R) --auth-none=1
```
Useful parameters
- `--www-address arg (=0.0.0.0)`	server address
- `--www-port arg`			port to listen on
- `--server-working-dir arg (=/)` 	program working directory
- `--server-daemonize arg (=0)` 	run program as daemon
- `--rsession-which-r arg` 		path to main R program (e.g. /usr/bin/R)
- `--auth-none arg (=1)` 		don't do any authentication 


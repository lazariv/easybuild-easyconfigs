#!/bin/bash

if [ -z ${SLURM_JOB_ID+x} ]; then
  echo "Please request resources first! RStudio is not supposed to be running on login nodes."
  exit 0

else

  port=8787  # the default port, could be generated on startup
  ip_list=`hostname -I`
  set -- $ip_list
  link=http://$1:$port
  
  CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  USER=`whoami`
  # set a user-specific secure cookie key
  COOKIE_KEY_PATH="/tmp/rstudio-server/${USER}_secure-cookie-key"
  rm -f $COOKIE_KEY_PATH
  mkdir -p $(dirname $COOKIE_KEY_PATH)  
  python -c 'import uuid; print(uuid.uuid4())' > $COOKIE_KEY_PATH
  chmod 600 $COOKIE_KEY_PATH
  
  unset XDG_RUNTIME_DIR 
  export MODULEPATH="/sw/modules/taurus/environment" 
  LMOD_CMD="/usr/share/lmod/lmod/libexec/lmod"

  if [[ `uname -a` =~ ppc ]]; then
    export LMOD_SYSTEM_DEFAULT_MODULES=modenv/ml
    export RSTUDIO_ROOT="/projects/zihforschung/lazariv/rstudio-server-ml"
    R_DEFAULT_MODULE="R/3.6.0-fosscuda-2019a"  
  else
    export LMOD_SYSTEM_DEFAULT_MODULES=modenv/scs5
    export RSTUDIO_ROOT="/projects/zihforschung/lazariv/rstudio-server-x86_64"  
    R_DEFAULT_MODULE="R/3.5.1-fosscuda-2018b"
  fi

  eval `$LMOD_CMD sh reset` 
  eval `$LMOD_CMD sh load $R_DEFAULT_MODULE`
  eval `$LMOD_CMD sh load TensorFlow`

  echo "The RStudio-Server will be running on this address:"
  echo $link

  $RSTUDIO_ROOT/bin/rserver --server-daemonize=0 --www-port $port --rsession-which-r="$(which R)" --server-data-dir="/tmp/rstudio-server" --auth-none=1 --secure-cookie-key-file="$COOKIE_KEY_PATH"
  
fi


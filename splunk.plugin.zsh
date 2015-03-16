# Mike Walker - mwalker@splunk.com
# 
# The plan is to mimoc the oh-my-zsh virtualenvwrapper plugin to auto enable splunk demo envs
#
# TODO : detect that you're in a splunk directory
# TODO : set $SPLUNK_HOME
# TODO : add $SPLUNK_HOME/bin to path
# TODO : update prompt to show splunk env
# TODO : profit
#

if [[ ! $DISABLE_SPLUNK_CD -eq 1 ]]; then
  # Automatically activate Git projects's virtual environments based on the
  # directory name of the project. Virtual environment name can be overridden
  # by placing a .venv file in the project root with a virtualenv name in it
  function splunk_cwd {
    if [ ! $SPLUNK_CWD ]; then
      SPLUNK_CWD=1
      # Check if this is a splunk env
      # suppress error messages somehow, this is noisy
      # just check for existance of file, not ls -1
      # how is that done in zsh?
      SPLUNK_ROOT=`ls -1 splunk-*-manifest > /dev/null`
      if (( $? != 0 )); then
      #if [[ -f "./splunk-*-manifest" ]]; then
        #SPLUNK_ROOT="."
        print "foo"
      fi
      # Check for virtualenv name override
      if [[ -f "$SPLUNK_ROOT/.venv" ]]; then
        ENV_NAME=`cat "$SPLUNK_ROOT/.venv"`
      elif [[ -f "$SPLUNK_ROOT/.venv/bin/activate" ]];then
        ENV_NAME="$SPLUNK_ROOT/.venv"
      elif [[ "$SPLUNK_ROOT" != "." ]]; then
        ENV_NAME=`basename "$SPLUNK_ROOT"`
      else
        ENV_NAME=""
      fi
      if [[ "$ENV_NAME" != "" ]]; then
        # Activate the environment only if it is not already active
        if [[ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]]; then
          if [[ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]]; then
            workon "$ENV_NAME" && export CD_VIRTUAL_ENV="$ENV_NAME"
          elif [[ -e "$ENV_NAME/bin/activate" ]]; then
            source $ENV_NAME/bin/activate && export CD_VIRTUAL_ENV="$ENV_NAME"
          fi
        fi
      elif [[ -n $CD_VIRTUAL_ENV && -n $VIRTUAL_ENV ]]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
      fi
      unset SPLUNK_ROOT
      unset SPLUNK_CWD
    fi
  }

  #
  # This part works, logic borrowed from virtualenvwrapper plugin
  #
  
  # Append splunk_cwd to the chpwd_functions array, so it will be called on cd
  # http://zsh.sourceforge.net/Doc/Release/Functions.html
  if ! (( $chpwd_functions[(I)splunk_cwd] )); then
    chpwd_functions+=(splunk_cwd)
  fi
fi


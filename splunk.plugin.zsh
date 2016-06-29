# splunk.plugin.zsh

alias splunk-pwd='export SPLUNK_HOME=`pwd`'

spl() { cd /opt/splunk/"$*"; }
_spl() {
        _files -W /opt/splunk/
}
compdef _spl spl

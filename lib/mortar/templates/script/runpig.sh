#!/bin/bash

set -e

export PIG_HOME=<%= @pig_home %>
export PIG_CLASSPATH=<%= @pig_classpath %>
export CLASSPATH=<%= @classpath %>
export PIG_MAIN_CLASS=com.mortardata.hawk.HawkMain
export PIG_OPTS="<% @pig_opts.each do |k,v| %>-D<%= k %>=<%= v %> <% end %>"

# UDF paths are relative to this direectory
if [ -d "<%= @project_home %>/pigscripts" ]; then
    scriptsdir="<%= @project_home %>/pigscripts"
    cleanup=false
else
    scriptsdir=`mktemp -d <%= @project_home %>/mortar-local-tmp-XXXX`
    cleanup=true
fi
cd "$scriptsdir"

# Setup python environment
source <%= @local_install_dir %>/pythonenv/bin/activate

# Run Pig
<%= @local_install_dir %>/<%= @pig_dir %>/bin/pig -exectype local \
    -log4jconf <%= @log4j_conf %> \
    -propertyFile <%= @local_install_dir %>/lib-common/conf/pig-hawk-global.properties \
    -propertyFile <%= @local_install_dir %>/lib-common/conf/pig-cli-local-dev.properties \
    -param_file <%= @pig_params_file %> \
    <%= @pig_sub_command %>

if $cleanup; then
    rm -rf "$scriptsdir";
fi

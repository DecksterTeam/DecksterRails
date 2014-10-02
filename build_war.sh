#!/bin/sh

echo "Creating war using Rails environment: " $RAILS_ENV

rm -rf *.war tmp/war

JRUBY_CMD=`which jruby`
echo "JRuby command: '$JRUBY_CMD'"  
JRUBY_CMD=${JRUBY_CMD:-"/opt/jruby/bin/jruby"}
export PATH=`dirname ${JRUBY_CMD}`:$PATH
#${JRUBY_CMD} -S gem install bundler
${JRUBY_CMD} -S bundle install
${JRUBY_CMD} -S rake assets:clean
#${JRUBY_CMD} -S bundle exec rake assets:precompile
echo Using Rails environment: $RAILS_ENV
${JRUBY_CMD} -J-Xmx1024m -S bundle exec warble
mkdir -p target
LATEST_WAR=`ls -t *.war | head -1`
WAR_NAME=`ls -t *.war | head -1 | sed 's/\([A-Za-z0-9]*\).war/\1/'`
mv $LATEST_WAR "target/${WAR_NAME}${1}.war"
echo "Created target/$WAR_NAME$1.war"

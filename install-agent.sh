#!/bin/bash
python get-pip.py --no-index -f pypackages
BASEDIR="/opt/sfapm"
CONF_PORT="8585"
VIRTUALENV='sfapm-venv'
if [[ ! -d "$BASEDIR" ]]
then
        if [[ ! -L $BASEDIR ]]
        then
                echo "Directory doesn't exist. Creating now"
                mkdir $BASEDIR
                echo "Directory created"
        else
                echo "Directory exists"
        fi
fi
pip install virtualenv --no-index -f pypackages
virtualenv /opt/sfapm/sfapm-venv/
source /opt/sfapm/sfapm-venv/bin/activate
pip install PyYAML --no-index -f pypackages
#yum install --skip-broken -y sysstat
yum install --skip-broken -y perf
\cp -rf collectd /opt/sfapm
pip install --no-index -f pypackages -r requirements.txt
\cp -rf configurator-exporter /opt/sfapm
cp /opt/sfapm/configurator-exporter/init_scripts/configurator.service /etc/systemd/system/configurator.service
cp /opt/sfapm/collectd/init_scripts/centos7.init /etc/systemd/system/collectd.service
\cp -rf td-agent-bit /opt/sfapm
cp /opt/sfapm/td-agent-bit/lib/td-agent-bit.service /etc/systemd/system/td-agent-bit.service
chmod 777 /opt/sfapm/td-agent-bit/opt/td-agent-bit/bin/td-agent-bit
python fluentbit-script/FluentbitConfigurator.py fluentbit-script/props.conf fluentbit-script/input.conf fluentbit-script/reg.csv /opt/sfapm/td-agent-bit/templates
systemctl daemon-reload
systemctl enable configurator
systemctl enable collectd
#iptables -I INPUT 1 -p tcp -m tcp --dport $CONF_PORT -j ACCEPT
#iptables-save | sudo tee /etc/sysconfig/iptables
#service iptables restart
service configurator start
service collectd start
service td-agent-bit start

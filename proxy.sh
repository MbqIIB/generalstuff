echo $1
if [[ $1 != "OFF" ]]
then
echo " setting proxy to value"
SETX http_proxy http://b8886963:feb2015@proxybc.mnscorp.net:8080
SETX https_proxy http://b8886963:feb2015@proxybc.mnscorp.net:8080
else
echo "setting proxy to nulL"
SETX http_proxy ""
SETX https_proxy ""
fi
echo $1
if [[ $1 != "OFF" ]]
then
echo "Please enter your name:"
read name
echo "Welcome to proxy setting $name"
read pass
echo " your password is $pass"
echo " setting proxy to value"
SETX http_proxy http://${name}:${pass}@proxybc.mnscorp.net:8080
SETX https_proxy http://${name}:${pass}@proxybc.mnscorp.net:8080
else
echo "setting proxy to nulL"
SETX http_proxy ""
SETX https_proxy ""
fi
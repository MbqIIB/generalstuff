echo $1
if [[ $1 != "OFF" ]]
then
echo "Please enter your name:"
read name
echo "Welcome to proxy setting $name"
read pass
echo " your password is $pass"
echo " setting proxy to value"
export http_proxy=${name}:${pass}@proxybc.mnscorp.net:8080
export https_proxy=${name}:${pass}@proxybc.mnscorp.net:8080
else
echo "setting proxy to nulL"
export http_proxy=""
export https_proxy=""
fi

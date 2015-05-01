LAST YEAR

Youuploaded an item
19 Jun 2014
Text
sslrollout.txt
No recorded activity before 19 June 2014
11 GB used (72%)
Buy more storage
sslrollout.txtEdit
host=`hostname`
#trust_cert="/home/mqadmin/SSL"
trust_cert="/var/mqsi/certs"
kdb_store="/MQHA/qmgrs/$QM/kdb"
jks_store="/var/mqsi/jks"
cipher="TLS_RSA_WITH_AES_128_CBC_SHA"
PASSPHRASE="password"
QMSMALL=`echo $QM | tr '[:upper:]' '[:lower:]'`

#Generate Random password
#PASSPHRASE=`head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 15`

#usage portion
usage(){

if [[ "$#" = 0 || "$1" = '-?' || "$1" = '?' || "$1" = '-help' || "$1" = 'help' ]] 
then 
        printf "
"
        printf "\nThis command must be entered in the following format:"
        printf "\n "
        printf "\n ./sslRollout -e <eg.rpoperties>/-b <broker.properties> -q <mq.properties> -j -c" 
        printf "\nWhere <eg. properties> contains the eg and port in the format eg,port(each eg in separate lines)" 
        printf "\n "
        printf "\n With the following optional parameters:"
        printf "\n "
        printf "\n -j :        Create jks from a cer file"
        printf "\n -c :        generate a csr and a self signed certificate"
        printf "\n -k :        create a kdb from the existing files (should be specified with -j)"
        printf "\n -q :        Deploy the MQ SSL (considering kdb already exists in $kdb_store\n "
        printf "\n -e :                should  be specified with the name of property file"
        printf "\n For Rollout of MQ SSL " 
        printf "\n ./sslRollout -q <mq.rpoperties>"
        printf "\n To create the KDB and then rollout mqssl " 
        printf "\n ./sslRollout -j -k -q <mq.rpoperties>"
        printf "\n To create the jks from existing certs and then rollout eg level ssl " 
        printf "\n ./sslRollout -j -e <eg.rpoperties>"
        printf "\n To create new certs and if needed to rollout with created certs specify above parameters" 
        printf "\n ./sslRollout -c"
        exit 0
fi


}

#catching errors
fail_if_error() {
[ $1 != 0 ] && {
exit 10
}
}
  
# Procedure to create private key and self signed certificate along with a CSR request.
create_cert(){ 
# Generate a passphrase



# Certificate details; replace items in angle brackets with your own info
subj="
C=GB
O=MarksandSpencer
localityName=London
commonName=${host}
emailAddress=steven.gonsalvez@marksandspencer.com
"

# Generate the server private key
openssl genrsa -des3 -out ${host}.key -passout pass:${PASSPHRASE} 2048 
fail_if_error $?

# Generate the CSR
openssl req \
-new \
-batch \
-subj "$(echo -n "$subj" | tr "\n" "/")" \
-key ${host}.key \
-out ${host}.csr \
-passin pass:${PASSPHRASE}
fail_if_error $?

#cp ${host}.key ${host}.key.org
#fail_if_error $?

# Strip the password so we don't have to type it every time we restart Apache
openssl rsa -in ${host}.key -out ${host}.key -passin pass:${PASSPHRASE}
fail_if_error $?

# Generate the cert (good for 10 years)
openssl x509 -req -days 3650 -in ${host}.csr -signkey ${host}.key -out ${host}.cer
fail_if_error $?
}

# Procedure to conver cer to jks.
conv_cer() {
openssl pkcs12 -export -out ${host}.p12 -inkey ${host}.key -in ${host}.cer -passout pass:${PASSPHRASE} -name ${host}
fail_if_error $?
keytool -importkeystore -destkeystore broker.jks -deststorepass ${PASSPHRASE} -srckeystore ${host}.p12 -srcstoretype PKCS12 -srcstorepass ${PASSPHRASE}
fail_if_error $?
}

#procedure to add trust certs to jks
add_jks() {
for cacert in `find ${trust_cert} -name "*.crt" -o -name "*.cer" -o -name "*.CER"`; do 
echo $cacert 
keytool -import -file $cacert -alias $cacert -keystore broker.jks -storepass ${PASSPHRASE} -trustcacerts -noprompt
done
}

#procedure to rename spaces in files
rename(){
find ${trust_cert}/. -type f -name "*" > /tmp/dev_spacelist
               
        ORIGIFS=$IFS
        IFS=$(printf "\n")

        exec < /tmp/dev_spacelist
        while read filename
        do
                newfilename=`echo $filename | sed 's/ /_/g'`
                mv $filename $newfilename >>/dev/null 2>&1
        done
        IFS=$ORIGIFS

        rm /tmp/dev_spacelist
}

egssl(){

mkdir $jks_store >>/dev/null 2>&1
cp ${trust_cert}/broker.jks $jks_store
ls $egprop
fail_if_error $?


while read line;do
port=`echo $line| awk -F"," {'print $2'}`
each=`echo $line| awk -F"," {'print $1'}`

mqsichangeproperties $QM -e $each -o HTTPConnector -n explicitlySetPortNumber -v 0
mqsichangeproperties $QM -e $each -o HTTPSConnector -n sslProtocol -v SSL
mqsichangeproperties $QM -e $each -o HTTPSConnector -n explicitlySetPortNumber -v $port
mqsichangeproperties $QM -e $each -o HTTPSConnector -n keystoreFile -v ${jks_store}/broker.jks
mqsichangeproperties $QM -e $each -o HTTPSConnector -n keystoreType -v JKS
mqsichangeproperties $QM -e $each -o HTTPSConnector -n keystorePass -v password
mqsichangeproperties $QM -e $each -o ComIbmJVMManager -n keystoreFile -v ${jks_store}/broker.jks
mqsichangeproperties $QM -e $each -o ComIbmJVMManager -n keystoreType -v JKS
mqsichangeproperties $QM -e $each -o ComIbmJVMManager -n keystorePass -v brokerKeystore::password
mqsichangeproperties $QM -e $each -o ComIbmJVMManager -n truststoreFile -v ${jks_store}/broker.jks
mqsichangeproperties $QM -e $each -o ComIbmJVMManager -n truststorePass -v brokerTruststore::password
mqsichangeproperties $QM -e $each -o ExecutionGroup -n httpNodesUseEmbeddedListener -v true
mqsichangeproperties $QM -e $each -o ExecutionGroup -n soapNodesUseEmbeddedListener -v true

done<$egprop

printf "\n please restart the broker \n"
}

# Verify if the execution groups have the correct details
verify() {

printf "\n ex-group ,httpport , httpsport , keystore , soapnode , httpnode \n"
while read check;do
port=`echo $check| awk -F"," {'print $2'}`
each=`echo $check| awk -F"," {'print $1'}`

httpport=`mqsireportproperties $QM -e $each -o HTTPConnector -n explicitlySetPortNumber | grep -v BIP | grep -v "^$"`
httpsport=`mqsireportproperties $QM -e $each -o HTTPSConnector -n explicitlySetPortNumber | grep -v BIP | grep -v "^$" `
keystore=`mqsireportproperties $QM -e $each -o HTTPSConnector -n keystoreFile | grep -v BIP | grep -v "^$"`
soapnode=`mqsireportproperties $QM -e $each -o ExecutionGroup -n httpNodesUseEmbeddedListener | grep -v BIP | grep -v "^$"`
httpnode=`mqsireportproperties $QM -e $each -o ExecutionGroup -n soapNodesUseEmbeddedListener | grep -v BIP | grep -v "^$"`

printf "$each,$httpport,$httpsport,$keystore,$soapnode, $httpnode \n"

done<prop
}

create_kdb(){
openssl pkcs12 -export -out ${host}.p12 -inkey ${host}.key -in ${host}.cer -passout pass:${PASSPHRASE} -name ${host}
fail_if_error $?

## create the DB
runmqckm -keydb -create -db $QM.kdb -pw ${PASSPHRASE} -type cms -stash -expire 7300

##import the P12 into the kdb
runmqckm -cert -import -target $QM.kdb  -target_pw ${PASSPHRASE} -file ${host}.p12 -label ${host} -new_label ibmwebspheremq$QMSMALL -pw ${PASSPHRASE}


### import certificates into a kdb
for each in `ls *.cer *.CER 2> /dev/null | grep -v ${host}`;do runmqckm -cert -add -file $each -db $QM.kdb -pw ${PASSPHRASE};done

####list all certs in kdb
runmqckm  -cert -list all -db $QM.kdb -pw ${PASSPHRASE}

mkdir ${kdb_store} 2> /dev/null
cp $QM.kdb $QM.rdb $QM.sth ${kdb_store} 2> /dev/null
chmod 777 ${kdb_store}/*

}


mqssl(){

kdb_file=${kdb_store}/$QM
echo "ALTER QMGR SSLKEYR('${kdb_file}')" | runmqsc $QM

ls $mqprop
fail_if_error $?

while read line;do
chl=`echo $line | awk -F"," {'print $1'}`
type=`echo $line | awk -F"," {'print $2'}`

echo "alter chl(${chl}) chltype(${type})  sslciph($cipher)" | runmqsc $QM 

done<$mqprop

echo "refresh security type(ssl)" | runmqsc $QM 
}

while getopts M:m:b:B:e:E:q:Q:jJcCvVkK OPTS
do
   case $OPTS in
     q|Q) # Rollout MQ SSL - using the property file passed
       mqprop=$OPTARG
           rm $QM.kdb $QM.rdb $QM.sth 2>/dev/null
           mqssl
           ;;
           
      k|K) # CCreate kdb
       create_kdb
       ;;
          
     j|J) # Create jks from cer files
       conv_cer
           rename
           add_jks
       ;;
       
     b|B) # Rollout broker SSL
           brokerprop=$OPTARG
       brokerssl 
       ;;
           
         e|E) # Rollout broker SSL
           egprop=$OPTARG
       egssl 
       ;;
           
          v|V) # Rollout broker SSL
           verify
       ;;
     
         c|C) # Rollout broker SSL
       create_cert 
       ;; 
       *) # invalid flag
       usage
       ;;
   
   esac

done
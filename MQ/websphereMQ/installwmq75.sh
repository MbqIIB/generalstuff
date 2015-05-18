#! /bin/bash
# -----------------------------------------------------------------------------------------------
# Script....: installWMQ75.sh
#           :
# Purpose...: Install base product components of IBM WebSphere MQ 7.5
#           :
# Author....: Alasdhair Buchanan; ISSW (UK&I); IBM United Kindom Ltd.
#           :
# Parameters: -a {Architecture} - descriptor for IBM installation package (Mandatory)
#           : -v {Version}      - Version of WMQ to install (Mandatory)
#           : -explorer         - indicator to install WMQExplorer (Optional)
#           : -lang             - indicator to install foreign language messages (Optional)
#           : -ams              - indicator to install WMQ AMS functionality (Optional)
#           : -fte              - indicator to install WMQ FTE functionality (Optional)
#           : -agt              - indicator to install WMQ FTE agent functionality (Optional)
#           :
# Changes...: Version |    Date    | Description
#           :   1.00  | 15/03/2013 | Initial version
#           :   1.01  | 22/03/2013 | Correct rpm sequence for GsKit
#           :   1.02  | 30/04/2013 | Add FTE Agent option
#           :   1.03  | 30/04/2013 | Force Explorer = NO if zLinux
#           :   1.04  | 30/04/2013 | Add version parameter & fix FTE agent dependency
#           :
# Notes.....:
#           :
# Copyright.: IBM United Kingdom Ltd; 2013
# ------------------------------------------------------------------------------------------------
# Save parameters
typeset USERPARM1=$( echo ${1} | tr 'A-Z' 'a-z' )
typeset USERPARM2=${2}
typeset USERPARM3=$( echo ${3} | tr 'A-Z' 'a-z' )
typeset USERPARM4=${4}
typeset USERPARM5=$( echo ${5} | tr 'A-Z' 'a-z' )
typeset USERPARM6=$( echo ${6} | tr 'A-Z' 'a-z' )
typeset USERPARM7=$( echo ${7} | tr 'A-Z' 'a-z' )
typeset USERPARM8=$( echo ${8} | tr 'A-Z' 'a-z' )
typeset USERPARM9=$( echo ${9} | tr 'A-Z' 'a-z' )

# Validate parameters
# Initialise indicators
typeset INSTALL_EXPLORER='NO'
typeset INSTALL_LANG='NO'
typeset INSTALL_AMS='NO'
typeset INSTALL_FTE='NO'
typeset INSTALL_AGT='NO'
typeset ERROR_DETECTED='NO'
# Validate Parameter 1
case ${USERPARM1} in
-a)
	typeset ARCHITECTURE=${USERPARM2:='Undefined'}
	if [[ ${ARCHITECTURE} = 'Undefined' ]]
	then
	  echo 'No value of architecture specified.'
	  echo ${USERPARM1} 'Invalid option, must be -a followed by architecture identifier' >&2
	  echo 'Error detected: see previous messages'
	  echo 'Execution terminated'
	  exit 4
	else
	  if [[ $( echo ${ARCHITECTURE} | cut -c 1 ) = '-' ]]
	  then 
	    echo 'No value of architecture specified.'
	    echo ${USERPARM1} 'Invalid option, must be -a followed by architecture identifier' >&2
	    echo 'Error detected: see previous messages'
	    echo 'Execution terminated'
	    exit 4
	  fi
	fi
	;;
*)
	echo ${USERPARM1} 'Invalid option, must be -a followed by architecture identifier' >&2
	echo 'Error detected: see previous message'
	echo 'Execution terminated'
	exit 4
	;;
esac
# Validate Parameter 3
case ${USERPARM3} in
-v)
	typeset VERSION=${USERPARM4:='Undefined'}
	if [[ ${VERSION} = 'Undefined' ]]
	then
	  echo 'No value of version specified.'
	  echo ${USERPARM3} 'Invalid option, must be -v followed by version identifier' >&2
	  echo 'Error detected: see previous messages'
	  echo 'Execution terminated'
	  exit 4
	else
	  if [[ $( echo ${VERSION} | cut -c 1 ) = '-' ]]
	  then 
	    echo 'No value of version specified.'
	    echo ${USERPARM3} 'Invalid option, must be -v followed by version identifier' >&2
	    echo 'Error detected: see previous messages'
	    echo 'Execution terminated'
	    exit 4
	  fi
	fi
	;;
*)
	echo ${USERPARM3} 'Invalid option, must be -v followed by version identifier' >&2
	echo 'Error detected: see previous message'
	echo 'Execution terminated'
	exit 4
	;;
esac
case ${USERPARM5} in
-explorer)
	typeset INSTALL_EXPLORER='YES'
	;;
-lang)
	typeset INSTALL_LANG='YES'
	;;
-ams)
	typeset INSTALL_AMS='YES'
	;;
-fte)
	typeset INSTALL_FTE='YES'
	;;
-agt)
	typeset INSTALL_AGT='YES'
	;;
*)
	if [[ ${USERPARM5:='Undefined'} != 'Undefined' ]]
	then
	  echo ${USERPARM5} 'unknown option' >&2
	  typeset ERROR_DETECTED='YES'
	fi
	;;
esac
case ${USERPARM6} in
-explorer)
	typeset INSTALL_EXPLORER='YES'
	;;
-lang)
	typeset INSTALL_LANG='YES'
	;;
-ams)
	typeset INSTALL_AMS='YES'
	;;
-fte)
	typeset INSTALL_FTE='YES'
	;;
-agt)
	typeset INSTALL_AGT='YES'
	;;
*)
	if [[ ${USERPARM6:='Undefined'} != 'Undefined' ]]
	then
	  echo ${USERPARM6} 'unknown option' >&2
	  typeset ERROR_DETECTED='YES'
	fi
	;;
esac
case ${USERPARM7} in
-explorer)
	typeset INSTALL_EXPLORER='YES'
	;;
-lang)
	typeset INSTALL_LANG='YES'
	;;
-ams)
	typeset INSTALL_AMS='YES'
	;;
-fte)
	typeset INSTALL_FTE='YES'
	;;
-agt)
	typeset INSTALL_AGT='YES'
	;;
*)
	if [[ ${USERPARM7:='Undefined'} != 'Undefined' ]]
	then
	  echo ${USERPARM7} 'unknown option' >&2
	  typeset ERROR_DETECTED='YES'
	fi
	;;
esac
case ${USERPARM8} in
-explorer)
	typeset INSTALL_EXPLORER='YES'
	;;
-lang)
	typeset INSTALL_LANG='YES'
	;;
-ams)
	typeset INSTALL_AMS='YES'
	;;
-fte)
	typeset INSTALL_FTE='YES'
	;;
-agt)
	typeset INSTALL_AGT='YES'
	;;
*)
	if [[ ${USERPARM8:='Undefined'} != 'Undefined' ]]
	then
	  echo ${USERPARM8} 'unknown option' >&2
	  typeset ERROR_DETECTED='YES'
	fi
	;;
esac
case ${USERPARM9} in
-explorer)
	typeset INSTALL_EXPLORER='YES'
	;;
-lang)
	typeset INSTALL_LANG='YES'
	;;
-ams)
	typeset INSTALL_AMS='YES'
	;;
-fte)
	typeset INSTALL_FTE='YES'
	;;
-agt)
	typeset INSTALL_AGT='YES'
	;;
*)
	if [[ ${USERPARM9:='Undefined'} != 'Undefined' ]]
	then
	  echo ${USERPARM9} 'unknown option' >&2
	  typeset ERROR_DETECTED='YES'
	fi
	;;
esac

# Did we hit an error?
if [[ ${ERROR_DETECTED} = 'YES' ]]
then
	echo 'Error(s) detected. See previous message(s)'
	echo 'Execution terminated'
	exit 1
fi

# If zLinux - no Explorer

if [[ ${ARCHITECTURE} = 's390x' ]]
then
	echo 'WMQ Explorer not supported on zLinux, Install WMQ Explorer forced to NO.'
	typeset INSTALL_EXPLORER='NO'
fi
	
# Report values being used
echo 'Architecture identifier = ' ${ARCHITECTURE}
echo 'Install WMQ Explorer = ' ${INSTALL_EXPLORER}
echo 'Install other language messages = ' ${INSTALL_LANG}
echo 'Architecture AMS = ' ${INSTALL_AMS}
echo 'Architecture FTE = ' ${INSTALL_FTE}
echo 'Architecture FTE Agent = ' ${INSTALL_AGT}

#Install base WMQ product
typeset QUALIFIER='-'${VERSION}'.'${ARCHITECTURE}'.rpm'

# Accept licence
./mqlicense.sh -accept

# MQSeries Runtime
typeset INSTALLFILE='MQSeriesRuntime'${QUALIFIER}
if [ -f ${INSTALLFILE} ]
then
	rpm -ivh ${INSTALLFILE}
else
	echo 'Installation file '${INSTALLFILE}' not found.'
	echo 'Execution terminated.'
	exit 8
fi 

# MQSeries Server
typeset INSTALLFILE='MQSeriesServer'${QUALIFIER}
if [ -f ${INSTALLFILE} ]
then
	rpm -ivh ${INSTALLFILE}
else
	echo 'Installation file '${INSTALLFILE}' not found.'
	echo 'Execution terminated.'
	exit 8
fi 

# MQSeries Samples
typeset INSTALLFILE='MQSeriesSamples'${QUALIFIER}
if [ -f ${INSTALLFILE} ]
then
	rpm -ivh ${INSTALLFILE}
else
	echo 'Installation file '${INSTALLFILE}' not found.'
	echo 'Execution terminated.'
	exit 8
fi 

# MQSeries SDK
typeset INSTALLFILE='MQSeriesSDK'${QUALIFIER}
if [ -f ${INSTALLFILE} ]
then
	rpm -ivh ${INSTALLFILE}
else
	echo 'Installation file '${INSTALLFILE}' not found.'
	echo 'Execution terminated.'
	exit 8
fi 

# MQSeries JRE
typeset INSTALLFILE='MQSeriesJRE'${QUALIFIER}
if [ -f ${INSTALLFILE} ]
then
	rpm -ivh ${INSTALLFILE}
else
	echo 'Installation file '${INSTALLFILE}' not found.'
	echo 'Execution terminated.'
	exit 8
fi 

# MQSeries Java
typeset INSTALLFILE='MQSeriesJava'${QUALIFIER}
if [ -f ${INSTALLFILE} ]
then
	rpm -ivh ${INSTALLFILE}
else
	echo 'Installation file '${INSTALLFILE}' not found.'
	echo 'Execution terminated.'
	exit 8
fi 

# MQSeries GSKit
typeset INSTALLFILE='MQSeriesGSKit'${QUALIFIER}
if [ -f ${INSTALLFILE} ]
then
	rpm -ivh ${INSTALLFILE}
else
	echo 'Installation file '${INSTALLFILE}' not found.'
	echo 'Execution terminated.'
	exit 8
fi 

# MQSeries Man
typeset INSTALLFILE='MQSeriesMan'${QUALIFIER}
if [ -f ${INSTALLFILE} ]
then
	rpm -ivh ${INSTALLFILE}
else
	echo 'Installation file '${INSTALLFILE}' not found.'
	echo 'Execution terminated.'
	exit 8
fi 

# If requested, install WMQ Explorer

if [[ ${INSTALL_EXPLORER} = 'YES' ]]
then
	typeset INSTALLFILE='MQSeriesExplorer'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
fi

# If requested, install foreign language messages

if [[ ${INSTALL_LANG} = 'YES' ]]
then
	typeset INSTALLFILE='MQSeriesMsg_Zh_TW'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_Zh_CN'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_ru'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_pt'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_pl'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_ko'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_ja'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_it'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_hu'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_fr'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_es'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_de'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesMsg_cs'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
fi

# If requested, install WMQ AMS

if [[ ${INSTALL_AMS} = 'YES' ]]
then
	typeset INSTALLFILE='MQSeriesAMS'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
fi

# If requested, install WMQ FTE

if [[ ${INSTALL_FTE} = 'YES' ]]
then
	typeset INSTALLFILE='MQSeriesFTBase'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesFTLogger'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesFTService'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
	typeset INSTALLFILE='MQSeriesFTTools'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
fi

# If requested, install WMQ FTE Agent

if [[ ${INSTALL_AGT} = 'YES' ]]
then
	if [[ ${INSTALL_FTE} = 'NO' ]]
	then
		typeset INSTALLFILE='MQSeriesFTBase'${QUALIFIER}
		if [ -f ${INSTALLFILE} ]
		then
			rpm -ivh ${INSTALLFILE}
		else
			echo 'Installation file '${INSTALLFILE}' not found.'
			echo 'Execution terminated.'
			exit 8
		fi 
	fi
	typeset INSTALLFILE='MQSeriesFTAgent'${QUALIFIER}
	if [ -f ${INSTALLFILE} ]
	then
	  rpm -ivh ${INSTALLFILE}
	else
	  echo 'Installation file '${INSTALLFILE}' not found.'
	  echo 'Execution terminated.'
	  exit 8
	fi 
fi

# Set as primary WMQ path
/opt/mqm/bin/setmqinst -i -p /opt/mqm

# Announce completion
echo 'Base WMQ product installed'
if [[ ${INSTALL_EXPLORER} = 'YES' ]]
then
 	echo 'WMQ Explorer installed'
fi
if [[ ${INSTALL_LANG} = 'YES' ]]
then
 	echo 'WMQ non-English messages installed'
fi
if [[ ${INSTALL_AMS} = 'YES' ]]
then
 	echo 'WMQ AMS installed'
fi
if [[ ${INSTALL_FTE} = 'YES' ]]
then
 	echo 'WMQ FTE installed'
fi
if [[ ${INSTALL_AGT} = 'YES' ]]
then
 	echo 'WMQ FTE Agent installed'
fi
echo 'WMQ installation complete.'
exit 0


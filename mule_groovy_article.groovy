################### First version
//list of client to NR_RANGE_NR map items 

def clientmap = [PLM:"02", TEST:"01"]
println "oop"

//def key = #[message.inboundProperties.'http.query.params'.ClientId]
def key = payload.ClientId
println key
event.setSessionVariable("test",key)
return payload

//if(clientmap[key]) {
//MuleMessage message=event.getMessage();

//message.setProperty('rangeNumber', value, PropertyScope.SESSION)
//}else{
//throw new org.mule.module.apikit.exception.BadRequestException("clientID : " + key + ", is invalid or not Configured")
//}

//def value = clientmap[key] ?: throw new org.mule.module.apikit.exception.BadRequestException("clientID : " + key + ", is invalid or not Configured")

####################### second version
import org.mule.api.transport.*

def clientmap = [ PLM:"02", TEST:"01"]
def key = payload.ClientId
println "client id passed is" + key
def value = clientmap[key]
println value

if(value == null  || value.trim().isEmpty()){
println "entered into if"
message.setProperty("rangeNumber", "test", PropertyScope.SESSION)
return payload
}
else{
throw new org.mule.module.apikit.exception.BadRequestException("clientID : " + key + ", is invalid or not Configured")//
}




require 'net/http'
require 'net/https'
require 'json'

#Inbound SMS Delcarations and Functions
def retrieve_sms_retrievals
    uri = URI('YOUR_TROPO_SPARK_INTEGRATION_SERVER/sms_retrievals.json')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    req =  Net::HTTP::Get.new(uri.request_uri)
    req.add_field "Content-Type", "application/json"
    res = http.request(req)
    return JSON.parse(res.body)
end

def post_to_spark_dynamic(phone_number, room_id, message)
    uri = URI.parse("https://api.ciscospark.com/v1/messages")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    request = Net::HTTP::Post.new(uri.request_uri)
    fault_report = "SMS Reply From: #{phone_number} | #{message}"
    params = {"roomId" => room_id, "text" => fault_report}
    json_headers = {"Content-Type" => "application/json","Accept" => "application/json", "Authorization" => "Bearer YOUR_API_KEY_HERE"}
    response = http.post(uri.path, params.to_json, json_headers)
end

def delete_sms_retrieval_object(id)
    uri = URI('https://troposparkintegration.herokuapp.com/sms_retrievals/' + id.to_s)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    req =  Net::HTTP::Delete.new(uri.request_uri)
    req.add_field "Content-Type", "application/json"
    res = http.request(req)
end

#------------------------------------------------------------
#Application Logic
#InBound SMS
if $currentCall
	retrieve_sms_retrievals.each do |hash|
    	log "Matching " + hash['phone_number'] + " with " + $currentCall.callerID
    	if hash['phone_number'] == $currentCall.callerID || hash['phone_number'] == $currentCall.callerID.tr("+", "") || hash['phone_number'] == "+#{$currentCall.callerID}"
        	log "Matches " + hash['phone_number'] + " with " + $currentCall.callerID
        	post_to_spark_dynamic($currentCall.callerID, hash['room_id'], $currentCall.initialText)
        	delete_sms_retrieval_object(hash['id'])
    	else
        	log 'No Match for: ' + $currentCall.callerID
    end
end

#Make an Automated Outbound Call
elsif $delivery_type == "phone"
	call $recipient
	wait(750)
	say $message, {:voice => "daniel"}
	hangup


#Send an SMS
elsif $delivery_type == "sms"
	call $recipient, {:network => "SMS"}
	say $message

end

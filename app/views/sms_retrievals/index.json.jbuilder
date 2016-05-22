json.array!(@sms_retrievals) do |sms_retrieval|
  json.extract! sms_retrieval, :id, :phone_number, :room_id
  json.url sms_retrieval_url(sms_retrieval, format: :json)
end

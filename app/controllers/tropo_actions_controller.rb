require "net/http"
require "uri"
require 'open-uri'

class TropoActionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]

  def create
    message_id = params[:data][:id]
    sender = params[:data][:personEmail]
    room_id = params[:data][:roomId]

    recieved_message = CiscoSpark::Message.fetch(message_id)
    parsed_messsage = recieved_message.text
    puts parsed_messsage

    if parsed_messsage.start_with?("/sms") || parsed_messsage.start_with?("/Sms") || parsed_messsage.start_with?("/phone") || parsed_messsage.start_with?("/Phone")
      self.slash_tropo_request(parsed_messsage, room_id)
    end

    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  def slash_tropo_request(parsed_message, room_id)

    request_values = parsed_message.split()
    puts request_values
    delivery_type = request_values[0].tr('/', '')
    recipient = request_values[1]
    message = ""

    for index in 2 ... request_values.size
      message = message + " " + request_values[index]
      puts "request_values[#{index}] = #{request_values[index]}"
    end
    puts message

    TropoAction.create(:recipient => recipient, :delivery_type => delivery_type, :message => message)

    url = "https://api.tropo.com/1.0/sessions?action=create&token="
    if delivery_type == "phone"
      url = url + "YOUR_VOICE_API_TOKEN" + "&delivery_type=phone"
    elsif delivery_type == "sms"
      url = url + "YOUR_VOICE_SMS_TOKEN" + "&delivery_type=sms"
    end
    url = url + "&recipient=" + recipient + "&message=" + message.lstrip
    response = open(URI.encode(url)).read

    tropo_message = delivery_type == "phone" ? "Tropo: Phone Call Request Recieved" : "Tropo: SMS Request Recieved"
    CiscoSpark::Message.create(roomId: room_id, text: tropo_message)

    if delivery_type == "sms"
      SmsRetrieval.where(phone_number: recipient).destroy_all
      @persist = SmsRetrieval.create(phone_number: recipient, room_id: room_id)
    end

  end

  private

  def create_params
    params.require(:tropo_action).permit(:recipient, :delivery_type, :message)
  end

end

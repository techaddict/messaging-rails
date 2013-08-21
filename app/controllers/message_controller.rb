class MessageController < ApplicationController
  def inbox
    @messages=Message.where(reciever_id: current_user.id)
  end

  def sent
    @messages=Message.where(sender_id: current_user.id)
  end
  
  def show
    @message = Message.find(params[:id])
    @title = @message.subject
  end

  def delete
    @message.destroy
    redirect_to message_url
  end

  def new
  	@message = Message.new
    if (session[:reciever_id])
      @message.reciever_id = session[:reciever_id]
    end  
  end

  def create
  	@message = Message.new(params[:message])
  	@message.reciever_id = session[:reciever_id]
    @message.sender_id = current_user.id
    phone_regex = /[789]\d{9}/
    email_regex = /[a-z\d\.\_\%\+\-]+(\[at\]|@)+[a-z\d\.\-]+(\[\.\]|\.)+[a-z]{2,4}/ #email[at]gmail[.]com
    if !phone_regex.match(@message.content) && !email_regex.match(@message.content) && @message.reciever_id.to_i != 0
    	if @message.save
    		flash[:notice] = "Message has been sent"
    		#redirect_to user_messages_path(current_user, outbox)
      else
        render :action => :new
      end
  	else
      flash[:notice] = "Email and Phone Number not allowed"
  		render :action => :new
  	end
    @message.reciever_id=0
  end

end

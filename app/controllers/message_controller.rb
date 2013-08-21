class MessageController < ApplicationController
  EMAIL_ADDRESS_QTEXT           = Regexp.new '[^\\x0d\\x22\\x5c\\x80-\\xff]', nil, 'n'
  EMAIL_ADDRESS_DTEXT           = Regexp.new '[^\\x0d\\x5b-\\x5d\\x80-\\xff]', nil, 'n'
  EMAIL_ADDRESS_ATOM            = Regexp.new '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+', nil, 'n'
  EMAIL_ADDRESS_QUOTED_PAIR     = Regexp.new '\\x5c[\\x00-\\x7f]', nil, 'n'
  EMAIL_ADDRESS_DOMAIN_LITERAL  = Regexp.new "\\x5b(?:#{EMAIL_ADDRESS_DTEXT}|#{EMAIL_ADDRESS_QUOTED_PAIR})*\\x5d", nil, 'n'
  EMAIL_ADDRESS_QUOTED_STRING   = Regexp.new "\\x22(?:#{EMAIL_ADDRESS_QTEXT}|#{EMAIL_ADDRESS_QUOTED_PAIR})*\\x22", nil, 'n'
  EMAIL_ADDRESS_DOMAIN_REF      = EMAIL_ADDRESS_ATOM
  EMAIL_ADDRESS_SUB_DOMAIN      = "(?:#{EMAIL_ADDRESS_DOMAIN_REF}|#{EMAIL_ADDRESS_DOMAIN_LITERAL})"
  EMAIL_ADDRESS_WORD            = "(?:#{EMAIL_ADDRESS_ATOM}|#{EMAIL_ADDRESS_QUOTED_STRING})"
  EMAIL_ADDRESS_DOMAIN          = "#{EMAIL_ADDRESS_SUB_DOMAIN}(?:\\x2e#{EMAIL_ADDRESS_SUB_DOMAIN})*"
  EMAIL_ADDRESS_LOCAL_PART      = "#{EMAIL_ADDRESS_WORD}(?:\\x2e#{EMAIL_ADDRESS_WORD})*"
  EMAIL_ADDRESS_SPEC            = "#{EMAIL_ADDRESS_LOCAL_PART}\\x40#{EMAIL_ADDRESS_DOMAIN}"
  EMAIL_ADDRESS_PATTERN         = Regexp.new "#{EMAIL_ADDRESS_SPEC}", nil, 'n'
  EMAIL_ADDRESS_EXACT_PATTERN   = Regexp.new "\\A#{EMAIL_ADDRESS_SPEC}\\z", nil, 'n'
  
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
    
    if !phone_regex.match(@message.content) && (@message.content) =~ EMAIL_ADDRESS_EXACT_PATTERN && @message.reciever_id.to_i != 0
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

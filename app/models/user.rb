class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :phone, :houseno, :addline1, 
:addline2
  
  validates :name,  presence: true, length: { maximum: 50 }
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
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

  PHONE_REGEX = /[789]\d{9}/
  validates :email, presence: true, format: { with: EMAIL_ADDRESS_EXACT_PATTERN }
  validates :phone, format: { with: PHONE_REGEX }

  has_many :sent_messages,
  	:class_name => 'Message',
  	#:primary_key => 'user_id',
  	:foreign_key => 'sender_id',
  	:order => "messages.created_at DESC",
  	:conditions => ["messages.delete_s = ?", false]
  has_many :recieved_messages,
  	:class_name => 'Message',
  	#:primary_key => 'user_id',
  	:foreign_key => 'reciever_id',
  	:order => "messages.created_at DESC",
  	:conditions => ["messages.delete_r = ?", false]

end
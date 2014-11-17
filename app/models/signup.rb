class Signup < ActiveRecord::Base
  validates :email,       :presence => true,
                          :uniqueness => true,##  This should be done at the DB this is too expensive in rails
                          :format   => { :with => CustomValidators::Emails.email_validator },
                          :length => { :maximum => 255 }

end

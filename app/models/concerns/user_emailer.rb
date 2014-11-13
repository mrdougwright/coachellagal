module UserEmailer
  extend ActiveSupport::Concern

  # email activation instructions after a user signs up
  #
  # @param  [ none ]
  # @return [ none ]
  def deliver_activation_instructions!
    Resque.enqueue(Jobs::SendSignUpNotification, self.id)
  end

  def deliver_password_reset_instructions!
    self.reset_perishable_token!
    Resque.enqueue(Jobs::SendPasswordResetInstructions, self.id)    
  end

end

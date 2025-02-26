class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :auth_tokens

      ## Confirmable
      # t.string :unconfirmed_email
      # t.string :confirmation_token
      # t.datetime :confirmation_sent_at
      # t.datetime :confirmed_at

      ## Recoverable
      # t.string :reset_password_token
      # t.datetime :reset_password_sent_at

      ## Trackable
      # t.string :last_sign_in_ip
      # t.datetime :last_sign_in_at
      # t.string :last_request_ip
      # t.datetime :last_request_at

      ## Invitable
      # t.string :invitation_token
      # t.datetime :invitation_sent_at
      # t.datetime :invitation_accepted_at

      ## Lockable
      # t.integer :failed_attempts
      # t.string :unlock_token
      # t.datetime :first_failed_attempt_at
      # t.datetime :locked_at
    end
  end
end

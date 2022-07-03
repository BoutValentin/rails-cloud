namespace :user do
  desc "Create an user"
  task :create_user, [:email, :password, :password_confirmation] => [:environment] do |task, args|
    # If we don't have email, password or password_confirmation, we exit the command
    if args[:email].nil?
      puts "Error: email is nil"
      exit 1
    end

    if args[:password].nil?
      puts "Error: password is nil"
      exit 1
    end

    if args[:password_confirmation].nil?
      puts "Error: password_confirmation is nil"
      exit 1
    end

    begin
      # We use connection in case the connection to the model is not done
      User.connection
      # We create an user using the args provide
      user = User.create(email: args[:email], password: args[:password], password_confirmation: args[:password_confirmation])
      # If the user is not valid
      if !user.validate
        # We display errors to the user
        puts "Error: #{user.errors.full_messages.join(", ")}"
        # And exit
        exit 1
      end
    # In case an exception occurs
    rescue
      # We inform user
      puts "Error: the user wasn't create. Retry with valid attributes"
      # And exit
      exit 1
    end
    # We inform that the user has been created
    puts "User create ! You can now login using the credentials you provides."
  end
end

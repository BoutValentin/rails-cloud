namespace :user do
  desc "Create an user"
  task :create_user, [:email, :password, :password_confirmation] => [:environment] do |task, args|
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
        User.connection
        user = User.create(email: args[:email], password: args[:password], password_confirmation: args[:password_confirmation])
        if !user.validate
          puts "Error: #{user.errors.full_messages.join(", ")}"
          exit 1
        end
      rescue
        puts "Error: the user wasn't create. Retry with valid attributes"
        exit 1
      end
      puts "User create ! You can now login using the credentials you provides."
  end
end

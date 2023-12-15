require 'sinatra'
require 'sequel'

############################################
# Database setup
############################################

# connect to an in-memory database
DB = Sequel.sqlite('mydb.db')

# create a dataset from the items table
users = DB[:users]
### But can't create it everytime, so check if it exists in the file.
unless DB.table_exists?(:users)
    # DB Setup suing Sequel
    # create an items table
    DB.create_table :users do
        primary_key :id
        String :username, unique: true, null: false
        String :password, null: false
    end

    # populate the table
    users.insert(username: 'abc', password: '123')
    users.insert(username: 'def', password: '456')
    users.insert(username: 'ghi', password: '789')

    # print out the number of records
    puts "Item count: #{users.count}"

    # print out all the users
    puts "All users: #{users.all}"
end

###########################################
#### Another DB setup for game details with foreign key as user_id
###########################################
# Create a dataset for the game_details table
game_details = DB[:game_details]

# Check if the game_details table exists
unless DB.table_exists?(:game_details)
  # DB Setup using Sequel
  # Create a game_details table with a foreign key reference to the users table
  DB.create_table :game_details do
    primary_key :id
    foreign_key :user_id, :users, key: :id, null: false
    Integer :winnings, default: 0
    Integer :losings, default: 0
    Integer :profits, default: 0
  end

  # Populate the game_details table with sample data
  users.each do |user|
    game_details.insert(user_id: user[:id], winnings: 0, losings: 0, profits: 0)
  end

  # Print out the number of records in the game_details table
  puts "Game details count: #{game_details.count}"

  # Print out all the game details
  puts "All game details: #{game_details.all}"
end


############################################
# Routes and Session handling
############################################

enable :sessions

#########################
#### root
#########################

get '/' do
    erb(:index)
end

#########################
#### lOGIN
#########################

get '/login' do
    erb(:loginform)
end

post '/login' do
    @user = params[:username]
    @pass = params[:password]
    user_in_db = users.where(username: @user, password: @pass).first
    if user_in_db
        session[:user_id] = users.where(username: @user).first[:id]
        redirect '/homepage'
    else
        session[:message] = "Login Failed"
        redirect '/login'
    end
end

#########################
#### SIGN UP
#########################

get '/signup' do
    erb(:signupform)
end

post '/signup' do
    @user = params[:username]
    @pass = params[:password]
    # Check if the username is already taken
    if users.where(username: @user).count > 0
        session[:message] = "Username is already taken. Choose another one."
        redirect '/signup'
    else
        # Insert the new user into the database
        users.insert(username: @user, password: @pass)

        # Log in the new user automatically
        session[:user_id] = users.where(username: @user).first[:id]
        user_id = session[:user_id]
        # Insert corresponding game details for the new user
        game_details.insert(user_id: user_id, winnings: 0, losings: 0, profits: 0)

        # Redirect to the homepage or user profile
        # erb(:homepage) # You can change this to your desired path
        redirect '/homepage'
    end
end

################################
#### HOMEPAGE
################################

get '/homepage' do
    # if the user is authenticated, we set a value for session user_id 
    # otherwise 
    if session[:user_id]
        user_id = session[:user_id]
        @username = users.where(id: user_id).first[:username]
        session[:won] = 0
        session[:lost] = 0
        session[:profit] = session[:won] - session[:lost]
        @won = session[:won]
        @lost = session[:lost]
        @profit = session[:profit]
        current_game_details = game_details.where(user_id: user_id).first
        @current_winnings = current_game_details[:winnings]
        @current_losings = current_game_details[:losings]
        @current_profits = current_game_details[:profits]
        erb(:homepage)
    else
        redirect '/login'
    end
end

post '/homepage' do
    user_id = session[:user_id]
    @username = users.where(id: user_id).first[:username]
    @betmoney = params[:betmoney].to_i
    @guess = params[:guess].to_i
    @randomdice = rand(1..6)
    # Validate betmoney within the limits
    if @betmoney < 1 || @betmoney > 1000
        session[:error] = true
        session[:message_err] = 'Bet in limits: less than 1000 dollars.'
        redirect '/homepage'
    end
    #validate guess
    if @guess < 1 || @guess > 6
        session[:error] = true
        session[:message_err] = 'Dice only has 6 sides'
        redirect '/homepage'
    end
    # print(@betmoney)
    if @guess == @randomdice
        session[:won] = @betmoney*10 + session[:won]
        session[:message] = "You won $#{@betmoney*10}!"
        session[:result] = 'won'
    else
        session[:lost] = @betmoney + session[:lost]
        session[:message] = "You lost $#{@betmoney}."
        session[:result] = 'lost'
    end
    user_id = session[:user_id]
    session[:profit] = session[:won] - session[:lost]
    current_game_details = game_details.where(user_id: user_id).first
    @current_winnings = current_game_details[:winnings]
    @current_losings = current_game_details[:losings]
    @current_profits = current_game_details[:profits]
    @won = session[:won]
    @lost = session[:lost]
    @profit = session[:profit]
    erb(:homepage)
end

###############################
#### Save session
###############################

post '/savesession' do
    # Retrieve session variables
    user_id = session[:user_id]
    session_winnings = session[:won]
    session_losings = session[:lost]
    session_profits = session[:profit]
    # Get the current DB variables
    current_game_details = game_details.where(user_id: user_id).first
    current_winnings = current_game_details[:winnings]
    current_losings = current_game_details[:losings]
    current_profits = current_game_details[:profits]
    # Update the new values in DB
    updated_winnings = current_winnings + session_winnings
    updated_losings = current_losings + session_losings
    updated_profits = current_profits + session_profits
    game_details.where(user_id: user_id).update(winnings: updated_winnings, losings: updated_losings, profits: updated_profits)
    # Reset the session variables
    session[:won] = 0
    session[:lost] = 0
    session[:profit] = 0
    # Redirect to the homepage
    redirect '/homepage'
end

###############################
#### LOGOUT
###############################

post '/logout' do
    session.clear
    redirect '/'
end
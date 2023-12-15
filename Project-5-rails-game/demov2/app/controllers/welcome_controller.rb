class WelcomeController < ApplicationController
  
  def restart_session
    reset_session
    redirect_to root_path, notice: "New session started. Enter a number to begin."
  end

  def index
    # Check if predefined number is set for the session
    unless session[:predefined_number]
      # Define a predefined number for the session
      @predefined_number = guessCreate
      session[:predefined_number] = @predefined_number
    end

    # Initialize session values for the current session
    session[:user_inputs] ||= []
    @user_inputs = session[:user_inputs]

    @user_input = params[:user_input].to_i if params[:user_input].present?
    @random_number = session[:predefined_number]

    if @user_input == session[:predefined_number]
      @game_over = true
      flash[:notice] = "Game over! You guessed the predefined number (#{session[:predefined_number]})."
    else
      if @user_input.present? && !session[:user_inputs].include?(@user_input)
        @cows, @bulls = checker(@random_number, @user_input)
        session[:user_inputs] << @user_input
      end
    end
  end

  private

  def guessCreate
    guesser = (1..9).to_a.shuffle
    guess = guesser[0..2].join.to_i
    return guess
  end

  def checker(number, guess)
    cows = 0
    bulls = 0

    numstring = number.to_s
    guessstring = guess.to_s

    numarray = numstring.chars
    guessarray = guessstring.chars

    # Check for bulls
    3.times do |i|
      if numarray[i] == guessarray[i]
        bulls += 1
      end
    end

    # Check for cows
    numarray.each do |digit|
      if guessarray.include?(digit)
        cows += 1
      end
    end

    cows -= bulls

    [cows, bulls]
  end

end

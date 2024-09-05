class TweetsController < ApplicationController
  before_action :require_login, only: [:create, :destroy]

  def create
    @tweet = @current_user.tweets.new(tweet_params)

    if @tweet.save
      render json: {tweet: {username: @tweet.user.username, message: @tweet.message}}, status: :created
    else
      render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @tweet = Tweet.find_by(id: params[:id])

    if @tweet and @tweet.destroy
      render json: { success: true}
    else
      render json: { success: false }, status: :unauthorized
    end
  end

  def index
    @tweets = Tweet.order(created_at: :desc)
    render json: { tweets: @tweets.map {|tweet| {id: tweet.id, username: tweet.user.username, message: tweet.message}}} 
  end

  def index_by_user
    user = User.find_by(username: params[:username])

    if user
      @tweets = user.tweets.order(created_at: :desc)
      render json: { tweets: @tweets.map {|tweet| {id: tweet.id, username: tweet.user.username, message: tweet.message}}}
    else
      render json: { errors: "User not found" }, status: :not_found
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end

  def require_login
    session_token = cookies.signed[:twitter_session_token]
    session = Session.find_by(token: session_token)

    if session
      @current_user = session.user
    else
      render json: { success: false }, status: :unauthorized
    end
  end
end

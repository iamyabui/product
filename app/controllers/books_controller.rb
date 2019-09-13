class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def show
    @book = Book.find(params[:id])
    other_user = @book.users.where.not(id: current_user.id ).pluck(:id)
    other_emotion = Emotion.where(user_id: other_user).where.not(book_id: params[:id]).pluck(:book_id)
    @other_books = Book.where(id: other_emotion).order("RAND()").limit(5)
  end

  def new; end

  def index
    if params[:keyword].present?
      url = 'https://www.googleapis.com/books/v1/volumes?q='
      request = url + params[:keyword]
      enc_str = URI.encode(request)
      uri = URI.parse(enc_str)
      json = Net::HTTP.get(uri)
      @books = JSON.parse(json)
    else
      @books = 'なし'
    end
  end

  def create; end

end

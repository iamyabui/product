class EmotionsController < ApplicationController
  def new
    @emotion = Emotion.new()
  end

  def create
    @book = Book.new(book_params)
    if Book.where(title: @book.title).length == 0
      @book.save
    end
    book_id = Book.find_by(title: book_params[:title]).id
    @emotion = Emotion.new(emotion_params)
    @emotion.book_id = book_id
    if @emotion.save
      redirect_to root_path
    else
      render :new
    end
  end

  def index
    @tags = Emotion.all_tags
    @emotions = Emotion.all
    if params[:tag_name]
      @emotions = @emotions.tagged_with("#{params[:tag_name]}")
    end
  end

  private

  def emotion_params
    params.require(:emotion).permit(:body,:tag_list).merge(user_id: current_user.id)
  end

  def book_params
    params.require(:emotion).permit(:title,:author,:image_url,:synopsis)
  end
end

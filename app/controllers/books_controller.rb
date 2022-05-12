class BooksController < ApplicationController	
	def index
		if books = Book.all
			render json: books, head: 200
		else
			head 404
		end		
	end

	def show
		if book = Book.find(params[:id])
			render json: book, head: 200
		else
			head 404
		end
	end
end










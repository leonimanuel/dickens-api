require 'nokogiri'
require 'open-uri'

desc "Create New Book"

task create_book: [:environment] do
	print "enter book title: "
	title = STDIN.gets.chomp

	print "enter book author: "
	author = STDIN.gets.chomp

	print "enter full Project Gutenberg book URL: "
	book_url = STDIN.gets.chomp

	begin
		doc = Nokogiri::HTML(URI.open(book_url))

		book = Book.new(
			title: title,
			author: author		
		)		

		if book.save
			doc = Nokogiri::HTML(URI.open(book_url))

			chapters = doc.text.split(/Chapter [A-Z]*\.\r\n\r\n\r\n/) # includes pre- and post-content

			#remove pre-content.
			chapters.shift

			# remove post- content
			chapters[chapters.count - 1] = chapters.last.split(/\*\*\*\sEND/)[0]
			
			chapters.each.with_index(1) do |chapter, index|
				Chapter.create(chapter_number: index, body: chapter.strip, book: book)
				# chapter contents are unsanitized in case we want an unsantized version later for other stuff.
			end			
		end
	rescue
		puts "something went wrong"
	end
end
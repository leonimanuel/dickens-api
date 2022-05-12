class WordPairsController < ApplicationController	
	def index		
		if book = Book.find(params[:book_id])
			parsed_chapters = chapters(params, book).collect { |ch| { chapter_number: ch.chapter_number, body: ch.body.gsub(/—|\n/, " ").gsub(/[[:punct:]]/, "").downcase } } 

			word_pairing_counts = {}
			parsed_chapters.each_with_index do |parsed_chapter, chapter_index|
				content_array = parsed_chapter[:body].split(" ")
				chapter_word_pairs = []

				content_array.each_with_index do |word, word_index| 
					next_word = content_array[word_index + 1]
					word_pair = "#{word} #{next_word}"
					chapter_word_pairs << word_pair
				end

				
				chapter_word_pairs.uniq.each do |word_pair|
					next if word_pairing_counts[word_pair.to_sym]

					chapters_pairing_counts = {}
					parsed_chapters.drop(chapter_index).each do |scanned_chapter|
						match_count = scanned_chapter[:body].scan(/\b#{word_pair}\b/).count
						chapters_pairing_counts["#{scanned_chapter[:chapter_number]}"] = match_count if match_count > 1
					end

					total_pairing_count = chapters_pairing_counts.values.sum
					if total_pairing_count > 1
						word_pairing_counts[word_pair.to_sym] = {
							total_count: total_pairing_count,
							chapter_counts: chapters_pairing_counts
						} 						
					end							
				end
			end

			render json: word_pairing_counts, head: 200
		else
			head 404
		end
	end



	def show
		if book = Book.find(params[:book_id])
			parsed_chapters = chapters(params, book).collect { |ch| { chapter_number: ch.chapter_number, body: ch.body.gsub(/—|\n/, " ").gsub(/[[:punct:]]/, "").downcase } } 			

			word_pair = params[:word_pair]
			chapters_pairing_counts = {}
			
			parsed_chapters.each do |scan_chapter|
				match_count = scanned_chapter[:body].scan(/\b#{word_pair}\b/).count
				chapters_pairing_counts["#{scanned_chapter[:chapter_number]}"] = match_count if match_count > 1
			end

			total_pairing_count = chapters_pairing_counts.values.sum
			word_pairing_counts = {
				total_count: total_pairing_count,
				chapter_counts: chapters_pairing_counts
			} 

			render json: word_pairing_counts, head: 200
		else
			head 404
		end
	end


	private

	def chapters(params, book)
		chapter_numbers = []
		if params[:chapters]
			chapter_numbers = params[:chapters].split(",").collect do |ch_num|
				if ch_num.include?("-")
		 			ch_range = ch_num.split("-")
		 			(ch_range[0]..ch_range[-1]).to_a
				else
					ch_num
				end
			end
			chapter_numbers = chapter_numbers.flatten
		end

		chapters = chapter_numbers.empty? ? book.chapters.all : book.chapters.where(chapter_number: chapter_numbers)
	end		
end










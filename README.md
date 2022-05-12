# dickens-api
A small API with Great Expectations. Use this API for the mission-critical task of counting the word pair's in Charles Dicken's class novel Great Expectations.

# installation
To run this API locally, clone this repo using git clone.

# usage
First, you'll want to set up and migrate the postgres database for this API.

``rake db:setup``

``rake db:migrate``


Then, you'll want to store the novel locally using the prompts provided by the following rake task:

``rake create_book``

Once you've saved the book to your db, you can use the API to start querying information on word pairings.

# API
To start retrieving data on Great Expectations, you'll first need to retrieve the book's ID (after you've created a record for it in your db). You can retrieve this book's ID by making a GET request to:
``/books``

Once you have the id, use it to build a path to the word-pairs resource. 

You can query the API for word-pair counts throughout the entirety of the text by calling ``/books/:id/word-pairs``. To only retrieve word-pair counts for certain chapters, add a query parameter with the ``chapters`` key, like so:

``/books/:id/word-pairs?chapters=5``

Note that you can also filter for multiple chapters by listing each chapter separately, separated by a comma, as well as specify chapter ranges with a hyphen "-". For example, the API call below will retrieve word-pair counts for chapters 1 through 5, as well as chapters 9 and 13.

``/books/:id/word-pairs?chapters=1-5,9,13``

Finally, you can also search for specific word-pair tallies by adding your word pair to the URL path, like so:

``/books/:id/word-pairs/the churchyard?chapters=1-5``

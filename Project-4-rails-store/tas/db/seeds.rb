# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Product.delete_all

# Create new records with descriptions
Product.create!(title: 'The Great Gatsby', 
                description: 'A classic novel written by F. Scott Fitzgerald, set in the Jazz Age.',
                image_url: 'tgg.jpg',
                price: 12.99)
Product.create!(title: 'The Catcher in the Rye',
                description: 'A controversial novel by J.D. Salinger, featuring the character Holden Caulfield.',
                image_url: 'citrye.jpg',
                price: 19.99)
Product.create!(title: 'The Grapes of Wrath',
                description: 'A Pulitzer Prize-winning novel by John Steinbeck, depicting the plight of a farming family during the Great Depression.',
                image_url: 'tgow.jpg',
                price: 14.99)
Product.create!(title: 'The Sun Also Rises',
                description: 'A novel by Ernest Hemingway about a group of American and British expatriates traveling from Paris to Pamplona to watch the running of the bulls.',
                image_url: 'tsar.jpg',
                price: 9.99)
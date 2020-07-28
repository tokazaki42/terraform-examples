
cd ..

#sudo apt install libmysqld-dev

#rails new "rails-example" --database=mysql



rails g scaffold Author name
rails g scaffold Book title author:references

rails db:create
rails db:migrate

rails routes


# Rails 6 needs webpacker
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn

rails webpacker:install




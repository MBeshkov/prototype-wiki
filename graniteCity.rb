require 'sinatra'
require 'sinatra/activerecord'
set :bind, '0.0.0.0'

ActiveRecord::Base.establish_connection(
:adapter => 'sqlite3',
:database => 'wiki.db'
)

class User < ActiveRecord::Base
	#This checks the attributes a user needs in databse: a username and a unique password
	validates :username, presence: true, uniqueness: true
	validates :password, presence: true
end

helpers do
	#This function checks if login details are correct
	def protected!
		if authorized?
			return
		end
		#User sent to denied page if login details is not stored in database
		redirect '/denied'
	end
	
	def authorized?
		#This just chekcs to see if you are admin user and if you have permission to do requested action
					if $credentials != nil
							@Userz = User.where(:username => $credentials[0]).to_a.first
							if @Userz
									if @Userz.edit == true
										return true
									else
										return false
									end
							else 
									return false
							end
					end
	end
end

#All the necessary global and object variables defined here	
$myinfo = "WAD GROUP S"
@info = ""
$pages=Array.new
$list=Array.new
$creators=Array.new
File.foreach("pages.txt") { |line| 
	$list.push(line)
}


def readFile(filename)
	#This is a function that reads the files and returns the contents
    content=""
    file=File.open(filename)
    file.each do |line|
        content+=line
    end
    file.close
    return "#{content}"
end

#This is the home page and what is displayed there
get '/' do
	info = ""
	len = info.length
	len1 = len
	readFile("wiki.txt")
	@info = info + " " + $myinfo
	len = @info.length
	len2 = len - 1
	len3 = len2 - len1
	@words = len3.to_s
	#WelcomeMsg is displayed when the user goes onto the home page
	welcomeMsg = "Hello there! How is it going? Are you resting from a long journey or is the big adventure still in front of you? Have you been around for decades or is this your first day here? Whoever you are, whatever your story is, we all have one thing in common: Aberdeen is our home! So go ahead, share your tale with the world and tell us all about your favourite spot in the city!"
	wordsCount = welcomeMsg.split(" ")
 	@wordsCount = wordsCount.length.to_s
 	charCount = wordsCount.join('')
 	@charCount = charCount.size
	#erb: home handles the view for the home page	
	erb :home, :layout => :homelayout
end

#Handles the view for the admin controls page and ensures it is of protected restriction
 
get '/admincontrols' do
	protected!
	@list2 = User.all.sort_by { |u| [u.id] }
	erb :admincontrols
end

#Displays the about page

get '/about' do
	erb :about
end

#Redirects user and displays content of page name passed through URL
get '/display/:page' do
	page="#{params[:page]}"
	readFile("pages/"+page+".txt")
	erb :display, :layout => :displaylayout
end

#Shows the create page
get '/create' do
	erb :create
end	

#This handles how a user types in text, creates a text file of their submitted content and stores their content within the website
put '/create' do
	title="#{params[:title]}"
	text="#{params[:text]}"
	creator=$credentials[0]
	file= File.new("pages/#{title}.txt", "a+")
	filee= File.open("pages/#{title}.txt", "w")
	filee.puts text
	filee.close

	creators= File.open("creators.txt", "a+")
	creators.puts creator
	creators.close

	$creators.push(creator)
	$pages.push(title)
	$list.push(title)
	File.open("pages.txt", "a") do |f|
  		$pages.each{
  			|page| f.puts(page)
  		}
	end
	redirect '/'
end

get '/reset/:page' do #Allows the Admin to access the "Reset" button in a chosen wiki page to clear out the text and update it to the "A fresh strat!" message.
	page="#{params[:page]}"
	t = Time.now
	@reset_text = "A fresh start!"
	file = File.open("pages/"+page+".txt", "w")
	file.puts @reset_text
	file.close
	redirect '/display/'+page
end

#Displays the edit page
get '/edit/:page' do
	erb :edit, :layout => :displaylayout
end

put '/edit/:page' do #Stores the users names and login times in an "editing-log.txt" file everytime the users login into the wiki.
	page="#{params[:page]}"
	info = "#{params[:message]}"
	@info = info
	t = Time.now
	file = File.open("editing-log.txt", "a+b")
	file.write "\n"
	file.puts t.to_s + "      user: "+ $credentials[0].to_s + "     page: " + page 
	file.write "\n" 
	file.puts info
	file.write "\n"
	file.write "------------"
	file.write "\n"
	file.close
	file = File.open("./pages/"+page+".txt", "w")
	file.puts @info
	file.close
	redirect '/'
end	

#When admin clicks reset hbutton, they are directed to admin controls again
get '/reset' do
	erb :admincontrols
end

get '/login' do
	erb :login
end

get '/logout' do
	$credentials = nil
	erb :home, :layout => :homelayout
end

#Stores everytime a user logs in tp a text file such as time, username and password of login
#handles every possible scenario of a login such as correct login, incorrect login etc.
post '/login' do
	$credentials = [params[:username],params[:password]]
	@Users = User.where(:username => $credentials[0]).to_a.first
	if @Users
		if @Users.password == $credentials[1]
		t = Time.now
		file = File.open("logtime.txt", "a+b")
		file.puts t.to_s + " " + params[:username]
		file.close
		redirect '/'
		else 
			$credentials = ['','']
			redirect '/wrongaccount'
		end
	else
		$credentials = ['','']
		redirect '/wrongaccount'	
	end	
end

get '/wrongaccount' do
	erb :wrongaccount
end

get '/createaccount' do
	erb :createaccount
end

#Handles creation of accounts
post '/createaccount' do n = User.new
	n.username = params[:username]
	n.password = params[:password]
	#If you are admin, you can change the content of user created content
	if n.username == "Admin" and n.password == "Password"
		n.edit = true
	end
	n.save
	redirect "/"
end

#Handles deletion of a user account
get '/user/delete/:uzer' do
	protected!
	n = User.where(:username => params[:uzer]).to_a.first
	if n.username == "Admin"
		#You cant destroy the admin account
		erb :denied
	else
		#Any other user can be deleted
		n.destroy
		@list2 = User.all.sort_by{|u| [u.id]}
		erb :admincontrols
	end
end

#Changes editing privileges of a user as defined by the admin
put '/user/:uzer' do
	n = User.where(:username => params[:uzer]).to_a.first
	n.edit = params[:edit] ? 1 : 0
	n.save
	redirect '/admincontrols'
end

get '/notfound' do
	erb :notfound
end

get '/noaccount' do
	erb :noaccount
end

get '/denied' do
	erb :denied
end


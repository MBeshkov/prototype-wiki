# ruby-prototype-wiki
Granite City Stories, a prototype of a platform for people to express their love for Aberdeen. 


One could share anything they find 
interesting in the city, ranging from favourite parks to any shops they may love. The end goal is to build a community 
in which people will openly discuss everything about this lovely place. We are trying to foster this sense of belonging 
through a modern look which would hopefully be appealing to a wide audience. 

Originally created in 2019.

### Technologies utilised 
- Ruby
- Sinatra gem
- Active Record gem
- HTML
- CSS
- JavaScript
- jQuery 

### System requirements/run instructions 
- Preferably the newest version of Ruby installed (current stable version is 2.6.5) at time of writing 
- Command Line Prompt 
- Active record gem (ruby 2.2.2 or greater is needed for installation) 
- Sinatra gem 
- For admin logon:

 Username = Admin 
 
 Password = admin
 
 ### How to start?
 
To load the wiki, the user has to open Command Line Prompt, navigate to the folder where the graniteCity.rb file is 
located and type “ruby graniteCity.rb”, then press Enter. If they then proceed to open any browser and type in 
“localhost:4567”, the wiki should be up and running! 

### Functionality

#### Home 

To progress past the landing page, the user has to click the “Get started” button which will take them to the 
home page.

This page is the main hub of the wiki. The main elements here are: 
1) A list of all the user created pages, displayed in a blue block to the left. 
2) A search bar for easier access to a desired page. 
3) The introductory text as well as a count of the characters and words it contains. 
4) The video Elia Orsini made in his free time.

#### Articles

If a user clicks one of the blue buttons to the left, they are then greeted to one of the user created articles.

As it will be seen, the page 
cannot be edited unless 
the user is the person who 
created it in the first place 
(an exception being the 
admin, of course) and if 
the user doesn’t have 
editing rights. If the user 
wishes to continue 
exploring other pages, 
then they must simply press 
COME BACK HOME where 
the rest of the stories will be waiting for him. If they want to share their own tale, they must simply log in/sign up by 
pressing the “Login” button. 

#### Admin and users

For the sake of demonstration, log in 
with username “Admin” and password
“admin” to access admin controls. 

The administrator has access to the following:

- A list of all users
- The date and time of them signing up
- Information about the status of their edit rights
- The option to give edit rights
- The option to delete a user
- The option to edit/reset already existing pages

Feel free to create a test user after that as well. It is worth mentioning that each time a user makes a change to a
page, it is stored in the “editing-log” file.
Additionally, each time a user logs in, it is stored in the “logtime” file
in the same folder.

#### Creating content

The "share your story" box allows a logged in user to upload whatever text they desire onto the website, it can be anything to do with 
Aberdeen. Every single time that a user inputs text and clicks the “create” button, it’s saved both as an activity to the 
logfile and as information into the archive. 
If, however, they click onto the create button without being logged in, the "you need to be logged in" page is displayed.


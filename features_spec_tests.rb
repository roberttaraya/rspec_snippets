feature 'User can sign in and sign out' do

  let(:user_attrs) { { username: 'carter', password: 'password' } }
  let!(:user) {User.create(user_attrs)}

  scenario 'when clicks sign in' do
    visit new_session_path
    expect(current_path).to eq(new_session_path)
  end

  it "user fills in valid username and password" do
    visit new_session_path
    fill_in('session[username]', :with => user_attrs[:username])
    fill_in('session[password]', :with => user_attrs[:password])
    click_button('Sign In')
    expect(current_path).to eq(root_path)
  end

  it "user fills in invalid username and password" do
    visit new_session_path
    fill_in('session[username]', :with => 'wrong')
    fill_in('session[password]', :with => 'wrong')
    click_button('Sign In')
    expect(current_path).to eq(new_session_path)
  end

  it "user can log out" do
    visit new_session_path
    fill_in('session[username]', :with => user_attrs[:username])
    fill_in('session[password]', :with => user_attrs[:password])
    click_button('Sign In')
    click_link('Log Out')
    expect(page).to_not have_link("Log Out")
  end
end

feature "Guest signs in" do

  context "Guests can't see other users' pages" do

    let!(:user1){User.create({ username: 'carter', password: 'password' })}
    let!(:user2){User.create({ username: 'smartalek', password: 'password' })}

    before(:each) do
      visit root_path
      click_on "Sign In"
      fill_in("session_username", :with => 'carter')
      fill_in("session_password", :with => 'password')
      click_button("Sign In!")
    end

    it "Logged-in user can visit own page" do
      visit user_path(user1.id)
      expect(current_path).to eq(user_path(user1.id))
    end

    it "Logged-in user cannot visit other users' pages" do
      visit user_path(user2.id)
      expect(page).to_not have_content(user2.username)
    end
  end
end

====================

feature "Homepage" do
  scenario "user can add a new topic" do
    visit root_path
    click_on "Add a New Cut!"
    expect(current_path).to eq(new_topic_path)
  end

  scenario "user clicks on a topic" do
    topic = Topic.create(title: "okay so steak", content: "is yummy")
    visit root_path
    click_on "okay so steak"
    expect(current_path).to eq(topic_path(topic.id))
  end
end

feature "New topic page" do
  before :each do
    visit new_topic_path
  end

  it "topic creation lands on homepage" do
    fill_in("topic[title]", :with => "Moooooar")
    fill_in("topic[content]", :with => "eat things")
    click_button('Cook!')
    expect(current_path).to eq("/")
  end

  it "home button sends you back to the root" do
    click_link("Home")
    expect(current_path).to eq("/")
  end

end

feature 'Comments' do

  let!(:topic) { Topic.create(title: "TEST", content: "Bacon and eggs plz")}
  let!(:topic2) { Topic.create(title: "Sumpin Else", content: "Thomas is awesome")}
  let!(:other_comment) {
    Comment.create(text: "This is stupid", topic_id: topic2.id)
    Comment.where(topic_id: topic2.id).first.text }

  it "can visit the topic's page" do
    visit topic_path(topic.id)
    expect(current_path).to eq("/topics/#{topic.id}")
  end

  it "can create a comment on a topic" do
    visit topic_comments_path(topic.id)
    fill_in("comment[text]", :with => "that's a great idea")
    click_button("Comment")
    expect(page).to_not have_content(other_comment)
  end
end

feature "User topics page:" do

  let!(:user1) { User.create(
    username: 'carter',
    password: 'password')}
  let!(:topic) { Topic.create(
    title: "TEST",
    content: "Bacon and eggs plz",
    user_id: user1.id)}

  before(:each) do
    visit root_path
    click_on "Sign In"
    fill_in("session_username", with: user1.username)
    fill_in("session_password", with: user1.password)
    click_button("Sign In!")
  end

  context 'logged in user' do
    scenario 'can edit own topic' do
      click_on "#{user1.username}"
      click_on "Edit"
      fill_in("topic[title]", :with => "Moooooar")
      fill_in("topic[content]", :with => "eat things")
      click_on "Cook!"
      click_on "Moooooar"
      expect(page).to have_content("eat things")
    end

    scenario 'can delete own topic' do
      click_on "#{user1.username}"
      click_on "Delete"
      expect(page).to_not have_content("TEST")
    end
  end
end

====================

feature "Guest can sign up" do
  before :each do
    visit root_path
    click_on "Sign Up"
  end

  scenario "Guest clicks on sign up on homepage" do
    expect(current_path).to eq(new_user_path)
  end

  context "Guest enters in their name and password" do

    before(:each) do
      fill_in("user_username", :with => "Salarar")
      fill_in("user_password", :with => "sucksalot")
      click_button('Sign Up!')
    end

    it "should reload the home page" do
      expect(current_path).to eq(root_path)
    end

    it "and won't see the sign up button" do
      expect(page).to_not have_link("Sign Up")
    end

    it "and won't see the sign in button" do
      expect(page).to_not have_link("Sign In")
    end

  end

  context "Guest enters in invalid information" do

  end

end

====================

feature 'Guest' do
  let(:valid_attributes) {
      { title:"New title!", description:"lots of content", image_url: "http://eofdreams.com/data_images/dreams/cat/cat-06.jpg" }
  }
  let(:story) {Story.create(valid_attributes)}

  context "on index page" do
    it "can click a topic to see its page" do
      story
      visit root_path
      click_link "New title!"
      sleep(1)
      expect(page).to have_content "#{story.description}"
    end
  end
end

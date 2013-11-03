require 'spec_helper'

describe User do
  describe "username" do
    it { should validate_uniqueness_of(:username)}
    it { should ensure_length_of(:username).is_at_least(6) }
    it { should ensure_length_of(:username).is_at_most(20) }
  end
  describe "password" do
    it { should validate_presence_of(:password_digest) }
    it { should_not allow_mass_assignment_of(:password) }
    it { should ensure_length_of(:password).is_at_least(6) }
    it { should ensure_length_of(:password).is_at_most(20) }
  end
end

describe Submission do

  let!(:my_submission){
    Submission.new
  }
  it 'should validate presence of a title' do
    my_submission.should_not be_valid
  end

  it 'should validate presence of a url' do
    my_submission.should_not be_valid
  end

  it 'should validate the format of a URL' do
    my_submission.url = 'http://www.thisisaurl.com'
    my_submission.title = 'this is a title'
    my_submission.save
    my_submission.should be_valid
  end

  it 'should reject an invalid URL format' do
    my_submission.url = 'invalid URL'
    my_submission.title = 'this is a title'
    my_submission.save
    my_submission.should_not be_valid
  end
end

describe OtherModels do
  it { should ensure_length_of(:ssn).is_equal_to(9) }
  it { should allow_mass_assignment_of(:first_name) }
  it { should ensure_inclusion_of(:age).in_range(0..100)
  it { should validate_confirmation_of(:password)
  it { should validate_numericality_of(:price) }
  it { should validate_numericality_of(:age).only_integer }

  it { should belong_to(:lover) }
  it { should have_one(:profile) }
  it { should have_many(:comments) }
  it { should have_many(:messes).through(:dogs) }
  it { should have_many(:enemies).dependent(:destroy) }
  it { should have_and_belong_to_many(:posts)

  it { should_not have_db_column(:admin).of_type(:boolean) }
  it { should have_db_column(:salary).
                      of_type(:decimal).
                      with_options(:precision => 10, :scale => 2) }
end





class Authorization < ActiveRecord::Base
	belongs_to :user

	after_create :fetch_details

	def fetch_details
		self.send("fetch_details_from_#{provider.downcase}") if provider
	end

	def fetch_details_from_facebook
		graph = Koala::Facebook::API.new(self.token)
		facebook_data = graph.get_object("me")
		self.username = facebook_data['username']
		self.save
		self
	end

	def fetch_details_from_twitter
    self
	end

	def fetch_details_from_github
    self
	end

	def fetch_details_from_linkedin
    self
	end

	def fetch_details_from_google_oauth2
    self
	end

end

# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  user_id    :integer
#  token      :string(255)
#  secret     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  username   :string(255)
#

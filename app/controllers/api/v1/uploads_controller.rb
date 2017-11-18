module Api
  module v1
    class UploadsController < BaseController

      before_action :authenticate_user_from_token!

      def index
        bucket_name = 'foam-finger-nation'

        # Start a session with restricted permissions.
        sts = AWS::STS.new(
          :access_key_id => ENV["AWS_SECRET_KEY_ID"],
          :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]
        )
        policy = AWS::STS::Policy.new
        policy.allow(
          :actions => ["s3:PutObject"],
          :resources => "arn:aws:s3:::#{bucket_name}")

        session = sts.new_federated_session(
          current_user.username,
          :policy => policy,
          :duration => 15*60)

        render json: session, status: :ok
      end
    end
  end
end

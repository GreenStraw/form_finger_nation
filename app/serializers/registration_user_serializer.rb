class RegistrationUserSerializer < UserSerializer
  self.root = 'user'
  attributes :authentication_token
end

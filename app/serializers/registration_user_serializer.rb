class RegistrationUserSerializer < UserSerializer
  self.root = false
  attributes :authentication_token
end

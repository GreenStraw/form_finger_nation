class Endorsement < ActiveRecord::Base
  belongs_to :endorsable, polymorphic: true
  belongs_to :endorser, polymorphic: true
end

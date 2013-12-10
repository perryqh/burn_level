module Role
  extend ActiveSupport::Concern

  ADMIN, JOCK = 'admin', 'jock'
  ROLES       = [ADMIN, JOCK]

  module ClassMethods
    ROLES.each do |r|
      define_method("#{r}?".to_sym) { self.role == r }
    end
  end
end

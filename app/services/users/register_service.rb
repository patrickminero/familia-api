module Users
  class RegisterService
    def initialize(params)
      @params = params
    end

    def call
      user = User.new(@params)

      if user.save
        { user: user }
      else
        { errors: user.errors.full_messages }
      end
    end
  end
end

module Support

  # This authentication helper is for controller specs only.
  #
  module Authentication

    # Authentication helpers and macros for controller specs
    #
    module Controller

      # Confirms and authenticates the given user.
      #
      # @param mapping [Symbol] mapping the warden mapping to user
      # @param user [User] the user to authenticate
      #
      def authenticate(mapping, user)
        @request.env['devise.mapping'] = Devise.mappings[mapping]

        if user.respond_to?(:regions)
          @request.host = "#{ user.regions.first.subdomain }.test.host"
        end

        user.confirm! if user.respond_to?(:confirm!)
        sign_in mapping, user

        user
      end

      # Macros that get included into Controller type specs.
      #
      module Macros

        # Assigns an admin to a method, like the let method,
        # but authorizes the specified user
        #
        # @param name [Symbol] the name of the new method
        # @param block [Proc] the block to evaluate
        #
        def auth_admin(name, &block)
          let(name, &block)
          before { authenticate(:admin, send(name)) }
        end

        # Assigns a broker to a method, like the let method,
        # but authorizes the specified user
        #
        # @param name [Symbol] the name of the new method
        # @param block [Proc] the block to evaluate
        #
        def auth_broker(name, &block)
          let(name, &block)
          before { authenticate(:broker, send(name)) }
        end

        # Assigns a provider to a method, like the let method,
        # but authorizes the specified user
        #
        # @param name [Symbol] the name of the new method
        # @param block [Proc] the block to evaluate
        #
        def auth_provider(name, &block)
          let(name, &block)
          before { authenticate(:provider, send(name)) }
        end

        # Assigns a seeker to a method, like the let method,
        # but authorizes the specified user
        #
        # @param name [Symbol] the name of the new method
        # @param block [Proc] the block to evaluate
        #
        def auth_seeker(name, &block)
          let(name, &block)
          before { authenticate(:seeker, send(name)) }
        end

      end
    end
  end
end

# coding: UTF-8

module Support

  # This integration helper provides some DSL methods
  # for the integration tests.
  #
  module Feature

    # Scopes the block actions to a flash notification
    #
    # The name of the section will be converted to lowercase
    # and dasherized and looked up as class on a section tag.
    #
    def within_notifications
      within(:xpath, ".//div[contains(concat(' ', @class, ' '), ' notifications ')]") do
        yield
      end
    end

    # Scopes the block actions to a HTML 5 section element.
    #
    # The name of the section will be converted to lowercase
    # and dasherized and looked up as class on a section tag.
    #
    # @param [String] name the section name
    #
    def within_section(name)
      section = name.downcase.gsub(' ', '-')
      within(:xpath, ".//section[contains(concat(' ', @class, ' '), ' #{ section } ')]") do
        yield
      end
    end

    # Scopes the block actions to a HTML 5 article element.
    #
    # The name of the article will be converted to lowercase
    # and dasherized and looked up as class on an article tag.
    #
    # @param [String] name the article name
    #
    def within_article(name)
      article = name.downcase.gsub(' ', '-')
      within(:xpath, ".//article[contains(concat(' ', @class, ' '), ' #{ article } ')]") do
        yield
      end
    end

    # Scopes the block actions to a HTML 5 nav element.
    #
    # The name of the nav will be converted to lowercase
    # and dasherized and looked up as class on an nav tag.
    #
    # @param [String] name the nav name
    #
    def within_navigation(name)
      nav = name.downcase.gsub(' ', '-')
      within(:xpath, ".//nav[contains(concat(' ', @class, ' '), ' #{ nav } ')]") do
        yield
      end
    end

    # Click into a HTML section.
    #
    # The name of the section will be converted to lowercase
    # and dasherized and looked up as class on a section tag.
    #
    # @param [String] name the section title
    #
    def click_section(name)
      section = name.downcase.gsub(' ', '-')
      find(:xpath, ".//section[contains(concat(' ', @class, ' '), ' #{ section } ')]").click
    end

    # Click into a header with a given text
    #
    # @param [String] text the header text
    #
    def click_header(text)
      find(:xpath, ".//*[self::h1 or self::h2 or self::h3 or self::h4 or self::h5 or self::h6][normalize-space()='#{ text }']").click
    end

    # Select a date from multiple selects
    #
    # @param [Date] date the date to select
    # @param [Hash] options the select options
    #
    def select_date(date, options = {})
      field = find_field(options[:from])
      field = field[:id].sub('_3i', '')

      select date.year.to_s,   from: "#{ field }_1i"
      select_by_id date.month, from: "#{ field }_2i"
      select date.day.to_s,    from: "#{ field }_3i"
    end

    # Select an option by id
    #
    # @param [String] id the element id
    # @param [Hash] options the select options
    #
    def select_by_id(id, options = {})
      field = options[:from]
      option_xpath = "//*[@id='#{ field }']/option[#{ id }]"
      option_text = find(:xpath, option_xpath).text
      select option_text, from: field
    end

    # Mock a facebook oauth request
    #
    # @param [Seeker] user the seeker to mock
    #
    def mock_facebook_oauth(user)
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OpenStruct.new({
        provider: :facebook,
        uid: user.uid || '1234',
        info: OpenStruct.new({
          email: user.email
        }),
        extra: OpenStruct.new({
          raw_info: OpenStruct.new({
            first_name: user.firstname,
            last_name: user.lastname
          })
        })
      })
    end
  end

end

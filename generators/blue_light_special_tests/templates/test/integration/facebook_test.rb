require 'test_helper'

class FacebookTest < ActionController::IntegrationTest
  
  if BlueLightSpecial.configuration.use_facebook_connect

    context 'Signing in with Facebook' do
    
      setup do
        cookies[BlueLightSpecial.configuration.facebook_api_key + "_user"] = "8055"
        cookies[BlueLightSpecial.configuration.facebook_api_key + "_session_key"] = "123456789"
        FakeWeb.register_uri(:post,
                             %r|http://api.facebook.com/restserver.php|,
                             :body => '[{"about_me":"","activities":"","affiliations":{},"birthday":"July 18","books":"","current_location":{"city":"Orlando","state":"Florida","country":"United States","zip":""},"education_history":[{"name":"Florida Institute of Technology","year":1995,"concentrations":{},"degree":"","school_type":"Unknown"}],"first_name":"Bob","hometown_location":null,"hs_info":{"hs1_name":"Cheyenne Mountain High School","hs2_name":"","grad_year":1992,"hs1_id":3202,"hs2_id":0},"interests":"","is_app_user":true,"last_name":"Jones","meeting_for":{},"meeting_sex":{},"movies":"","music":"","name":"Bob Jones","notes_count":null,"pic":"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-sf2p\/hs272.snc3\/23197_1334019372_5345_s.jpg","pic_big":"http:\/\/profile.ak.fbcdn.net\/v228\/245\/118\/n1334019372_6158.jpg","pic_small":"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-sf2p\/hs272.snc3\/23197_1334019372_5345_t.jpg","political":"","profile_update_time":1267034911,"quotes":"","relationship_status":"","religion":"","sex":"male","significant_other_id":null,"status":{"message":"","time":0,"status_id":0},"timezone":-5,"tv":"","uid":8055,"wall_count":34,"work_history":{},"pic_square":"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-sf2p\/hs272.snc3\/23197_1334019372_5345_q.jpg","has_added_app":true,"email_hashes":{},"locale":"en_US","profile_url":"http:\/\/www.facebook.com\/profile.php?id=1334019372","proxied_email":"apps+339309032618.1334019372.a320f4a38471f7b537079f5c13bb33f1@proxymail.facebook.com","pic_big_with_logo":"http:\/\/external.ak.fbcdn.net\/safe_image.php?logo&d=20fef10357c21b2e1acc8dac7d4bed49&url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv228%2F245%2F118%2Fn1334019372_6158.jpg&v=5","pic_small_with_logo":"http:\/\/external.ak.fbcdn.net\/safe_image.php?logo&d=ad4b560e363f5b40ccbe81e1d985c91e&url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fhprofile-ak-sf2p%2Fhs272.snc3%2F23197_1334019372_5345_t.jpg&v=5","pic_square_with_logo":"http:\/\/external.ak.fbcdn.net\/safe_image.php?logo&d=a0118842ed70fce04e7883f5ab52023f&url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fhprofile-ak-sf2p%2Fhs272.snc3%2F23197_1334019372_5345_q.jpg&v=5","pic_with_logo":"http:\/\/external.ak.fbcdn.net\/safe_image.php?logo&d=eb90cc8c5f332436f5d56009aab6b467&url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fhprofile-ak-sf2p%2Fhs272.snc3%2F23197_1334019372_5345_s.jpg&v=5","birthday_date":"07\/18","email":"bob@example.com","allowed_restrictions":"alcohol"}]'
                             )
      end
    
      teardown do
        cookies[BlueLightSpecial.configuration.facebook_api_key + "_user"] = nil
        cookies[BlueLightSpecial.configuration.facebook_api_key + "_session_key"] = nil
      end
    
      should 'find an existing user with the facebook uid' do
        user = Factory( :facebook_user,
                        :facebook_uid => 8055,
                        :email => 'bob@facebook.com')

        visit fb_connect_url
        assert controller.signed_in?
        assert_equal controller.current_user, user
      end

      should 'find an existing user with the facebook email address' do
        user = Factory( :user,
                        :facebook_uid => nil,
                        :email => 'bob@example.com')

        visit fb_connect_url
        assert controller.signed_in?
        assert_equal controller.current_user, user
      end

      should 'create a new user when the facebook uid is not found' do
        assert_nil User.find_by_facebook_uid(8055)
    
        visit fb_connect_url
        assert controller.signed_in?
        assert_equal '8055', controller.current_user.facebook_uid
      end
  
      should 'copy the facebook user details' do
        visit fb_connect_url
        assert controller.signed_in?
        assert_equal 'bob@example.com', controller.current_user.email
      end
  
    end

  end

end

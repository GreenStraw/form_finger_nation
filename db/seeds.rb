# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first

# User.all.map(&:destroy)
Sport.all.map(&:destroy)
Team.all.map(&:destroy)
Venue.all.map(&:destroy)
Party.all.map(&:destroy)
Package.all.map(&:destroy)

t = Tenant.first_or_create({
 :name => 'FoamFingerNation',
 :api_token => 'SPEAKFRIENDANDENTER'
})
Tenant.set_current_tenant(t)

# User.create([
#   { email: 'admin@test.com', password: '123123123', password_confirmation: '123123123', username: 'ndanger', first_name: 'Nick', last_name: 'Danger', confirmed_at: DateTime.now, address: Address.create(city: 'Dallas', state: 'TX', zip: '75040') },
#   { email: 'team_admin@test.com', password: '123123123', password_confirmation: '123123123', username: 'pdtpickle', first_name: 'Rocky', confirmed_at: DateTime.now, last_name: 'Rococo', address: Address.create(city: 'Oklahoma City', state: 'OK', zip: '73105')},
#   { email: 'venue_manager@test.com', password: '123123123', password_confirmation: '123123123', username: 'rspoilsport', first_name: 'Ralph', confirmed_at: DateTime.now, last_name: 'Spoilsport', address: Address.create(city: 'Austin', state: 'TX', zip: '78726')},
#   { email: 'user@test.com', password: '123123123', password_confirmation: '123123123', username: 'jbeets', first_name: 'Joe', last_name: 'Beets', confirmed_at: DateTime.now, address: Address.create(city: 'Austin', state: 'TX', zip: '78728')}
# ])

s = Sport.create({ name: 'NFL' })
s.remote_image_url_url = "https://s3.amazonaws.com/foam-finger-nation/images/football.png"
s.save!
s = Sport.create({ name: 'MLB' })
s.remote_image_url_url = "https://s3.amazonaws.com/foam-finger-nation/images/baseball.png"
s.save!
s = Sport.create({ name: 'SOCCER' })
s.remote_image_url_url = "https://s3.amazonaws.com/foam-finger-nation/images/soccer.png"
s.save!
s = Sport.create({ name: 'NCAA-BASEBALL' })
s.remote_image_url_url = "https://s3.amazonaws.com/foam-finger-nation/images/baseball.png"
s.save!
s = Sport.create({ name: 'NCAA-FOOTBALL' })
s.remote_image_url_url = "https://s3.amazonaws.com/foam-finger-nation/images/football.png"
s.save!
s = Sport.create({ name: 'NCAA-BASKETBALL' })
s.remote_image_url_url = "https://s3.amazonaws.com/foam-finger-nation/images/basketball.png"
s.save!
s = Sport.create({ name: 'NBA' })
s.remote_image_url_url = "https://s3.amazonaws.com/foam-finger-nation/images/basketball.png"
s.save!
s = Sport.create({ name: 'TENNIS' })
s.remote_image_url_url = "https://s3.amazonaws.com/foam-finger-nation/images/tennis.png"
s.save!

Team.create([
  { name: 'FC Dallas', sport: Sport.find_by_name('SOCCER'), address: Address.create(city: 'Dallas', state: 'TX'), twitter_name: 'FCDallas', twitter_widget_id: '356614379791319040'},
  { name: 'Houston Dynamo', sport: Sport.find_by_name('SOCCER'), address: Address.create(city: 'Houston', state: 'TX'), twitter_name: 'HoustonDynamo', twitter_widget_id: '356615556335542273'},
  { name: 'Chicago Fire', sport: Sport.find_by_name('SOCCER'), address: Address.create(city: 'Chicago', state: 'IL'), twitter_name: 'ChicagoFire', twitter_widget_id: '356614509118492672'},
  { name: 'Colorado Rapids', sport: Sport.find_by_name('SOCCER'), address: Address.create(city: 'Denver', state: 'CO'), twitter_name: 'ColoradoRapids', twitter_widget_id: '356613923887259648'},
  { name: 'Real Salt Lake', sport: Sport.find_by_name('SOCCER'), address: Address.create(city: 'Salt Lake City', state: 'UT'), twitter_name: 'RealSaltLake', twitter_widget_id: '356614970722631681'},
  { name: 'San Jose Earthquakes', sport: Sport.find_by_name('SOCCER'), address: Address.create(city: 'San Jose', state: 'CA'), twitter_name: 'SJEarthquakes', twitter_widget_id: '356615344758067201'},
  { name: 'Portland Timbers', sport: Sport.find_by_name('SOCCER'), address: Address.create(city: 'Portland', state: 'OR'), twitter_name: 'TimbersFC', twitter_widget_id: '356614274606563331'},
  { name: 'Los Angeles Galaxy', sport: Sport.find_by_name('SOCCER'), address: Address.create(city: 'Los Angeles', state: 'CA'), twitter_name: 'LAGalaxy', twitter_widget_id: '356614146646740992'},
  { name: 'Columbus Crew', sport: Sport.find_by_name('SOCCER'), address: Address.create(city: 'Columbus', state: 'OH'), twitter_name: 'ColumbusCrew', twitter_widget_id: '356615234393346049'},

  { name: 'Dallas Cowboys', sport: Sport.find_by_name('NFL'), address: Address.create(city: 'Dallas', state: 'TX'), twitter_name: 'dallascowboys', twitter_widget_id: '356429854662602758'},

  { name: 'Air Force Falcons', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Colorado Springs', state: 'CO'), college: true, twitter_name: 'AF_Falcons', twitter_widget_id: '356582241608028160'},
  { name: 'Akron Zips', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Akron', state: 'OH'), college: true, twitter_name: 'ZipsFB', twitter_widget_id: '356579001369767936'},
  { name: 'Alabama Crimson Tide', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Tuscaloosa', state: 'AL'), college: true, twitter_name: 'AlabamaFTBL', twitter_widget_id: '356505311890255873'},
  { name: 'Arizona State Sun Devils', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Phoenix', state: 'AZ'), college: true, twitter_name: 'FootballASU', twitter_widget_id: '356503261605396480'},
  { name: 'Arizona Wildcats', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Tuscon', state: 'AZ'), college: true, twitter_name: 'ArizonaFball', twitter_widget_id: '356503120454483968'},
  { name: 'Arkansas Razorbacks', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Fayetteville', state: 'AK'), college: true, twitter_name: 'RazorbackFB', twitter_widget_id: '356505484041265155'},
  { name: 'Arkansas State Red Wolves', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Jonesboro', state: 'AK'), college: true, twitter_name: 'ArkStFootball', twitter_widget_id: '356585038260883456'},
  { name: 'Army Black Knights', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'West Point', state: 'NY'), college: true, twitter_name: 'Army_Football', twitter_widget_id: '356495291551203328'},
  { name: 'Auburn Tigers', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Auburn', state: 'AL'), college: true, twitter_name: 'FootballAU', twitter_widget_id: '356505812375584768'},
  { name: 'Ball State Cardinals', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Muncie', state: 'IN'), college: true, twitter_name: 'BSUCardsFB', twitter_widget_id: '356579237081251840'},
  { name: 'Baylor Bears', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Waco', state: 'TX'), college: true, twitter_name: 'BUFootball', twitter_widget_id: '356498966101241857'},
  { name: 'Boise State Broncos', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Boise', state: 'ID'), college: true, twitter_name: 'BroncoSportsFB', twitter_widget_id: '356582405961814016'},
  { name: 'Boston College Eagles', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Chestnut Hill', state: 'MA'), college: true, twitter_name: 'BCFootballNews', twitter_widget_id: '356495744095641600'},
  { name: 'Bowling Green Falcons', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Bowling Green', state: 'OH'), college: true, twitter_name: 'BGFalconFootbal', twitter_widget_id: '356579476995469313'},
  { name: 'Buffalo Bulls', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Buffalo', state: 'NY'), college: true, twitter_name: 'UBFootball', twitter_widget_id: '356579758223523840'},
  { name: 'BYU Cougars', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Provo', state: 'UT'), college: true, twitter_name: 'BYUFootball', twitter_widget_id: '356850976008835072'},
  { name: 'California Golden Bears', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Berkeley', state: 'CA'), college: true, twitter_name: 'CalFootball', twitter_widget_id: '356503408317964288'},
  { name: 'Central Michigan Chippewas', sport: Sport.find_by_name('NCAA-FOOTBALL'), address: Address.create(city: 'Mt. Pleasant', state: 'MI'), college: true, twitter_name: 'CMUFootball', twitter_widget_id: '356579940021444611'}
])

Venue.create([
  { name: 'Pluckers', description: 'Sports bar & grill offering wings, burgers & more, plus trivia & bingo nights.', address: Address.create(street1: '11066 Pecan Park Blvd', city: 'Cedar Park', state: 'TX', zip: '78613')},
  { name: 'Third Base', description: 'Loud, lively bars with lots of TVs, happy-hour deals & pub grub, including several kinds of wings.', address: Address.create(street1: '3107 S Interstate 35', city: 'Round Rock', state: 'TX', zip: '78664')},
  { name: 'Scholz Garten', description: 'Packed during football games, this famed spot features beer & burgers in a shaded outdoor setting.', address: Address.create(street1: '1607 San Jacinto Blvd', city: 'Austin', state: 'TX', zip: '78701')},
  { name: 'Bikinis Sports Bar & Grill', description: '', address: Address.create(street1: '6901 N I H 35', city: 'Austin', state: 'TX', zip: '78752')}
])

Party.create([
  { name: 'Cowboys watch party', description: 'Go Cowboys!', is_private: false, verified: false, scheduled_for: DateTime.now + 10.days, organizer_id: User.first.id, team_id: Team.find_by_name('Dallas Cowboys').id, venue_id: Venue.find_by_name('Pluckers').id },
  { name: 'FC Dallas SOCCER watch party', description: '', is_private: false, verified: false, scheduled_for: DateTime.now - 1.day, organizer_id: User.first.id, team_id: Team.find_by_name('FC Dallas').id, venue_id: Venue.find_by_name('Third Base').id },
  { name: 'Houston Dynamo SOCCER watch party', description: '', is_private: false, verified: false, scheduled_for: DateTime.now - 1.day, organizer_id: User.first.id, team_id: Team.find_by_name('Houston Dynamo').id, venue_id: Venue.find_by_name('Scholz Garten').id },
  { name: 'Real Salt Lake SOCCER watch party', description: 'Utah takeover!', is_private: false, verified: false, scheduled_for: DateTime.now - 1.day, organizer_id: User.first.id, team_id: Team.find_by_name('Real Salt Lake').id, venue_id: Venue.find_by_name('Bikinis Sports Bar & Grill').id }
])

Package.create([
  { name: "Wings for five cents", description: "Wings for $0.05", price: "5.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Pluckers').id},
  { name: "Beer for some amount of money", description: "BEER!", price: "4.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Pluckers').id},
  { name: "Ten cent wings", description: "Wings for $0.10", price: "5.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Third Base').id},
  { name: "Bucket of beer $8", description: "It's a bucket of beer", price: "8.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Third Base').id},
  { name: "Sliders 4/$3", description: "Sliders", price: "3.0", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Scholz Garten').id},
  { name: "Domestic longnecks $1.50 all night", description: "1.50 domestic longnecks", price: "5.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Scholz Garten').id},
  { name: "Shrimp cocktail", description: "yeah, shrimp cocktail", price: "2.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Bikinis Sports Bar & Grill').id},
  { name: "Pint draft $2.00 all night", description: "Any draft beer $2.00 all night with voucher", price: "5.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Bikinis Sports Bar & Grill').id}
])

Party.find_by_name('FC Dallas SOCCER watch party').update_attribute(:package_ids, [Package.find_by_name("Ten cent wings").id,Package.find_by_name("Bucket of beer $8").id])

u = User.find_by_email('admin@test.com')
u.add_role(:admin)

u = User.find_by_email('team_admin@test.com')
u.add_role(:team_admin, Team.find_by_name('FC Dallas'))

u = User.find_by_email('venue_manager@test.com')
u.add_role(:manager, Venue.find_by_name('Pluckers'))
u.add_role(:manager, Venue.find_by_name('Third Base'))
u.add_role(:manager, Venue.find_by_name('Scholz Garten'))
u.add_role(:manager, Venue.find_by_name('Bikinis Sports Bar & Grill'))

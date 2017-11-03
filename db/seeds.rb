Admin.create(full_name: 'Marek Piechocki', email: 'dom@marek-piechocki.pl', password: ENV['PASSWORD'])

# Włocławek Wschód

congregation = Congregation.new(
    name: 'Włocławek-Wschód',
    has_video_transmission: false,
    has_phone_transmission: true,
    password: '2z0c',
    default_ip: '127.0.0.1',
    default_day: 4,
    default_weekend_time: 10,
)

congregation.build_phone_transmission(
    internal_phone_number: '200',
    sip_phone_number: '544219142'
)

congregation.users.build([
                             {
                                 full_name: 'Sala Góra', admin: true, allow_join_to_any: true,
                                 phone_attributes: {
                                     phone_number: '2000',
                                     phone_key_maps_attributes: [{digit: 1}, {digit: 2}, {digit: 3}, {digit: 4}]
                                 }
                             },
                             {
                                 full_name: 'Marek Piechocki', email: 'dom@marek-piechocki.pl', allow_join_to_any: true,
                                 phone_attributes: {
                                     phone_number: '517100535',
                                     phone_key_maps_attributes: [{digit: 1, full_name: 'Marek Piechocki'}, {digit: 2}, {digit: 3}, {digit: 4}]
                                 }
                             }
                         ])

congregation.build_video_transmission

congregation.save


##########################

# Włocławek Zazamcze

congregation = Congregation.new(
    name: 'Włocławek-Zazamcze',
    has_video_transmission: false,
    has_phone_transmission: true,
    password: '41p5',
    default_ip: '127.0.0.1',
    default_day: 4,
    default_weekend_time: 10,
)

congregation.build_phone_transmission(
    internal_phone_number: '400',
    sip_phone_number: '544219196'
)

congregation.users.build([
                             {full_name: 'Sala Dół', admin: true, allow_join_to_any: true,
                              phone_attributes: {
                                  phone_number: '1000',
                                  phone_key_maps_attributes: [{digit: 1}, {digit: 2}, {digit: 3}, {digit: 4}]
                              }
                             }
                         ])

congregation.build_video_transmission

congregation.save


##########################

# Włocławek Południe

congregation = Congregation.new(
    name: 'Włocławek-Południe',
    has_video_transmission: false,
    has_phone_transmission: true,
    password: '3a8p',
    default_ip: '127.0.0.1',
    default_day: 5,
    default_weekend_time: 16,
)

congregation.build_phone_transmission(
    internal_phone_number: '100',
    sip_phone_number: '544219174'
)

congregation.build_video_transmission

congregation.save
setup() {
  source /etc/profile.d/rvm.sh
}

run_nokogiri_openssl_test() {
  local rubie="$1"
  local https_url="https://google.com"
  local requires="require 'nokogiri';"
  local script="$requires puts Nokogiri::HTML(open('$https_url')).css('input')"

  run rvm $rubie do gem install nokogiri --no-ri --no-rdoc
  [ "$status" -eq 0 ]

  run rvm $rubie do ruby -rrubygems -ropen-uri -e "$script"
  [ "$status" -eq 0 ]
}

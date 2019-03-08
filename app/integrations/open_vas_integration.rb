require 'openvas'
class OpenVasIntegration

  def initialize(organisation_id)
    # TODO: get config for organisation
    @url       = 'https://ec2-3-8-95-88.eu-west-2.compute.amazonaws.com:9390'
    @user      = 'admin'
    @password  = 'admin'
    @scan_name = 'AWS Test'
  end

  def test_data
    openvas_login

    res = ""
    Openvas::Scan.all.each do |scan|
      res+= 'Scan Name : >' + scan.id + "< " + scan.name + "\n"
      res+= '-'*40 + "\n"
      scan.last_results.each do |result|
        res+= "\n\t- " + result.name + " Severity: " + result.severity + "\n" + result.description + "\n"
      end

      res+= "-"*40 + "\n"
    end
    res
  end

  def openvas_login
    Openvas.configure do |config|
      config.url = @url
      config.username = @user
      config.password = @password
    end
    Openvas::Client.connect
    Openvas::Auth.login
  end

  def load_openvas_data
    openvas_login
    scan = find_scan(@scan_name)

    unless scan.blank?
      high_count = 0
      medium_count = 0
      low_count = 0
      scan.last_results.each do |result|
        if result.severity.to_f >= 7.0
          high_count += 1
        elsif result.severity.to_f >= 4.0
          medium_count += 1
        elsif result.severity.to_f >= 0.1
          low_count += 1
        end
      end
      [high_count, medium_count, low_count]
    end
  end

  def find_scan(scan_name)
    Openvas::Scan.all.each do |scan|
      return scan if scan.name == scan_name
    end
  end

end
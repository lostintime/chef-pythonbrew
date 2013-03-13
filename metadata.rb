name             'pythonbrew'
maintainer       'lostintime.dev@gmail.com'
maintainer_email 'lostintime.dev@gmail.com'
license          'All rights reserved'
description      'Installs/Configures pythonbrew'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "pythonbrew", "Installs pythonbrew for configured user"
%w{centos}.each do |os|
  supports os
end

#
# Cookbook Name:: pythonbrew
# Attributes:: default
#
# Copyright (c) 2012 lostintimedev.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


# default pythonbrew user 
default['pythonbrew']['user']               = 'root'
# pythonbrew global setup location
default['pythonbrew']['global_path']		= '/usr/local/pythonbrew'
# path to user's home fodler - %user% will be replaced with user options setup :user option
default['pythonbrew']['HOME']               = '/home/%user%'

# python setups configuration
default['pythonbrew']['setups'] = [
	# {
	# 	:user => "vagrant" # required
	# 	:python_version => "2.7.3" # required for creating virtualenv and/or installing packages
	# 	:python_is_default => true # optional
	# 	:venv => "my_mongod" # optional
	# 	:packages => ["pymongo", {:name => "django", :version => "1.1.4"}] # optional
	# },
	# {
	# 	:user => 'root',
	# 	:venv => 'global_pack',
	# 	:packages => ["django", "mrjob"]
	# }
]

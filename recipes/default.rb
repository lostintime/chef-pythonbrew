#
# Cookbook Name:: pythonbrew
# Recipe:: default
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


node['pythonbrew']['setups'].each do |s|
	raise 'Invalid setup configuration - :user required' if s[:user].nil?

	# intstall pythonbrew
	pythonbrew_setup s[:user] do
		user s[:user]
		group s[:group] unless s[:group].nil?
		action :install
	end

	if s[:python_version]
		if s[:packages].nil? or s[:packages].empty?
			# install python
			pythonbrew_python s[:python_version] do
				action [:install].concat(s[:python_is_default] ? [:switch] : [])
				user s[:user]
				group s[:group] unless s[:group].nil?
				version s[:python_version]
			end

			# create virtualenv
			if s[:venv]
				pythonbrew_venv s[:venv] do
					action :create
					user s[:user]
					group s[:group] unless s[:group].nil?
					python_version s[:python_version]
				end
			end
		end

		# install packages
		if s[:packages].is_a? Array
			s[:packages].each do |p|
				p = {:name => p} if p.is_a? String
				pythonbrew_pip p[:name] do
					action :install
					version p[:version] if p[:version]

					user s[:user]
					group s[:group] unless s[:group].nil?
					python_version s[:python_version]
					venv s[:venv] if s[:venv]
				end

			end
		end
	end
end


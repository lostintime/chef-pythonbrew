#
# Author:: lostintime <lostintime.dev@gmail.com>
# Cookbook Name:: pythonbrew
# Provider:: setup
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
#

include Pythonbrew::Helpers

def whyrun_supported?
  true
end

# the logic in all action methods mirror that of
# the Chef::Provider::Package which will make
# refactoring into core chef easy

action :install do
	# install system tools used to setup pythonbrew
	%w{patch curl sed}.each do |pkg|
		package pkg do
			action :install
		end
	end

	execute "curl -kL http://xrl.us/pythonbrewinstall | bash" do
		user new_resource.user
  		group new_resource.group if new_resource.group		
		command "whoami && curl -kL http://xrl.us/pythonbrewinstall | bash"
		creates (pythonbrew_bin(new_resource.user))
		environment (pythonbrew_env(new_resource.user))
	end	

	# add to bashrc: [[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc
	execute "remove_pythnbrew_bashrc" do
		user new_resource.user
  		group new_resource.group if new_resource.group		
		command "sed -i '/# PYTHONBREW-BEGIN/,/# PYTHONBREW-END>>>/d' $HOME/.bashrc"
		environment (pythonbrew_env(new_resource.user))
		not_if {pythonbrew_is_root(new_resource.user)}
	end

	execute "add_pythonbrew_bashrc" do
		user new_resource.user
  		group new_resource.group if new_resource.group		
		command "echo '# PYTHONBREW-BEGIN\n[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc\n# PYTHONBREW-END' >> $HOME/.bashrc"
		environment (pythonbrew_env(new_resource.user))
		not_if { pythonbrew_is_root(new_resource.user) }
	end

end

action :update do
	execute "#{pythonbrew_cmd(new_resource.user, 'update')}" do
		user new_resource.user
  		group new_resource.group if new_resource.group		
		command pythonbrew_cmd(new_resource.user, 'update')
		environment (pythonbrew_env(new_resource.user))
		only_if { ::File.exists?(pythonbrew_bin(new_resource.user)) }
	end	
end

action :remove do
	execute "remove_pythnbrew_bashrc" do
		user new_resource.user
  		group new_resource.group if new_resource.group		
		command "sed -i '/# PYTHONBREW-BEGIN/,/# PYTHONBREW-END>>>/d' $HOME/.bashrc"
		environment (pythonbrew_env(new_resource.user))
		not_if {pythonbrew_is_root(new_resource.user)}
	end

	directory pythonbrew_path(new_resource.user) do
		action :delete
		recursive true
	end
end

# these methods are the required overrides of
# a provider that extends from Chef::Provider::Package
# so refactoring into core Chef should be easy

def load_current_resource
  @current_resource = Chef::Resource::PythonbrewSetup.new(new_resource.name)
  @current_resource.user(new_resource.user)
  @current_resource.group(new_resource.group)
  @current_resource
end


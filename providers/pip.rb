#
# Author:: lostintime <lostintime.dev@gmail.com>
# Cookbook Name:: pythonbrew
# Provider:: pip
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
	pythonbrew_pip_setup(new_resource)

	_cmd = pythonbrew_pip_cmd("install \"#{new_resource.name}\"", new_resource.user, new_resource.python_version, new_resource.venv)
	execute _cmd do
		user new_resource.user
  		group new_resource.group if new_resource.group		
		command _cmd
		environment (pythonbrew_env(new_resource.user))
	end	
end

action :uninstall do
	pythonbrew_pip_setup(new_resource)

	_cmd = pythonbrew_pip_cmd("uninstall \"#{new_resource.name}\"", new_resource.user, new_resource.python_version, new_resource.venv)
	execute _cmd do
		user new_resource.user
  		group new_resource.group if new_resource.group		
		command _cmd
		environment (pythonbrew_env(new_resource.user))
	end		
end


def pythonbrew_pip_setup(new_resource)
	if new_resource.venv
		pythonbrew_venv new_resource.venv do
			action :create
			user new_resource.user
			group new_resource.group if new_resource.group
			python_version new_resource.python_version if new_resource.python_version
		end
		_env_cmd = pythonbrew_venv_cmd(new_resource.user, "use \'#{new_resource.venv}\'")
	else
		pythonbrew_python new_resource.python_version do
			action :install
			user new_resource.user
			group new_resource.group if new_resource.group
			version new_resource.python_version if new_resource.python_version
		end
		_env_cmd = pythonbrew_cmd(new_resource.user, "use \'#{new_resource.python_version}\'")
	end
end


# these methods are the required overrides of
# a provider that extends from Chef::Provider::Package
# so refactoring into core Chef should be easy

def load_current_resource
  @current_resource = Chef::Resource::PythonbrewPip.new(new_resource.name)
  @current_resource.version(new_resource.version)
  @current_resource.user(new_resource.user)
  @current_resource.group(new_resource.group)
  @current_resource.python_version(new_resource.python_version)
  @current_resource.venv(new_resource.venv)
  @current_resource
end



pythonbrew Cookbook
===================
Installs pythonbrew for specified user

Requirements
------------


Attributes
----------
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['pythonbrew']['user']</tt></td>
    <td>String</td>
    <td>System user to install pythonbrew for. If is set to "root" (default) - will install system-wide.</td>
    <td><tt>root</tt></td>
  </tr>
  <tr>
    <td><tt>['pythonbrew']['HOME']</tt></td>
    <td>String</td>
    <td>User home path. For "root" user - "/root" path is hardcoded.</td>
    <td><tt>/home/%user%</tt></td>
  </tr>
</table>

Usage
-----
Just include `pythonbrew` in your node's `run_list`:

	{
	  "name":"my_node",
	  "run_list": [
	    "recipe[pythonbrew]"
	  ]
	}

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: <lostintime.dev@gmail.com>

Licensed under MIT license

	http://opensource.org/licenses/MIT

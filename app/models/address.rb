# ## Schema Information
#
# Table name: `addresses`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`account`**      | `string(255)`      |
# **`accountance`**  | `string(255)`      |
# **`bank`**         | `string(255)`      |
# **`birthday`**     | `datetime`         |
# **`blz`**          | `string(255)`      |
# **`city`**         | `string(255)`      |
# **`company_id`**   | `integer`          |
# **`country`**      | `string(255)`      |
# **`fax`**          | `string(255)`      |
# **`fon`**          | `string(255)`      |
# **`free1`**        | `string(255)`      |
# **`free2`**        | `string(255)`      |
# **`id`**           | `integer`          | `not null, primary key`
# **`is_tax`**       | `boolean`          |
# **`mail`**         | `string(255)`      |
# **`min_rebate`**   | `integer`          |
# **`name`**         | `string(255)`      |
# **`name2`**        | `string(255)`      |
# **`short_name`**   | `string(255)`      |
# **`str`**          | `string(255)`      |
# **`str2`**         | `string(255)`      |
# **`tax_no`**       | `string(255)`      |
# **`web`**          | `string(255)`      |
# **`zip`**          | `string(255)`      |
#
# ### Indexes
#
# * `index_address_on_company_id`:
#     * **`company_id`**
#
# ### Foreign Keys
#
# * `fk_rails_6c91bab87f`:
#     * **`company_id => companies.id`**
#

class Address < ActiveRecord::Base
  belongs_to :company

end

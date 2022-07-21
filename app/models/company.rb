# ## Schema Information
#
# Table name: `companies`
#
# ### Columns
#
# Name                               | Type               | Attributes
# ---------------------------------- | ------------------ | ---------------------------
# **`account`**                      | `string(255)`      |
# **`bank`**                         | `string(255)`      |
# **`blz`**                          | `string(255)`      |
# **`ceo`**                          | `string(255)`      |
# **`city`**                         | `string(255)`      |
# **`fax`**                          | `string(255)`      |
# **`fon`**                          | `string(255)`      |
# **`free1`**                        | `string(255)`      |
# **`free2`**                        | `string(255)`      |
# **`id`**                           | `integer`          | `not null, primary key`
# **`invoice_number`**               | `integer`          |
# **`is_tax`**                       | `boolean`          |
# **`layout`**                       | `integer`          |
# **`mail`**                         | `string(255)`      |
# **`name`**                         | `string(255)`      |
# **`name2`**                        | `string(255)`      |
# **`picture_bottom_content_type`**  | `string(255)`      |
# **`picture_bottom_file_name`**     | `string(255)`      |
# **`picture_bottom_file_size`**     | `integer`          |
# **`picture_bottom_updated_at`**    | `datetime`         |
# **`picture_top_content_type`**     | `string(255)`      |
# **`picture_top_file_name`**        | `string(255)`      |
# **`picture_top_file_size`**        | `integer`          |
# **`picture_top_updated_at`**       | `datetime`         |
# **`register`**                     | `string(255)`      |
# **`str`**                          | `string(255)`      |
# **`str2`**                         | `string(255)`      |
# **`tax_no`**                       | `string(255)`      |
# **`title`**                        | `string(255)`      |
# **`warranty_number`**              | `integer`          |
# **`web`**                          | `string(255)`      |
# **`zip`**                          | `string(255)`      |
#

class Company < ActiveRecord::Base

  # einbinden mit: where(:company_id => Company::company_list(1) )
  def self.company_list( company_id )
    if company_id==1 || company_id==2
      [1,2]
    else
      [company_id]
    end
  end

  module LAYOUT
    WET = 1
    STD = 2
  end

  has_many :addresses
  has_many :rechnung


end

# ## Schema Information
#
# Table name: `invoice_details`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`count`**       | `integer`          |
# **`end_price`**   | `decimal(8, 2)`    |
# **`id`**          | `integer`          | `not null, primary key`
# **`invoice_id`**  | `integer`          |
# **`is_chip`**     | `boolean`          |
# **`pos`**         | `integer`          |
# **`price`**       | `decimal(8, 2)`    |
# **`rebate1`**     | `integer`          |
# **`rebate2`**     | `integer`          |
# **`reference`**   | `string(255)`      |
# **`text`**        | `string(255)`      |
# **`unit`**        | `string(255)`      |
#
# ### Indexes
#
# * `index_invoice_details_on_invoice_id`:
#     * **`invoice_id`**
#
# ### Foreign Keys
#
# * `fk_rails_e5cda32dbb`:
#     * **`invoice_id => invoices.id`**
#

class InvoiceDetail < ActiveRecord::Base
  belongs_to :rechnung

end

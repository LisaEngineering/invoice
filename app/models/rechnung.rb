class Rechnung < ActiveRecord::Base

    belongs_to :address
    belongs_to :company
    has_many   :invoice_details

end

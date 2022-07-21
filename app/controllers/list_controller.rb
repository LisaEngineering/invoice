class ListController < ApplicationController
    #require "net/https"
    #require "uri"
    require "base64"
  
    #before_action :authenticate_administrator!
    def invoice
        print_letter=true
        if params['no']=="no" || params['no']=='no_letter' || params['no']=='no_agb'
          print_letter=false
        end

        @invoice=Invoicepresenter.new(params['id'].to_i)

        pdf = Prawn::Document.new( :page_size => "A4", :page_layout => :portrait)
        if print_letter
            Invoiceforms.print_letter(pdf, @invoice.data.company,true)
        end
        Invoicepdf.invoice pdf, @invoice
        if params['no']!='no_agb'
            Invoiceforms.print_wet_agb pdf, @invoice.data.company,print_letter
        end
        send_data pdf.render, filename: @invoice.filename, :disposition => 'inline', type: 'application/pdf'
    end
    
end
class Invoicepresenter

  MWST=19

  module Payment
    CASH    = 1
    EC_CARD = 2
    CREDIT  = 3
    INVOICE = 4
  end

  module Types
    INVOICE   = 1
    OFFER     = 2
    DELIVER   = 3
    STORNO    = 4
    CONFIRM   = 5
  end

  class_attribute :filename
  class_attribute :data
  class_attribute :date
  class_attribute :deliver

  class_attribute :type_name
  class_attribute :payment
  class_attribute :disclaimer
  class_attribute :sum_net
  class_attribute :sum_brutto

  def initialize( id )
    @data=Rechnung.where( number: id ).first
    @sum_net     = 0
    @sum_brutto  = 0
    @price1      = 0
    @price2      = 0
    @price3      = 0

    @data.invoice_date||=Time.now
    @date=@data.invoice_date.strftime("%d.%m.%Y")
    @filename = 'invoice_'+@data.number.to_s+'_'+@date+'.pdf'
    @data.deliver||=Time.now
    @deliver=@data.deliver.strftime("%d.%m.%Y")

    @data.invoice_type = (( @data.invoice_type==nil)? 1 : @data.invoice_type )
    @type_name=I18n.t('invoice.type'+@data.invoice_type.to_s)

    @payment = ""
    @data.payment_days=((@data.payment_days.blank?)? 10: @data.payment_days)

    case @data.payment
      when Payment::EC_CARD
        @payment=I18n.t( 'invoice.payment2')
      when Payment::CREDIT
        @payment=I18n.t( 'invoice.payment3')
      when Payment::INVOICE
        if @data.payment_days==0
          @payment='Zahlbar bis '+(Time.now.strftime("%d.%m.%Y"))
        else
          @payment=I18n.t( 'invoice.payment4p1')+
              @data.payment_days.to_s+
              I18n.t( 'invoice.payment4p2')+
              (Time.now+(@data.payment_days*24*3600)).strftime("%d.%m.%Y")
        end
      else
        @payment=I18n.t('invoice.payment1')   #default barzahlung
    end


    @disclaimer = I18n.t("invoice.disclaimer_"+@data.invoice_type.to_s+((@data.company_id<3)? "_wet":"_ips") )
    @data.remark=((@data.remark.blank?)? "":"\n"+@data.remark)
    @disclaimer+= @data.remark

  end

  def details_row( detail )

    unit=( (detail.unit.blank?)? "Stück": detail.unit )

    # Address |  Company  | result =>
    # 1 1 ja
    # 1 0 nein
    # 0 1 nein
    # 0 0 nein
    if @data.address.is_tax and @data.company.is_tax
      @price1 = detail.price.to_f
    else
      #wenn Ausländer, dann nur netto rechnen
      @price1 = (detail.price.to_f/((100+MWST.to_f)/100))
    end

    @price2 = @price1.to_f*((100-detail.rebate1.to_f)/100)
    @price_single = @price2.to_f*((100-detail.rebate2.to_f)/100)
    @price3= @price_single*(detail.count||1)
    @sum_brutto+=@price3

    [detail.pos.to_s,
      detail.count.to_s,
      unit,
      detail.text,
      "%5.2f" % @price1,
      detail.rebate1.to_s,
      "%5.2f" % @price2,
      detail.rebate2.to_s,
      "%5.2f" % @price3,
    ]
  end

  def details_second_row( detail )

    @price1 = (@price1/((100+MWST.to_f)/100))
    @price2 = (@price2/((100+MWST.to_f)/100))
    @price3 = (@price3/((100+MWST.to_f)/100))
    @price_single = (@price_single/((100+MWST.to_f)/100))
    @sum_net+=@price3

    if( detail.end_price.blank?) || (detail.end_price==0)        # ab in die Datenbank
      detail.end_price=@price_single
      detail.save
    end

    if @data.address.is_tax && @data.company.is_tax
      [ "",
        "",
        "",
        "",
        "%5.2f" % @price1,
        "",
        "%5.2f" % @price2,
        "",
        "%5.2f" % @price3
      ]
    else
      nil
    end
  end

  def details_reference( details )
      [ "",
      "",
      "Ref.:",
      details.reference,
      "",
      "",
      "",
      "",
      ""
      ]
  end

  def sum(row)

    if !(@data.address.is_tax && @data.company.is_tax) && row!=3
      nil
    else
      case row
        when 1
          text=I18n.t( "invoice.totalnet")
          sum= "%5.2f" % @sum_net
        when 2
          text=I18n.t('invoice.excltax')
          text=I18n.t( "invoice.excltax")+MWST.to_s+" %"
          sum= "%5.2f" % (@sum_brutto-@sum_net)
        when 3
          text=I18n.t( "invoice.total")
          sum= "%5.2f" % @sum_brutto
      end

      if( @data.sum.blank?) || (@data.sum==0 )
        @data.sum = @sum_brutto
        @data.save
      end

      ["","","",
        text,
        "","","","",
        sum
      ]
    end
  end

  def zwischen_summe

    if @data.address.is_tax || !@data.company.is_tax
      text=I18n.t('invoice.subtotal_brutto')
      sum= "%5.2f" % @sum_brutto
    else
      text=I18n.t('invoice.subtotal_net')
      sum= "%5.2f" % @sum_net
    end

    ["","","",
     text,
     "","","","",
     sum
    ]
  end

end


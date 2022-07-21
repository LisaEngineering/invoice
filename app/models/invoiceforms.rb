class Invoiceforms

  require "prawn/measurement_extensions"

  DEVELOPEMENT        = false

  PAGE_LEFT           = 0
  PAGE_RIGHT          = 192.mm
  PAGE_TOP            = 255.mm
  PAGE_BOTTOM         = 0
  PAGE_WIDTH          = PAGE_RIGHT-PAGE_LEFT

  CPAGE_LEFT=0
  CPAGE_RIGHT=612
  CPAGE_TOP=792
  CPAGE_BOTTOM=0
  CPAGE_WIDTH=CPAGE_RIGHT-CPAGE_LEFT

  LOGO_X              = 380
  LOGO_Y              = 772
  LOGO_IPS_X          = 352
  LOGO_IPS_Y          = 772

  LOGO_WIDTH          = 159
  LOGO_HEIGHT         = 50

  LOGO_BOTTOM_X       = 425
  LOGO_BOTTOM_Y       = 60
  LOGO_BOTTOM_IPS_WIDTH = 10.mm
  LOGO_BOTTOM_IPS_X   = 13.mm
  LOGO_BOTTOM_IPS_Y   = 12.mm

  ADDRESS_BOX_X       = PAGE_LEFT + 12.mm
  ADDRESS_BOX_Y       = PAGE_TOP  - 21.mm
  ADDRESS_BOX_WIDTH   = 90.mm
  ADDRESS_BOX_HEIGHT  = 45.mm

  ADDRESS_FONT_COMPANY= 7

  LOWER_BLOCK_WIDTH   = 40.mm
  LOWER_BLOCK_HEIGHT  = 65.mm
  LOWER_BLOCK_X       = CPAGE_WIDTH - LOWER_BLOCK_WIDTH - 9.mm
  LOWER_BLOCK_Y       = CPAGE_BOTTOM  + LOWER_BLOCK_HEIGHT+ 18.mm
  LOWER_BLOCK_FONT    = 6

  LOWER123_BLOCK_FONT = 8

  LOWER_BLOCK1_WIDTH   = 110
  LOWER_BLOCK2_WIDTH   =  90
  LOWER_BLOCK3_WIDTH   = 130
  LOWER_BLOCK4_WIDTH   = 130

  LOWER_BLOCK1_HEIGHT  = 15.mm
  LOWER_BLOCK2_HEIGHT  = LOWER_BLOCK1_HEIGHT
  LOWER_BLOCK3_HEIGHT  = LOWER_BLOCK1_HEIGHT
  LOWER_BLOCK4_HEIGHT  = LOWER_BLOCK1_HEIGHT

  LOWER_BLOCK_MARGIN   = 7.mm

  LOWER_BLOCK1_X       = 0
  LOWER_BLOCK2_X       = LOWER_BLOCK1_WIDTH+LOWER_BLOCK_MARGIN
  LOWER_BLOCK3_X       = LOWER_BLOCK2_X+LOWER_BLOCK2_WIDTH+LOWER_BLOCK_MARGIN
  LOWER_BLOCK4_X       = LOWER_BLOCK3_X+LOWER_BLOCK4_WIDTH+LOWER_BLOCK_MARGIN

  LOWER_BLOCK1_Y       = LOWER_BLOCK1_HEIGHT
  LOWER_BLOCK2_Y       = LOWER_BLOCK1_HEIGHT
  LOWER_BLOCK3_Y       = LOWER_BLOCK1_HEIGHT
  LOWER_BLOCK4_Y       = LOWER_BLOCK1_HEIGHT


  FONT_AGB_HEAD       = 6
  FONT_AGB_TEXT       = 5.0

  IPS_ACCOUNT         = "LI05 0880 0546 1250 3200 1"
  IPS_BLZ             = "LILALI2XXXX"

  # Garantie Bogen

  GARA_MARGIN = 10
  GARA_BOX1_X = 265
  GARA_BOX1_Y = 250
  GARA_BOX2_X = 265
  GARA_BOX2_Y = GARA_BOX1_Y
  GARA1_X=20
  GARA1_Y=20
  GARA2_X=GARA_BOX1_X+20+GARA1_X
  GARA2_Y=GARA1_Y

  GARA_MARGIN_SPALTE=50
  SPALTE_WIDTH = 170
  SPALTE_HEIGTH = 25
  GARA_SPALTE_TEXT_X = GARA_MARGIN
  GARA_SPALTE_TEXT_Y = 43
  GARA_SPALTE_INHALT_X = GARA_MARGIN
  GARA_SPALTE_INHALT_Y = 31

  GARA_SPALTE1 = 0
  GARA_SPALTE2 = GARA_SPALTE1+GARA_MARGIN+SPALTE_WIDTH
  GARA_SPALTE3 = GARA_SPALTE2+GARA_MARGIN+SPALTE_WIDTH

  GARA_ZEILE1 = 650
  GARA_ZEILE2 = GARA_ZEILE1-GARA_MARGIN_SPALTE
  GARA_ZEILE3 = GARA_ZEILE2-GARA_MARGIN_SPALTE
  GARA_ZEILE4 = GARA_ZEILE3-GARA_MARGIN_SPALTE

  FONT_GARA_HEAD = 23
  FONT_GARA_TEXT = 7
  FONT_PREMIUM_HEAD = 9
  FONT_PREMIUM_TEXT = 5.45
  FONT_TUNING_HEAD = 9
  FONT_TUNING_TEXT = 5.6
  FONT_SPALTE_TEXT = 6
  FONT_SPALTE_INHALT = 12



  def self.setup_wet_warranty(pdf )
  end


  def self.print_letter(pdf, company=nil, is_first_page=true )

    if company!= nil && company.layout== Company::LAYOUT::WET
      PInvoiceforms.print_wet_letter(pdf, company,is_first_page)
    end
    if company!= nil && company.layout== Company::LAYOUT::STD
      Invoiceforms.print_std_letter(pdf, company,is_first_page)
    end
  end

  def self.print_wet_letter(pdf, company=nil, is_first_page=true )

    # Hilfslinien
    if( DEVELOPEMENT )
      pdf.stroke_axis

      pdf.canvas do
          pdf.stroke_circle [pdf.bounds.left, pdf.bounds.top],     30
          pdf.stroke_circle [pdf.bounds.right, pdf.bounds.top],    30
          pdf.stroke_circle [pdf.bounds.right, pdf.bounds.bottom], 30
          pdf.stroke_circle [0, 0],                                30
      end
    end

     self.top_wet_logo(pdf)

    # Fensterumschlag
    if( is_first_page )
      self.address_win_info(pdf,company)
      self.company_wet(pdf,company)
    end

    self.bottom_logo(pdf)

  end

  def self.print_std_letter(pdf, company=nil, is_first_page=true )

    # Hilfslinien
    if( DEVELOPEMENT )
      pdf.stroke_axis

      pdf.canvas do
        pdf.stroke_circle [pdf.bounds.left, pdf.bounds.top],     30
        pdf.stroke_circle [pdf.bounds.right, pdf.bounds.top],    30
        pdf.stroke_circle [pdf.bounds.right, pdf.bounds.bottom], 30
        pdf.stroke_circle [0, 0],                                30
      end
    end

    if( company.id == 3)
      pdf.image "#{Rails.root}/public/logos/logo.png", width: LOGO_WIDTH, :at => [LOGO_IPS_X,LOGO_IPS_Y]
    end
    if( company.id == 9)
      pdf.image "#{Rails.root}/public/logos/helios_flieger_logo.jpg", width: LOGO_WIDTH, :at => [LOGO_IPS_X,LOGO_IPS_Y]
    end

    # Fensterumschlag
    if( is_first_page )
      self.address_win_info(pdf,company)
      self.company_std(pdf,company)
    end

    self.bottom_logo_ips(pdf,company)

  end


  def self.top_wet_logo(pdf)
    pdf.font_size 9
    pdf.image "#{Rails.root}/app/assets/images/logopic1.png", width: LOGO_WIDTH, height: LOGO_HEIGHT, :at => [LOGO_X,LOGO_Y]
    pdf.draw_text "DIGITAL PERFORMANCE", :at => [LOGO_X+15,LOGO_Y-38], :style => :bold_italic
    pdf.font_size 12
    pdf.draw_text "®", :at => [LOGO_X+152,LOGO_Y-9], :style => :bold_italic
  end

  # Fensterumschlag
  def self.address_win_info(pdf,company)
    companyline=[company.name,company.str,company.zip+" "+company.city].map(&:presence).compact.join('  |  ')
    pdf.bounding_box([ADDRESS_BOX_X, ADDRESS_BOX_Y], :width => ADDRESS_BOX_WIDTH, :height => ADDRESS_BOX_HEIGHT) do
      if( DEVELOPEMENT )
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end

      pdf.font_size ADDRESS_FONT_COMPANY
      pdf.text companyline, :leading => 0
    end
  end

  # Firmendaten
  def self.company_wet(pdf,company)

    pdf.canvas do
      pdf.bounding_box([LOWER_BLOCK_X, LOWER_BLOCK_Y], :width => LOWER_BLOCK_WIDTH, :height => LOWER_BLOCK_HEIGHT) do
        if( DEVELOPEMENT )
          pdf.transparent(0.5) { pdf.stroke_bounds }
        end
        pdf.transparent(0.7){
        pdf.font_size LOWER_BLOCK_FONT
        pdf.text "<b>"+company.name+"</b>", :align => :right, :inline_format => true unless company.name.blank?
        pdf.text "<b>"+company.name2+"</b>", :align => :right, :inline_format => true unless company.name2.blank?
        pdf.text company.str, :align => :right unless company.str.blank?
        pdf.text company.str2, :align => :right unless company.str2.blank?
        pdf.text company.zip+" "+company.city, :align => :right unless company.zip.blank?
        pdf.text " "
        pdf.text "<b>Tel:</b> "+company.fon, :align => :right, :inline_format => true unless company.fon.blank?
        pdf.text "<b>Fax:</b> "+company.fax, :align => :right, :inline_format => true unless company.fax.blank?
        pdf.text company.mail, :align => :right unless company.mail.blank?
        pdf.text company.web, :align => :right unless company.web.blank?
        pdf.text " "
        pdf.text "<b></b>", :align => :right, :inline_format => true
        pdf.text "<b>"+company.bank+"</b>", :align => :right, :inline_format => true unless company.bank.blank?
        pdf.text "<b>IBAN:</b> "+company.account, :align => :right, :inline_format => true unless company.account.blank?
        pdf.text "<b>BIC:</b> "+company.blz, :align => :right, :inline_format => true unless company.blz.blank?
        pdf.text " "
        pdf.text "<b>HR:</b> "+company.register, :align => :right, :inline_format => true unless company.register.blank?
        pdf.text " "
        pdf.text "UST-IDNR: "+company.tax_no, :align => :right, :inline_format => true unless company.tax_no.blank?
        pdf.text " "
        pdf.text company.title, :align => :right unless company.title.blank?
        pdf.text company.ceo, :align => :right unless company.ceo.blank?
      }
      end
    end
  end

  def self.company_std(pdf,company)

    pdf.bounding_box([LOWER_BLOCK1_X, LOWER_BLOCK1_Y], :width => LOWER_BLOCK1_WIDTH, :height => LOWER_BLOCK1_HEIGHT) do
      if( DEVELOPEMENT )
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end
      pdf.transparent(0.7){
        pdf.font_size LOWER123_BLOCK_FONT
        pdf.text "<b>"+company.name+"</b>", :align => :left, :inline_format => true unless company.name.blank?
        pdf.text "<b>"+company.name2+"</b>", :align => :left, :inline_format => true unless company.name2.blank?
        pdf.text company.str, :align => :left unless company.str.blank?
        pdf.text company.str2, :align => :left unless company.str2.blank?
        pdf.text company.zip+" "+company.city, :align => :left unless company.zip.blank?
        pdf.text "<b>"+company.title+":</b> "+company.ceo, :align => :left, :inline_format => true unless company.register.blank?
      }
    end
    pdf.bounding_box([LOWER_BLOCK2_X, LOWER_BLOCK2_Y], :width => LOWER_BLOCK2_WIDTH, :height => LOWER_BLOCK2_HEIGHT) do

      if( DEVELOPEMENT )
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end
      pdf.transparent(0.7){
        pdf.text "<b>Tel:</b> "+company.fon, :align => :left, :inline_format => true unless company.fon.blank?
        pdf.text "<b>Fax:</b> "+company.fax, :align => :left, :inline_format => true unless company.fax.blank?
        pdf.text company.mail, :align => :left unless company.mail.blank?
        pdf.text company.web, :align => :left unless company.web.blank?
        pdf.text "<b>HR:</b> "+company.register, :align => :left, :inline_format => true unless company.register.blank?
      }
    end


    pdf.bounding_box([LOWER_BLOCK3_X, LOWER_BLOCK3_Y], :width => LOWER_BLOCK3_WIDTH, :height => LOWER_BLOCK3_HEIGHT) do

      if( DEVELOPEMENT )
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end
      pdf.transparent(0.7){
        pdf.text "<b>Liechtensteinische Landesbank</b>", :align => :left, :inline_format => true
        pdf.text "<b>IBAN:</b> ", :align => :left, :inline_format => true
        pdf.text "<b>BIC:</b> ", :align => :left, :inline_format => true
      }
    end

    pdf.bounding_box([LOWER_BLOCK3_X, LOWER_BLOCK3_Y], :width => LOWER_BLOCK3_WIDTH, :height => LOWER_BLOCK3_HEIGHT) do

      if( DEVELOPEMENT )
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end
      pdf.transparent(0.7){
        pdf.text " ", :align => :right, :inline_format => true
        pdf.text IPS_ACCOUNT, :align => :right, :inline_format => true
        pdf.text IPS_BLZ, :align => :right, :inline_format => true
      }
    end

    pdf.bounding_box([LOWER_BLOCK4_X, LOWER_BLOCK4_Y], :width => LOWER_BLOCK4_WIDTH, :height => LOWER_BLOCK4_HEIGHT) do

      if( DEVELOPEMENT )
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end
      pdf.transparent(0.7){
        pdf.text "<b>"+company.bank+"</b>", :align => :left, :inline_format => true unless company.bank.blank?
        pdf.text "<b>IBAN:</b> ", :align => :left, :inline_format => true unless company.account.blank?
        pdf.text "<b>BIC:</b> ", :align => :left, :inline_format => true unless company.blz.blank?
        pdf.text " "
        pdf.text "UST-IDNR: ", :align => :left, :inline_format => true unless company.tax_no.blank?
      }
    end

    pdf.bounding_box([LOWER_BLOCK4_X, LOWER_BLOCK4_Y], :width => LOWER_BLOCK4_WIDTH, :height => LOWER_BLOCK4_HEIGHT) do

      if( DEVELOPEMENT )
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end
      pdf.transparent(0.7){
        pdf.text " ", :align => :right, :inline_format => true unless company.bank.blank?
        pdf.text company.account, :align => :right, :inline_format => true unless company.account.blank?
        pdf.text company.blz, :align => :right, :inline_format => true unless company.blz.blank?
        pdf.text " "
        pdf.text company.tax_no, :align => :right, :inline_format => true unless company.tax_no.blank?
      }
    end

  end


  def self.bottom_logo(pdf)
    pdf.canvas do
        # Briefkopf
        pdf.fill_polygon [0,0],[0,44],[pdf.bounds.right,79],[pdf.bounds.right,0]

        pdf.fill_color 'ff0000'
        pdf.stroke_color 'ff0000'
        pdf.fill_ellipse [28,24], 12        #rote bubbles
        pdf.fill_ellipse [66,24], 12
        pdf.fill_ellipse [104,24], 12

        pdf.fill_color 'eeeeee'             #logos
        pdf.font_size 16
        pdf.font "Helvetica", :style => :bold
        pdf.draw_text "f" ,  :at => [25,19]

        pdf.fill_color '333333'
        pdf.rectangle [125, 36], 99, 24     #graue box 50 * Tuningpoints
        pdf.fill
                                        # Performance Center
        pdf.fill_color 'eeeeee'
        pdf.font_size 16
        pdf.font "Helvetica", :style => :bold_italic
        pdf.draw_text "50x" ,  :at => [126,22]
        pdf.font "Helvetica"
        pdf.font_size 9.45
        pdf.draw_text "WETTERAUER" ,  :at => [155,27], :style => :bold
        pdf.font_size 5.4
        pdf.draw_text "PERFORMANCE CENTER" ,  :at => [155,22], :style => :bold
        pdf.font_size 7.6
        pdf.draw_text "Deutschland & International" ,  :at => [127,14]

        pdf.fill_color '000000'
        pdf.stroke_color '000000'

        pdf.image "#{Rails.root}/app/assets/images/twitter.png", width: 12, height: 10, :at => [61,29]
        pdf.image "#{Rails.root}/app/assets/images/youtube.png", width: 14, height: 16, :at => [97,33]
        pdf.font_size 9
        pdf.image "#{Rails.root}/app/assets/images/logohead1.png", width: LOGO_WIDTH, height: LOGO_HEIGHT, :at => [LOGO_BOTTOM_X,LOGO_BOTTOM_Y]

    end
  end

  def self.bottom_logo_ips(pdf, company )
    pdf.canvas do
      # Briefkopf
      if( company.id==9)
        pdf.fill_color '907010'
      else
        pdf.fill_color 'aaaaaa'
      end
      pdf.fill_polygon [0,0],[0,40],[pdf.bounds.right,10],[pdf.bounds.right,0]

      if( company.id==4)
        pic_width=LOGO_BOTTOM_IPS_WIDTH*4
        logo_bottom_x=0
        logo_bottom_y=LOGO_BOTTOM_IPS_Y-3.mm
      else
        pic_width=LOGO_BOTTOM_IPS_WIDTH
        logo_bottom_x=LOGO_BOTTOM_IPS_X
        logo_bottom_y=LOGO_BOTTOM_IPS_Y
      end
      if( company.id == 3)
         pdf.image "#{Rails.root}/public/logos/logo_kreis.png", width: pic_width, :at => [logo_bottom_x,logo_bottom_y]
      end

      pdf.fill_color '000000'
    end
  end

  def self.print_wet_agb pdf, company, print_letter=true

    pdf.start_new_page( :size => "A4", :layout => :portrait)
    if print_letter
      print_letter pdf, company, false
    end
    heigth =pdf.bounds.top-115
    pdf.bounding_box([0,pdf.bounds.top-60], :width => pdf.bounds.width, :height => heigth) do
      if( DEVELOPEMENT )
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end
      pdf.column_box([0,heigth], :columns => 2, :width =>  pdf.bounds.width, :height => heigth) do
        pdf.font_size FONT_AGB_HEAD
        pdf.font "Helvetica", :style => :bold
        pdf.text I18n.t( 'invoice.AGB.head').gsub( "%name" , company.name)
        pdf.font "Helvetica", :style => :normal
        pdf.text " "

        element_no=1
        while element_no<18
          pdf.text I18n.t( 'invoice.AGB.part%d_head' % element_no).gsub( "%name" , company.name).gsub( "%str" , company.str).gsub( "%ort" , company.city)
          pdf.font_size FONT_AGB_TEXT
          pdf.text I18n.t( 'invoice.AGB.part%d' % element_no).gsub( "%name" , company.name).gsub( "%str" , company.str).gsub( "%ort" , company.city), :align => :justify
          pdf.font_size FONT_AGB_HEAD
          pdf.text " "
          element_no+=1
        end
      end
    end
  end



  def self.replace_var str,garantie,schadenssumme=""
    linefeed="\n"
    str.gsub( '%lf' , "#{linefeed}")
        .gsub( "%name" , "garantie.company.name")
        .gsub( "%str" , garantie.company.str)
        .gsub( "%ort" , garantie.company.city)
        .gsub( "%schadenssumme" , schadenssumme.to_s)
  end

  def self.print_garantie pdf, garantie
    self.print_garantie_page_1 pdf, garantie
    pdf.start_new_page( :size => "A4", :layout => :portrait)
    self.print_garantie_page_2 pdf, garantie
  end

  def self.print_garantie_page_1 pdf, garantie

    if garantie.warranty_type == Garanty::Types::PREMIUM
      is_premium=true
      schadenssumme='15.000'
      width_gara=370
      garantie_name='    Wetterauer Premium Garantie '+garantie.warranty_years.to_s
    else
      is_premium=false
      schadenssumme='10.000'
      width_gara=350
      garantie_name='    Wetterauer Tuning Garantie '+garantie.warranty_years.to_s
      if garantie.warranty_type == Garanty::Types::TUNING_MOBILE
      else
      end
    end

    pdf.canvas do
      pdf.image "#{Rails.root}/public/datasheet_pic_0.jpg",
                width: pdf.bounds.right-pdf.bounds.left,
                :at => [pdf.bounds.left, 460]
    end

    self.bottom_logo(pdf)

    pdf.canvas do
      pdf.transparent(0.3) do
        pdf.image "#{Rails.root}/public/weltkarte.png",
                  width: pdf.bounds.right-pdf.bounds.left,
                  :at => [pdf.bounds.left, pdf.bounds.top]
      end
    end

    linefeed="\n"

    # Name
    garantie_details  pdf,GARA_SPALTE1,   GARA_ZEILE1, 'Name:' ,              garantie.address.name
    # str.Ort
    garantie_details  pdf,GARA_SPALTE2,   GARA_ZEILE1, 'Adresse:' ,           [garantie.address.str+linefeed,garantie.address.zip,garantie.address.city].join( ' ' )
    # Garantie Nummer
    garantie_details  pdf,GARA_SPALTE3,   GARA_ZEILE1, 'Garantienummer:' ,    garantie.warranty_number.to_s

    # Einbaudatum
    garantie_details  pdf,GARA_SPALTE1,   GARA_ZEILE2, 'Einbaudatum:' ,       garantie.installation_date.strftime("%d.%m.%y")
    # Garantie endet am
    garantie_details  pdf,GARA_SPALTE2,   GARA_ZEILE2, 'Garantie endet am:',  garantie.end_date.strftime("%d.%m.%y")
    # oder Laufleistung
    garantie_details  pdf,GARA_SPALTE3,   GARA_ZEILE2, 'Laufleistung: (endet nach maximal km)',       garantie.kilometer_valid

    # Fahrzeug
    garantie_details  pdf,GARA_SPALTE1,   GARA_ZEILE3, 'Fahrzeug:'    ,       garantie.car_type
    # KZ
    garantie_details  pdf,GARA_SPALTE2,   GARA_ZEILE3, 'Kennzeichen:' ,       garantie.car_plate
    # VIN
    garantie_details  pdf,GARA_SPALTE3,   GARA_ZEILE3, 'VIN:' ,               garantie.car_vin

    # EZ
    garantie_details  pdf,GARA_SPALTE1,   GARA_ZEILE4, 'Erstzulassung:' ,     garantie.car_register_date.strftime("%d.%m.%y")
    # KM
    garantie_details  pdf,GARA_SPALTE2,   GARA_ZEILE4, 'Kilometer b. Einbau:',garantie.car_kilometer
    # Leistung x auf y
    garantie_details  pdf,GARA_SPALTE3,   GARA_ZEILE4, 'Leistung:' ,          garantie.car_power

    # Garantie Typ
    # Daten

    pdf.canvas do
        pdf.rotate(3, :origin => [GARA_SPALTE1,GARA_ZEILE1+70]) do
        self.shade_box pdf, '    Ihre persönlichen Daten',GARA_SPALTE1,GARA_ZEILE1+140,300,30
      end

      pdf.rotate(3, :origin => [GARA_SPALTE1,pdf.bounds.left]) do
        self.shade_box pdf,garantie_name, pdf.bounds.left,pdf.bounds.bottom+75,width_gara,30
      end
    end

  end

  def self.print_garantie_page_2 pdf, garantie

    if garantie.warranty_type == Garanty::Types::PREMIUM
      is_premium=true
      schadenssumme='15.000'
      width_gara=370
      garantie_name='    Wetterauer Premium Garantie '+garantie.warranty_years.to_s
    else
      is_premium=false
      schadenssumme='10.000'
      width_gara=350
      garantie_name='Wetterauer Tuning Garantie '+garantie.warranty_years.to_s
      if garantie.warranty_type == Garanty::Types::TUNING_MOBILE
      else
      end
    end
    pdf.canvas do
      pdf.image "#{Rails.root}/public/datasheet_pic_5.jpg",
                width: pdf.bounds.right-pdf.bounds.left,
                :at => [pdf.bounds.left, pdf.bounds.top]

      pdf.transparent(0.4) do
        pdf.fill_color '000000'
        pdf.stroke_color 'FFFFFF'
        pdf.fill_and_stroke do
          pdf.rounded_rectangle [GARA1_X,pdf.bounds.top-GARA1_Y] , GARA_BOX1_X,GARA_BOX1_Y,20
        end
      end

      pdf.bounding_box([ GARA1_X+GARA_MARGIN,pdf.bounds.top-GARA1_Y-GARA_MARGIN],
                       :width => GARA_BOX1_X-2*GARA_MARGIN, :height => GARA_BOX1_Y-2*GARA_MARGIN) do
        pdf.fill_color 'ffffff'
        pdf.font_size FONT_GARA_HEAD
        pdf.font "Helvetica", :style => :bold
        pdf.text I18n.t( 'garantie.premium_head.part1_head')
        pdf.font "Helvetica", :style => :normal
        pdf.font_size FONT_GARA_TEXT
        pdf.text replace_var(I18n.t( 'garantie.premium_head.part1' ),garantie),:align => :justify

        pdf.image "#{Rails.root}/public/logohead1.png",
                  width: 150,
                  :at => [100,50]
      end

      pdf.transparent(0.4
      ) do
        pdf.fill_color '000000'
        pdf.stroke_color 'FFFFFF'
        pdf.fill_and_stroke do
          pdf.rounded_rectangle [GARA2_X,pdf.bounds.top-GARA2_Y] , GARA_BOX2_X,GARA_BOX2_Y,20
        end
      end

      pdf.bounding_box([ GARA2_X+GARA_MARGIN,pdf.bounds.top-GARA2_Y-GARA_MARGIN],
                       :width => GARA_BOX2_X-2*GARA_MARGIN, :height => GARA_BOX2_Y-2*GARA_MARGIN) do
        pdf.fill_color 'ffffff'
        pdf.font_size FONT_GARA_HEAD
        pdf.font "Helvetica", :style => :bold
        pdf.text I18n.t( 'garantie.premium_head.part2_head')
        pdf.font "Helvetica", :style => :normal
        pdf.font_size FONT_GARA_TEXT
        pdf.text replace_var(I18n.t( 'garantie.premium_head.part2' ),garantie),:align => :justify
        pdf.text replace_var(I18n.t( 'garantie.premium_head.part3_head' ),garantie),:align => :justify
        pdf.text replace_var(I18n.t( 'garantie.premium_head.part3' ),garantie),:align => :justify
        pdf.image "#{Rails.root}/public/20years.png",
                  width: 60.55,
                  :at => [0,50]

      end
    end

    heigth =pdf.bounds.top-GARA_BOX1_Y-50
    pdf.bounding_box([0,heigth+30], :width => pdf.bounds.width, :height => heigth) do

      if( DEVELOPEMENT )
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end
      pdf.column_box([0,heigth], :columns => 3, :width =>  pdf.bounds.width, :height => heigth) do
        pdf.fill_color '000000'
        pdf.font "Helvetica", :style => :normal

        element_no=1
        while element_no<13
          if is_premium
            pdf.font_size FONT_PREMIUM_HEAD
            pdf.text replace_var(I18n.t( 'garantie.premium.part%d_head' % element_no ),garantie,schadenssumme),:align => :justify
          else
            pdf.font_size FONT_TUNING_HEAD
            pdf.text replace_var(I18n.t( 'garantie.tuning.part%d_head' % element_no ),garantie,schadenssumme),:align => :justify
          end

          if is_premium
            pdf.font_size FONT_PREMIUM_TEXT
            pdf.text replace_var(I18n.t( 'garantie.premium.part%d' % element_no ),garantie,schadenssumme),:align => :justify
          else
            pdf.font_size FONT_TUNING_TEXT
            pdf.text replace_var(I18n.t( 'garantie.tuning.part%d' % element_no ),garantie,schadenssumme),:align => :justify
          end


          pdf.text " "
          element_no+=1
        end
      end
    end

    self.bottom_logo(pdf)
  end

  def self.shade_box pdf,text,x,y,width,heigth
    pdf.fill_color 'aaaaaa'
    pdf.fill_rectangle [x,y] ,width,heigth
    pdf.fill_color 'cccccc'
    pdf.fill_rectangle [x-2,y+2] ,width,heigth
    pdf.fill_color '000000'
    pdf.draw_text text, :at => [x,y-heigth+9] , :size => heigth-6
  end

  def self.garantie_details pdf, spalte, zeile, text, inhalt
    pdf.bounding_box([spalte,zeile], :width => SPALTE_WIDTH, :height => SPALTE_HEIGTH) do

      if( DEVELOPEMENT )
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end
      pdf.stroke_rounded_rectangle [pdf.bounds.left,pdf.bounds.top], pdf.bounds.right-pdf.bounds.left,pdf.bounds.bottom-pdf.bounds.top,SPALTE_HEIGTH/3

      pdf.fill_color 'AAAAAA'
      pdf.draw_text text, :at => [GARA_SPALTE_TEXT_X,GARA_SPALTE_TEXT_Y] , :size => FONT_SPALTE_TEXT
      pdf.fill_color '000000'
      linefeed="\n"

      if( inhalt.include? "%lf")
        pdf.text_box inhalt.gsub( '%lf' , "#{linefeed}"), :at => [GARA_SPALTE_INHALT_X,GARA_SPALTE_INHALT_Y+12] , :size => FONT_SPALTE_INHALT-3
      else
        pdf.draw_text inhalt, :at => [GARA_SPALTE_INHALT_X,GARA_SPALTE_INHALT_Y] , :size => FONT_SPALTE_INHALT
      end
    end

  end

end

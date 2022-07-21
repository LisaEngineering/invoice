class Invoicepdf

  require "prawn/measurement_extensions"

  DEVELOPEMENT        = false

  FONT_SIZE=10

  #canvas 792x612
  PAGE_LEFT=0
  PAGE_RIGHT=180.mm
  PAGE_TOP=255.mm
  PAGE_BOTTOM=0
  PAGE_WIDTH=PAGE_RIGHT-PAGE_LEFT

  CPAGE_LEFT=0
  CPAGE_RIGHT=612
  CPAGE_TOP=792
  CPAGE_BOTTOM=0
  CPAGE_WIDTH=CPAGE_RIGHT-CPAGE_LEFT

  ADDRESS_BOX_WIDTH   = 90.mm
  ADDRESS_BOX_HEIGHT  = 45.mm
  ADDRESS_FONT = 10
  ADDRESS_X= 18.mm
  ADDRESS_Y= PAGE_TOP - 30.mm

  INFO_BOX_X          = PAGE_LEFT
  INFO_BOX_Y          = PAGE_TOP  - 80.mm
  INFO_BOX_WIDTH      = PAGE_RIGHT-PAGE_LEFT
  INFO_BOX_HEIGHT     = 10.mm
  INFO_BOX_MARGIN     = 3.mm
  INFO_BLOCK_FONT     = 12
  INFO_BOX_LINES      = false

  #rechtsbündig am rechten Rand
  INFO_BOX_R_WIDTH    = 60.mm
  INFO_BOX_R_X        = PAGE_WIDTH - INFO_BOX_R_WIDTH
  INFO_BOX_R_Y        = INFO_BOX_Y
  INFO_BOX_R_HEIGHT   = INFO_BOX_HEIGHT

  UPPER_BLOCK_WIDTH   = 50.mm
  UPPER_BLOCK_X       = PAGE_WIDTH - UPPER_BLOCK_WIDTH
  UPPER_BLOCK_Y       = PAGE_TOP  - 20.mm
  UPPER_BLOCK_HEIGHT  = 55.mm
  UPPER_BLOCK_FONT    = 10

  BODY_HEAD_X         = PAGE_LEFT
  BODY_HEAD_Y         = INFO_BOX_Y - 5.mm - INFO_BOX_HEIGHT
  BODY_HEAD_WIDTH     = PAGE_RIGHT-PAGE_LEFT-35.mm
  BODY_HEAD_HEIGHT    = 160.mm
  BODY_HEAD_HEIGHT_SECOND  = 250.mm
  BODY_DECISION_HEIGTH     = 130             # bis hierhin sollte es maximal egehen
  BODY_DECISION_WET_HEIGTH = 230
  BODY_MARGIN         = 2.mm
  BODY_BLOCK_FONT     = 10
  BODY_LINE_HEIGHT    = 10
  BODY_LINE_MARGIN    = 3

  MAX_ELEMENT_COUNT_WIDE = 7

  def self.invoice(pdf,invoice)
    if DEVELOPEMENT
      pdf.polygon [PAGE_LEFT,PAGE_TOP],[PAGE_RIGHT,PAGE_TOP],[PAGE_RIGHT,PAGE_BOTTOM],[PAGE_LEFT,PAGE_BOTTOM]
    end
    column=setup_column(invoice)
    setup(pdf)
    address_head(pdf,invoice.data.address)
    info_block(pdf,invoice)
    upper_block(pdf,invoice)
    body_content(pdf,column,invoice)
    #start_page(pdf,invoice)
  end


  def self.setup(pdf)
    pdf.font_size FONT_SIZE
  end

  def self.setup_column(invoice)
    # minimale Spaltenmaße
    # =>    0     1     2       3     4      5      6      7       8
    #       pos,  anz,  Einheit,Text, Preis, Rabatt,Preis, Rabatt, Preis,
    columns=[-8.mm,-8.mm,11.mm,65.mm,-18.mm,-11.mm,-18.mm,-11.mm,-18.mm]

    # Spalten berechnen
    if invoice.data.is_pos==0
      columns[0]=0
    end
    if invoice.data.is_rebate1==0
      columns[5]=0
      columns[6]=0
    end
    if invoice.data.is_rebate2==0
      columns[7]=0
    end

    # wenn alle Zeilen der Rabattspalten == 0 sind, dann Spalte ausblenden
    if columns[5] !=0
        if invoice.data.invoice_details.where("rebate1>0").length==0
            columns[5]=0
            columns[6]=0
        end
    end

    if columns[7] !=0
        if invoice.data.invoice_details.where("rebate2>0").length==0
            columns[7]=0

        end
    end

    # wenn zuviele Elemente, dann Spalten streichen und oder anpassen
    if invoice.data.invoice_details.length > MAX_ELEMENT_COUNT_WIDE
      if width(columns) > BODY_HEAD_WIDTH
        columns[5]=0
        columns[6]=0
        if width(columns) > BODY_HEAD_WIDTH
          columns[7]=0
        end
      end
    else
      # den Rest verteilenn auf die mittlere Spalte 3 (text)
      columns[3]+=PAGE_WIDTH-width(columns)
    end

    columns
  end

  def self.width(columns)
    width=0
    columns.each_with_index do |c,i|
      width+=((c>=0)? c:-c)
      if (i+1)<columns.length
        width+=BODY_MARGIN
      end
    end
    width
  end

  def self.start_page(pdf,invoice)
    pdf.start_new_page( :size => "A4", :layout => :portrait)
    Pdf::Forms.print_letter(pdf, invoice.data.company,false)
  end

  def self.address_head(pdf,address)
    pdf.bounding_box([ADDRESS_X, ADDRESS_Y], :width => ADDRESS_BOX_WIDTH, :height => ADDRESS_BOX_HEIGHT) do
      if DEVELOPEMENT
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end
      pdf.font_size ADDRESS_FONT
      pdf.text address.name||""
      address.name2||=""
      if !address.name2.empty?
        pdf.text address.name2
      end
      pdf.text address.str||""
      address.str2||=""
      if !address.str2.empty?
        pdf.text address.str2
      end
      pdf.text " "
      pdf.text [address.country||"",address.zip||"",address.city||""].map(&:presence).compact.join(' ')
    end
  end

  def self.info_block(pdf,invoice)

    pdf.font_size ADDRESS_FONT
    pdf.bounding_box([INFO_BOX_X, INFO_BOX_Y], :width => INFO_BOX_WIDTH, :height => INFO_BOX_HEIGHT) do

      if INFO_BOX_LINES
        pdf.transparent(0.5) {
          pdf.stroke do
            pdf.stroke_color '000000'
            pdf.line_width 0.1.mm
            pdf.move_to 0,INFO_BOX_HEIGHT
            pdf.line_to INFO_BOX_WIDTH,INFO_BOX_HEIGHT
          end

          pdf.stroke do
            pdf.move_to 0,0
            pdf.line_to INFO_BOX_WIDTH,0
          end
        }
      end
    end

    pdf.bounding_box([INFO_BOX_X, INFO_BOX_Y-INFO_BOX_MARGIN], :width => INFO_BOX_WIDTH, :height => INFO_BOX_HEIGHT-2*INFO_BOX_MARGIN) do
      pdf.font_size INFO_BLOCK_FONT
      pdf.text invoice.type_name
    end

    # rechter Block, links
    #pdf.bounding_box([INFO_BOX_R_X, INFO_BOX_R_Y-INFO_BOX_MARGIN], :width => INFO_BOX_R_WIDTH, :height => INFO_BOX_R_HEIGHT-2*INFO_BOX_MARGIN) do
    #  pdf.text invoice.customer_no_t
    #end

    # rechter Block, rechts
    #pdf.bounding_box([INFO_BOX_R_X, INFO_BOX_R_Y-INFO_BOX_MARGIN], :width => INFO_BOX_R_WIDTH, :height => INFO_BOX_R_HEIGHT-2*INFO_BOX_MARGIN) do
    #  pdf.text invoice.customer_no, :align => :right
    #end
  end

  HEAD1 = ["Pos.","Anz.","Einheit","Beschreibung","Basis","Aktion","Preis","Rabatt","Endpreis"]
  HEAD2 = ["","","","","€","%","€","%","€"]

  def self.body_content(pdf,column,invoice)

    pdf.font_size BODY_BLOCK_FONT

    # Head
    y_position = BODY_HEAD_HEIGHT
    y_position = print_head(pdf,column,invoice,y_position)

    # Details Rows
    last_reference=""
    invoice.data.invoice_details.sort { |a,b| a.pos <=> b.pos }.each do |details|

      print_reference=false
      # if there is a reference column, show it
      if last_reference != details.reference
        last_reference = details.reference
        if !details.reference.blank?
          print_reference=true
        end
      end

      line_height = (1+((invoice.data.address.is_tax && invoice.data.company.is_tax)? 0:1)+((print_reference)? 1:0))*BODY_LINE_HEIGHT
      # Seitenwechsel, passt die Zeile noch hin ?
      body_decision = BODY_DECISION_HEIGTH
      if( invoice.data.company_id<3 )
        body_decision = BODY_DECISION_WET_HEIGTH
      end

      if  (y_position-line_height) < body_decision
        print_middle_sum(pdf,column,invoice,y_position)
        start_page(pdf,invoice)
        y_position = BODY_HEAD_HEIGHT_SECOND
        y_position = print_head(pdf,column,invoice,y_position)
      end

      if print_reference
        y_position=print_lines(pdf,column, invoice.details_reference(details) , nil , y_position )
      end

      y_position=print_lines(pdf,column, invoice.details_row(details) , invoice.details_second_row(details) , y_position )
    end


    y_position = print_sum(pdf, column, invoice, y_position )
    print_payment(pdf,invoice,y_position)
    y_position-=2*BODY_LINE_HEIGHT
    print_disclaimer(pdf,invoice,y_position)
  end

  def self.print_head(pdf,column,invoice,y_position)
    print_hair_line(pdf,column,y_position+BODY_LINE_MARGIN)
    y_position=print_lines(pdf,column, HEAD1 , HEAD2, y_position )
    print_hair_line(pdf,column,y_position)
    y_position-=BODY_LINE_MARGIN
  end

  def self.print_hair_line(pdf, column, y_position, double=false)
    if double
      transparency=1
    else
      transparency=0.5
    end

    pdf.transparent(transparency) {
      pdf.stroke do
        if double
          pdf.line_width 0.3.mm
        else
          pdf.line_width 0.1.mm
        end
        pdf.move_to 0,y_position
        pdf.line_to width(column),y_position
      end
    }
  end

  def self.print_lines(pdf,column,text1,text2,y_position, shade=1)
    lines_used1=print_line(pdf,column,text1,y_position,1*shade)
    lines_used2=0
    if text2 != nil
      lines_used2=print_line(pdf,column,text2,y_position-BODY_LINE_HEIGHT,0.5*shade)
    end

    # Margin zwischen Zeilen
    y_position-=BODY_LINE_MARGIN+BODY_LINE_HEIGHT*[lines_used1,lines_used2+1].max
  end

  def self.print_line(pdf,column,text,y_position,shade)

    col=0
    lines_used = 1
    text.each_with_index do |t,i|
      c=column[i]
      left_aligned=(c>=0)
      c=((c>=0)? c:-c)

      if c!=0
        if i==3
          if !t.empty?
            # den Text auf mehrere Zeilen aufteilen
            text=t
            y_position_copy=y_position
            lines_used=0
            # Spalte 3 mit dem Text anders behandeln
            while not text.empty?
              text = pdf.text_box text, :width => c, :height => 10, :overflow => :truncate, :at => [col,y_position_copy]
              y_position_copy-=10
              lines_used+=1
            end
          end
        else
          pdf.bounding_box([col, y_position], :width => c, :height => 10) do
            if DEVELOPEMENT
              pdf.transparent(0.5) { pdf.stroke_bounds }
            end
            pdf.transparent(shade) {
              if left_aligned
                pdf.text t
              else
                pdf.text t, :align => :right
              end
            }
          end
        end
        col+=c+BODY_MARGIN
      else
        col+=c
      end
    end
    lines_used
  end

  def self.print_middle_sum(pdf,column,invoice,y_position)
    print_hair_line(pdf,column,y_position)
    y_position-=BODY_LINE_MARGIN

    line=invoice.zwischen_summe
    if line != nil
      y_position=print_lines(pdf,column, line , nil, y_position ,0.5)
      print_hair_line(pdf,column,y_position)
      y_position-=BODY_LINE_MARGIN
    end

    y_position
  end

  def self.print_sum(pdf,column,invoice,y_position)
    print_hair_line(pdf,column,y_position)
    y_position-=BODY_LINE_MARGIN

    # Zeile 1
    line=invoice.sum(1)
    if line != nil
      y_position=print_lines(pdf,column, line , nil, y_position ,0.5)
      print_hair_line(pdf,column,y_position)
      y_position-=BODY_LINE_MARGIN
    end

    line=invoice.sum(2)
    if line != nil
      y_position=print_lines(pdf,column, line , nil, y_position )
      print_hair_line(pdf,column,y_position)
      y_position-=BODY_LINE_HEIGHT
    end

    y_position=print_lines(pdf,column, invoice.sum(3) , nil, y_position )
    print_hair_line(pdf,column,y_position,true)
    y_position
  end

  def self.upper_block(pdf,invoice)
    pdf.font_size ADDRESS_FONT
    pdf.bounding_box([UPPER_BLOCK_X, UPPER_BLOCK_Y], :width => UPPER_BLOCK_WIDTH, :height => UPPER_BLOCK_HEIGHT) do
      if DEVELOPEMENT
        pdf.transparent(0.5) { pdf.stroke_bounds }
      end

      if( invoice.data.invoice_type == Invoicepresenter::Types::INVOICE || invoice.data.invoice_type == Invoice::Presenter::Types::STORNO)
        pdf.text I18n.t('invoice.invoice_no')
      else
        pdf.text I18n.t('invoice.document_no')
      end

      pdf.text I18n.t('invoice.date')
      pdf.text I18n.t('invoice.deliver')
      pdf.text I18n.t('invoice.customer_no')
      if !invoice.data.address.accountance.blank?
        pdf.text I18n.t('invoice.your_accountance_no')
      end
      if !invoice.data.company.tax_no.blank?
        pdf.text I18n.t('invoice.your_uid_no')
      end
      pdf.text I18n.t('invoice.issuer')
    end

    pdf.bounding_box([UPPER_BLOCK_X, UPPER_BLOCK_Y], :width => UPPER_BLOCK_WIDTH, :height => UPPER_BLOCK_HEIGHT) do
      pdf.text invoice.data.number.to_s, :align => :right
      pdf.text invoice.data.invoice_date.strftime('%d.%m.%Y'), :align => :right
      pdf.text invoice.data.deliver.strftime('%d.%m.%Y'), :align => :right
      pdf.text invoice.data.address.id.to_s, :align => :right
      if !invoice.data.address.accountance.blank?
        pdf.text invoice.data.address.accountance, :align => :right
      end
      if !invoice.data.company.tax_no.blank?
        pdf.text invoice.data.company.tax_no, :align => :right
      end
      pdf.text invoice.data.issuer, :align => :right
    end
  end

  def self.print_payment(pdf,invoice, y_position)
    if( invoice.data.invoice_type == Invoicepresenter::Types::INVOICE)
      y_position-=BODY_LINE_HEIGHT
      pdf.text_box invoice.payment, :width => BODY_HEAD_WIDTH, :height => 20, :overflow => :truncate, :at => [BODY_HEAD_X,y_position]
    end
  end

  def self.print_disclaimer(pdf,invoice,y_position)
    y_position-=BODY_LINE_HEIGHT
    pdf.text_box invoice.disclaimer, :width => PAGE_RIGHT-PAGE_LEFT, :height => BODY_LINE_HEIGHT*4, :overflow => :truncate, :at => [BODY_HEAD_X,y_position]
  end

end

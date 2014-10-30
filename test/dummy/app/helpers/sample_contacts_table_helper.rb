module SampleContactsTableHelper
  SAMPLE_CONTACTS_TABLE_COLUMNS = [
      {field: :name},
      {field: :email},
      {field: :phone, text: 'Phone Number'},
      {field: :city},
  ]

  SAMPLE_CONTACTS_TABLE_COLUMN_FIELDS = SAMPLE_CONTACTS_TABLE_COLUMNS.collect { |col| col[:field] }

  def render_sample_contacts_table
    data = sample_contacts_data
    aaData = data.collect do |contact|
      row = {}
      SAMPLE_CONTACTS_TABLE_COLUMN_FIELDS.each_with_index do |col_field, i|
        row[col_field] = contact[col_field]
      end
      row
    end

    {
        sEcho: params[:sEcho],
        iTotalRecords: data.count,
        iTotalDisplayRecords: data.count,
        aaData: aaData
    }
  end

  def sample_contacts_data
    [
        {name: 'Zoe', email: 'lectus.pede.ultrices@magna.co.uk', phone: '(671) 156-1361', city: 'Midway'},
        {name: 'Quinn', email: 'massa@Maurisvestibulumneque.net', phone: '(107) 876-7716', city: 'Meerhout'},
        {name: 'Wanda', email: 'nec.tellus.Nunc@cursuspurus.org', phone: '(468) 579-1720', city: 'Kapfenberg'},
        {name: 'Rooney', email: 'adipiscing.lobortis@ligulatortor.com', phone: '(974) 807-1631', city: 'San Felice a Cancello'},
        {name: 'Winter', email: 'mi.tempor.lorem@aliquetlibero.co.uk', phone: '(262) 263-7459', city: 'Floriffoux'},
        {name: 'Wyatt', email: 'Morbi.neque@Donecegestas.edu', phone: '(860) 729-2345', city: 'Nagaon'},
        {name: 'Halla', email: 'amet@scelerisque.co.uk', phone: '(690) 829-2149', city: 'Qualicum Beach'},
        {name: 'Honorato', email: 'morbi.tristique.senectus@Cras.org', phone: '(680) 604-8447', city: 'Tuktoyaktuk'},
        {name: 'Madonna', email: 'ultrices.Duis@sapienimperdietornare.org', phone: '(800) 397-1857', city: 'Cabo de Santo Agostinho'},
        {name: 'Lacota', email: 'ligula@noncursusnon.org', phone: '(250) 236-9544', city: 'San Diego'},
        {name: 'Daphne', email: 'malesuada.id.erat@Suspendisse.org', phone: '(696) 268-0615', city: 'Coimbatore'},
        {name: 'Lane', email: 'tellus@Integer.org', phone: '(284) 728-8759', city: 'Naperville'},
        {name: 'Hiroko', email: 'vitae.aliquam@euismodmauris.com', phone: '(222) 829-7208', city: 'Ramskapelle'},
        {name: 'Signe', email: 'Proin.vel@erosnec.com', phone: '(321) 785-6449', city: 'Blois'},
        {name: 'Kimberly', email: 'risus.varius@nec.com', phone: '(621) 699-3965', city: 'Rouyn-Noranda'},
        {name: 'Madonna', email: 'orci.lacus@velitAliquamnisl.net', phone: '(934) 261-5292', city: 'Villa Faraldi'},
        {name: 'Carter', email: 'Aliquam@tellusimperdietnon.ca', phone: '(346) 762-9338', city: 'Budaun'},
        {name: 'Levi', email: 'feugiat@Sedeget.org', phone: '(492) 780-9803', city: 'Helmsdale'},
        {name: 'Craig', email: 'Pellentesque.ultricies.dignissim@Proinegetodio.co.uk', phone: '(659) 796-4640', city: 'Albiano'},
        {name: 'Keith', email: 'Nam@quamdignissim.edu', phone: '(420) 594-6778', city: 'Monte Vidon Corrado'},
        {name: 'Robin', email: 'nunc@auctor.edu', phone: '(197) 442-7935', city: 'Donnas'},
        {name: 'John', email: 'sit.amet.ultricies@dolorQuisque.org', phone: '(510) 948-8275', city: 'Helena'},
        {name: 'Wyatt', email: 'neque.Sed.eget@semelitpharetra.edu', phone: '(963) 841-0938', city: 'San Fratello'},
        {name: 'Emi', email: 'mollis.Integer.tincidunt@nec.co.uk', phone: '(139) 594-2677', city: 'Port Coquitlam'},
        {name: 'Leigh', email: 'amet@turpis.net', phone: '(483) 752-2043', city: 'Neuruppin'},
        {name: 'Meghan', email: 'vulputate@interdumSedauctor.edu', phone: '(383) 899-8348', city: 'Cannock'},
        {name: 'Burke', email: 'arcu.Sed@eget.org', phone: '(185) 269-2680', city: 'Anglet'},
        {name: 'Peter', email: 'Curabitur.ut@elitAliquam.co.uk', phone: '(303) 518-2652', city: 'Issy-les-Moulineaux'},
        {name: 'Kelly', email: 'nec.ante.blandit@Cras.co.uk', phone: '(925) 420-1519', city: 'Limburg a.d. Lahn'},
        {name: 'Allistair', email: 'placerat.velit@nibh.ca', phone: '(582) 334-1899', city: 'Shipshaw'},
        {name: 'Alfonso', email: 'arcu.Vestibulum.ante@diamdictum.org', phone: '(846) 312-6239', city: 'Fleurus'},
        {name: 'Fuller', email: 'vel.quam@auctorvelit.org', phone: '(458) 158-0533', city: 'North Bay'},
        {name: 'Kim', email: 'justo.faucibus@sagittis.org', phone: '(994) 670-5208', city: 'Marbella'},
        {name: 'Octavius', email: 'ornare.tortor@urna.co.uk', phone: '(949) 232-2816', city: 'Oyen'},
        {name: 'Rooney', email: 'Sed.auctor.odio@neque.co.uk', phone: '(421) 935-3732', city: 'Moffat'},
        {name: 'Ruby', email: 'nunc.sit@at.co.uk', phone: '(974) 636-8011', city: 'Covington'},
        {name: 'Rose', email: 'pellentesque.Sed.dictum@Morbi.edu', phone: '(821) 704-4255', city: 'Olmen'},
        {name: 'Nola', email: 'massa.non@urnaNullamlobortis.net', phone: '(401) 555-6622', city: 'Warspite'},
        {name: 'Marshall', email: 'auctor@a.org', phone: '(346) 210-8801', city: 'Swindon'},
        {name: 'Astra', email: 'vel.venenatis.vel@enimSednulla.org', phone: '(531) 723-9624', city: 'Isca sullo Ionio'},
        {name: 'Jenna', email: 'tempus@vel.ca', phone: '(400) 902-6573', city: 'Hamilton'},
        {name: 'Tashya', email: 'mauris.ipsum@nuncsedpede.org', phone: '(978) 903-0851', city: 'Cawdor'},
        {name: 'Conan', email: 'mauris.sagittis@Donec.net', phone: '(923) 303-5185', city: 'Hunstanton'},
        {name: 'Len', email: 'eu.eleifend.nec@disparturientmontes.net', phone: '(521) 874-5266', city: 'Villers-Perwin'},
        {name: 'Ifeoma', email: 'sit@diamPellentesquehabitant.co.uk', phone: '(441) 120-3553', city: 'Vellore'},
        {name: 'Lewis', email: 'ut.aliquam.iaculis@laciniaSed.org', phone: '(293) 870-8537', city: 'Waarloos'},
        {name: 'Dalton', email: 'lacus@urnaVivamusmolestie.ca', phone: '(505) 919-8332', city: 'Dera Ghazi Khan'},
        {name: 'Daniel', email: 'Phasellus.ornare.Fusce@eget.ca', phone: '(733) 452-9924', city: 'Russell'},
        {name: 'Kimberley', email: 'Quisque@mauris.co.uk', phone: '(811) 559-5406', city: 'Hearst'},
        {name: 'Noelani', email: 'risus.Duis.a@lacusQuisqueimperdiet.net', phone: '(500) 170-3533', city: 'Cannalonga'},
        {name: 'Mufutau', email: 'consequat.purus@liberoProin.co.uk', phone: '(462) 945-3855', city: 'Eisleben'},
        {name: 'Lynn', email: 'ut.eros.non@lobortis.net', phone: '(204) 101-2478', city: 'Gojra'},
        {name: 'MacKensie', email: 'lacus.vestibulum.lorem@sedhendrerita.co.uk', phone: '(352) 345-2494', city: 'Guildford'},
        {name: 'Julie', email: 'nisi@Duisrisus.org', phone: '(716) 834-3637', city: 'Marcinelle'},
        {name: 'Paloma', email: 'venenatis.vel.faucibus@nonsollicitudin.net', phone: '(517) 919-6133', city: 'Ercolano'},
        {name: 'Carl', email: 'quis@auctornuncnulla.edu', phone: '(623) 273-2834', city: 'San Pietro Mussolino'},
        {name: 'Jorden', email: 'faucibus@amet.edu', phone: '(265) 105-3023', city: 'Belgaum'},
        {name: 'Hu', email: 'nec.malesuada@Quisqueac.ca', phone: '(393) 317-2801', city: 'Frigento'},
        {name: 'Akeem', email: 'purus@sitametconsectetuer.org', phone: '(913) 928-0242', city: 'Barrie'},
        {name: 'Naida', email: 'mollis@Aliquamnisl.edu', phone: '(869) 985-9752', city: 'Innisfail'},
        {name: 'Wilma', email: 'turpis@tinciduntadipiscing.co.uk', phone: '(374) 771-3223', city: 'Bathgate'},
        {name: 'Arden', email: 'nec.ante@Mauris.ca', phone: '(136) 125-6858', city: 'Massa e Cozzile'},
        {name: 'Dana', email: 'turpis.In@Namac.edu', phone: '(234) 952-7720', city: 'Bolsward'},
        {name: 'Lucas', email: 'mi.enim.condimentum@eratEtiam.net', phone: '(679) 176-5139', city: 'Matlock'},
        {name: 'Jaquelyn', email: 'natoque@lectus.net', phone: '(713) 436-0916', city: 'Dawson Creek'},
        {name: 'Ulysses', email: 'eu.placerat.eget@luctuset.co.uk', phone: '(822) 333-4922', city: 'Radicofani'},
        {name: 'Ebony', email: 'nunc.nulla.vulputate@semPellentesqueut.org', phone: '(832) 400-2770', city: 'Beaconsfield'},
        {name: 'Ariana', email: 'Pellentesque.ultricies.dignissim@enimnectempus.co.uk', phone: '(391) 453-4527', city: 'Comeglians'},
        {name: 'Demetrius', email: 'facilisis.facilisis.magna@idmollis.com', phone: '(964) 708-0756', city: 'Duncan'},
        {name: 'Wing', email: 'neque.Nullam@nuncrisusvarius.edu', phone: '(544) 190-3768', city: 'Vosselaar'},
        {name: 'Debra', email: 'erat@dui.org', phone: '(801) 679-4624', city: 'Loppem'},
        {name: 'Lucius', email: 'natoque.penatibus@cubiliaCuraePhasellus.ca', phone: '(246) 549-0748', city: 'Valtournenche'},
        {name: 'Declan', email: 'imperdiet.dictum@duiFusce.edu', phone: '(495) 836-9510', city: 'Forio'},
        {name: 'Leroy', email: 'In.lorem.Donec@Curabiturmassa.org', phone: '(970) 853-0997', city: 'Amstetten'},
        {name: 'Ariana', email: 'lectus@aaliquetvel.co.uk', phone: '(367) 225-0724', city: 'Darmstadt'},
        {name: 'Claudia', email: 'feugiat@a.ca', phone: '(379) 900-4887', city: 'Ligney'},
        {name: 'Alan', email: 'nec@rhoncusProin.co.uk', phone: '(232) 849-4774', city: 'Forges'},
        {name: 'Illiana', email: 'consequat@scelerisquedui.edu', phone: '(523) 902-6097', city: 'Paal'},
        {name: 'Montana', email: 'ut.ipsum@velitduisemper.ca', phone: '(291) 545-0239', city: 'Tielen'},
        {name: 'Dora', email: 'risus@molestie.org', phone: '(813) 334-9614', city: 'Jauche'},
        {name: 'Ivan', email: 'non.nisi@primisinfaucibus.co.uk', phone: '(284) 575-9222', city: 'Canora'},
        {name: 'Malachi', email: 'Ut@risus.co.uk', phone: '(934) 908-7001', city: 'Norfolk'},
        {name: 'Leigh', email: 'ac.tellus@risusvarius.edu', phone: '(673) 468-8606', city: 'Jodoigne-Souveraine'},
        {name: 'Gary', email: 'arcu@adipiscing.net', phone: '(538) 435-8358', city: 'Rawalpindi'},
        {name: 'Shelly', email: 'eleifend.egestas.Sed@convalliserateget.edu', phone: '(462) 823-6165', city: 'Shivapuri'},
        {name: 'Steven', email: 'ante.ipsum@ultricesDuis.org', phone: '(610) 829-1121', city: 'Cassano Spinola'},
        {name: 'Omar', email: 'Sed.auctor@maurisipsum.co.uk', phone: '(706) 755-3963', city: 'Mount Isa'},
        {name: 'Dalton', email: 'Sed.pharetra@tempor.co.uk', phone: '(992) 554-2839', city: 'Glasgow'},
        {name: 'Alec', email: 'ut.lacus.Nulla@urnajusto.com', phone: '(160) 821-4834', city: 'Kingston'},
        {name: 'Graham', email: 'Donec@velitegestaslacinia.co.uk', phone: '(834) 256-2760', city: 'Ruoti'},
        {name: 'Finn', email: 'imperdiet@Proinnislsem.net', phone: '(163) 469-1080', city: 'Calvello'},
        {name: 'Jared', email: 'rutrum.lorem@fringilla.ca', phone: '(874) 749-5820', city: 'Le Mans'},
        {name: 'Aquila', email: 'lorem.ipsum.sodales@lobortis.net', phone: '(865) 126-3755', city: 'Lenna'},
        {name: 'Jameson', email: 'Pellentesque@egestas.edu', phone: '(663) 581-7039', city: 'Vanier'},
        {name: 'Beatrice', email: 'sodales.elit@sodalesatvelit.ca', phone: '(169) 104-3927', city: 'Okara'},
        {name: 'Kalia', email: 'rhoncus@nonummy.com', phone: '(366) 439-1903', city: 'Workum'},
        {name: 'Adrian', email: 'consequat.lectus.sit@Nuncpulvinar.co.uk', phone: '(494) 497-5254', city: 'Fulda'}
    ]
  end
end